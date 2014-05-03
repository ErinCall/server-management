from fabric.api import cd, run, sudo, env, execute, task, local
from datetime import datetime

env.hosts = ['andrewlorente.com']
@task
def deploy(app):
    if app not in apps.keys():
        raise Exception("Unknown deploy target '{0}'".format(app))

    release_id = datetime.now().strftime("%Y%m%d%H%M%S")
    release_dir = "/u/apps/{0}/releases/{1}".format(app, release_id)

    execute(checkout, app, release_dir, hosts=apps[app]['hosts'])
    execute(apps[app]['build'], app, release_dir, hosts=apps[app]['hosts'])
    execute(restart, app, hosts=['alorente@andrewlorente.com'])

def checkout(app, release_dir):
    repo = "https://git.andrewlorente.com/AndrewLorente/{0}.git".format(app)
    run("git clone -q {0} {1}".format(repo, release_dir))

def build_haskell(app, release_dir):
    with cd(release_dir):
        run("cabal update")
        run("cabal install --constraint 'template-haskell installed' "
            "--dependencies-only --force-reinstall")
        run("cabal configure")
        run("cabal build")
    run("ln -nfs {0} /u/apps/{1}/current".format(release_dir, app))

def build_python(app, release_dir):
    with cd(release_dir):
        run("virtualenv Env")
        run("source Env/bin/activate")
        run("Env/bin/python setup.py develop")
    run("ln -nfs {0} /u/apps/{1}/current".format(release_dir, app))

def restart(app):
    sudo("initctl restart " + app)

@task
def puppet():
    local('bundle exec cap production puppet:apply')

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
        'build': build_python,
        'hosts': ['catsnap@andrewlorente.com'],
    },
}

