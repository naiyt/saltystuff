vim:
    pkg.installed

/etc/vim/vimrc.local:
    file.managed:
        - source: salt://edit/vimrc.local
        - mode: 644
        - user: root
        - group: root
