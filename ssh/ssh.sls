openssh-client:
  pkg.installed
openssh-server:
  pkg.installed

ssh:
  service.running:
    - require:
      - pkg: openssh-client
      - pkg: openssh-server
      - file: /etc/ssh/banner
      - file: /etc/ssh/sshd_config
    - watch:
        - pkg: openssh-client
        - pkg: openssh-server
        - file: /etc/ssh/banner
        - file: /etc/ssh/sshd_config

/etc/ssh/sshd_config:
    file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://ssh/sshd_config


/etc/ssh/banner:
    file.managed:
    - user: root
    - group: root
    - mode: 664
    - source: salt://ssh/banner
