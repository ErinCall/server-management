from fabric.api import cd, run, sudo, env, execute, task, local
from datetime import datetime

env.hosts = ['andrewlorente.com']
apps = {
    'bloge': ['bloge@andrewlorente.com'],
    'andrewlorente': ['andrewlorente@andrewlorente.com'],
}

@task
def deploy(app):
    if app not in apps.keys():
        raise Exception("Unknown deploy target '{0}'".format(app))

    release_id = datetime.now().strftime("%Y%m%d%H%M%S")

    execute(build, app, release_id, hosts=apps[app])
    execute(release, app, hosts=['alorente@andrewlorente.com'])

def build(app, release_id):
    release_dir = "/u/apps/{0}/releases/{1}".format(app, release_id)
    repo = "https://github.com/AndrewLorente/{0}.git".format(app)
    run("git clone -q {0} {1}".format(repo, release_dir))

    with cd(release_dir):
        run("cabal update")
        run("cabal install --constraint 'template-haskell installed' "
            "--dependencies-only --force-reinstall")
        run("cabal configure")
        run("cabal build")
    run("ln -nfs {0} /u/apps/{1}/current".format(release_dir, app))

def release(app):
    sudo("initctl restart " + app)

@task
def puppet():
    local('bundle exec cap production puppet:apply')
