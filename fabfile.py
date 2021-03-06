from fabric.api import cd, run, sudo, env, execute, task, settings
from datetime import datetime
from collections import OrderedDict

env.hosts = ['ecall@erincall.com']

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
    execute(bounce, app_name, hosts=['ecall@erincall.com'])

def checkout(repo, release_dir):
    repo = "https://github.com/ErinCall/{0}.git".format(repo)
    run("git clone -q {0} {1}".format(repo, release_dir))

def build_haskell(app, release_dir):
    with cd(release_dir):
        run("cabal update")
        run("cabal install --constraint 'template-haskell installed' "
            "--dependencies-only --force-reinstall --reorder-goals")
        run("cabal configure")
        run("cabal build")

def build_js(app, release_dir):
    with cd(release_dir):
        run("npm install")

def config_yml(app, release_dir):
    run("ln -nfs /home/{0}/shared/config.yml "
        "{1}/{0}/config/config.yml".format(app, release_dir))

def dotenv(app, release_dir):
    run("ln -nfs /home/{0}/shared/.env {1}/.env".format(app, release_dir))

def update_symlink(app, release_dir):
    run("ln -nfs {0} /home/{1}/current".format(release_dir, app))

@task
def bounce(app_name):
    app = apps[app_name]
    if 'services' in app:
        services = app['services']
    else:
        services = [app_name]

    for service in services:
        with settings(warn_only=True):
            result = sudo("initctl restart " + service)
        if result.return_code == 1:
            sudo("initctl start " + service)

@task
def list_apps():
    for app_name in apps.keys():
        print app_name

apps = OrderedDict([
    ('bloge', {
        'build': build_haskell,
        'hosts': ['bloge@erincall.com'],
    }),
    ('www', {
        'build': build_haskell,
        'hosts': ['www@erincall.com'],
        'repo': 'erincall'
    }),
])

