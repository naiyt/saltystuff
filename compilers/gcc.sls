{% if grains['os'] == 'Ubuntu' %}
software-properties-common:
    pkg.installed
python-software-properties:
    pkg.installed
base:
    pkgrepo.managed:
         - name: ppa:ubuntu-toolchain-r/test
         - require_in:
            - pkg: gcc-4.7
            - pkg: g++-4.7
{% endif %}

gcc-4.7:
    pkg.installed
g++-4.7:
    pkg.installed
libboost-all-dev:
    pkg.installed
