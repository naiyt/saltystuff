# I realize this formula isn't ideal, since it's not extensible
# for other os's (just my Debian based ones I use currently).
# I'll probably want to use something like this formula instead
# at some point, for better targeting: https://github.com/saltstack/salt-vim  
vim:
    pkg.installed

vimrc:
    file.managed:
        - name: /etc/vim/vimrc.local
        - source: salt://edit/vim/vimrc.local
        - mode: 644
        - user: root
        - group: root

plugins:
    file.recurse:
        - name: /etc/vim/bundle
        - source: salt://edit/vim/bundle
        - require:
            - pkg: vim

installvundle:
    cmd.run:
        # Kinda nasty, I don't get back err's from Vundle here
        - name: vim +BundleInstall +qall > /dev/null
        - require:
            - file: plugins
