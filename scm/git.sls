#!pydsl

'''
Script that I can use to keep my git repositories synced on all
my machines.

You pass in a Pillar to define the repositories you want to have
pulled to the latest version from GitHub. If you pass in 'all'
it will sync all of your public repositories.

Example Usage:
    # All my repos (defaults to master branch, user defaults to DEFAULTUSER)
    salt '*' state.sls scm.git pillar='{repos: all}'
    # dev branches for trello-rss and sublimesync
    salt '*' state.sls scm.git pillar='{repos: [trello-rss, sublimesync] branch: dev}'
    # develop branch of salt
    salt '*' state.sls scm.git pillar='{repos: [salt], user: saltstack, branch: develop}'

TODO - add support for private repos.
'''

import urllib2
import json

DEFAULTUSER = 'naiyt'

def get_path(repo):
    '''
    For consistency, I'm keeping all my git repositories in 
    /home/user/source/git/{repo} on all my machines. Could be a bit more
    sophisticated in grabbing the username, but my machines only have one
    of two names currently.
    '''

    user = 'nate'
    path = None
    if __grains__['id'].startswith('pi'):
        user = 'pi'
    path = '/home/{}/source/git/{}'.format(user, repo)
    return path, user

def get_repos(repos, user, forks=False):
    '''
    Contacts the GitHub api to make sure you have said repos, and gets
    the ssh_url. Doesn't pull forks by default.
    '''

    url = 'https://api.github.com/users/{}/repos'.format(user)
    data = json.loads(urllib2.urlopen(url).read())
    repo_info = {k['name'] : k['ssh_url'] for k in data if k['fork'] == False}
    if forks:
        repo_info = {k['name'] : k['ssh__url'] for k in data}
    if repos == 'all':
        return repo_info
    else:
        return {k: v for k, v in repo_info.iteritems() if k in repos}

user = DEFAULTUSER
if 'user' in __pillar__:
    user = __pillar__['user']
branch = 'master'
if 'branch' in __pillar__:
    branch = __pillar__['branch']

repos = get_repos(__pillar__['repos'], user)
for name, url in repos.iteritems():
    path, user = get_path(name)
    new_sync = state(url)
    new_sync.git.latest(rev=branch, target=path, user=user)
