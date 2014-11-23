from fabric.api import cd, run, sudo, env, execute, task, local
from datetime import datetime

env.hosts = ['andrewlorente.com']

@task
def deploy(app_name):
    if app_name not in apps.keys():
        raise Exception("Unknown deploy target '{0}'".format(app_name))

    app = apps[app_name]
    release_id = datetime.now().strftime("%Y%m%d%H%M%S")
    release_dir = "/home/{0}/releases/{1}".format(app_name, release_id)
    repo = app.get('repo', app_name)

    execute(checkout, repo, release_dir, hosts=app['hosts'])
    execute(app['build'], app_name, release_dir, hosts=app['hosts'])
    if 'extra' in app:
        extra = app['extra']
        if hasattr(extra, '__iter__'):
            for action in extra:
                execute(action, app_name, release_dir, hosts=app['hosts'])
        else:
            execute(extra, app_name, release_dir, hosts=app['hosts'])

    execute(update_symlink, app_name, release_dir, hosts=app['hosts'])
    if 'restart' in app:
        for service in app['restart']:
            execute(restart, service, hosts=['alorente@andrewlorente.com'])
    else:
        execute(restart, app_name, hosts=['alorente@andrewlorente.com'])

def checkout(repo, release_dir):
    repo = "https://git.andrewlorente.com/AndrewLorente/{0}.git".format(repo)
    run("git clone -q {0} {1}".format(repo, release_dir))

def build_haskell(app, release_dir):
    with cd(release_dir):
        run("cabal update")
        run("cabal install --constraint 'template-haskell installed' "
            "--dependencies-only --force-reinstall")
        run("cabal configure")
        run("cabal build")

def build_js(app, release_dir):
    with cd(release_dir):
        run("npm install")

def build_python_with_setup(app, release_dir):
    return build_python(app, release_dir, 'Env/bin/python setup.py develop')

def build_python_with_requirements(app, release_dir):
    return build_python(app, release_dir, 'Env/bin/pip install -r requirements.txt')

def build_python(app, release_dir, requirements_command):
    with cd(release_dir):
        run("virtualenv Env")
        run("source Env/bin/activate")
        run(requirements_command)

def dotenv(app, release_dir):
    run("ln -nfs /home/{0}/shared/.env {1}/.env".format(app, release_dir))

def yoyo_migrate(app, release_dir):
    run("DATABASE_URL=$(grep DATABASE_URL {0}/.env | sed s/DATABASE_URL=//); "
        "{0}/Env/bin/yoyo-migrate -b apply {0}/migrations $DATABASE_URL".
        format(release_dir))

def update_symlink(app, release_dir):
    run("ln -nfs {0} /home/{1}/current".format(release_dir, app))

def restart(app):
    sudo("initctl restart " + app)

apps = {
    'bloge': {
        'build': build_haskell,
        'hosts': ['bloge@andrewlorente.com'],
    },
    'andrewlorente': {
        'build': build_haskell,
        'hosts': ['andrewlorente@andrewlorente.com'],
    },
    'catsnap': {
        'build': build_python_with_setup,
        'hosts': ['catsnap@andrewlorente.com'],
        'extra': [dotenv, yoyo_migrate],
        'restart': ['catsnap', 'catsnap-worker']
    },
    'identity': {
        'build': build_python_with_requirements,
        'hosts': ['identity@andrewlorente.com'],
        'extra': dotenv,
    },
    'paste': {
        'build': build_js,
        'hosts': ['paste@andrewlorente.com'],
        'repo': 'haste-server',
    },
}

