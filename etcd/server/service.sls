{%- from "etcd/map.jinja" import server with context %}
{%- if server.enabled %}

{%- if server.get('source', {}).get('engine', 'pkg') == 'pkg' %}

etcd_packages:
  pkg.installed:
  - names: {{ server.pkgs }}
{%- if server.get('engine', 'systemd') %}
  - require:
    - file: /etc/default/etcd
  - watch_in:
    - service: etcd
{%- endif %}


{% elif server.get('source', {}).get('engine') == 'docker_hybrid' %}

{%- if grains.os_family == 'RedHat' %}
etcd_enable_epel:
  pkg.installed:
    - name: epel-release

etcd_install_pip:
  pkg.installed:
    - name: python2-pip

etcd_python_etcd_from_pip:
  pip.installed:
    - name: python-etcd

{%- endif %}


{%- set _support_pkgs = [] %}
{%- for pkg in server.pkgs %}
{%- if pkg != 'etcd' %}
{%- do _support_pkgs.append(pkg) %}
{%- endif %}
{%- endfor %}

{%- if _support_pkgs|length >= 1 %}
etcd_support_packages:
  pkg.installed:
    - pkgs:
{%- for pkg in _support_pkgs %}
      - {{ pkg }}
{%- endfor %}

{%- endif %}

user_etcd:
  user.present:
    - name: etcd
    - shell: /bin/false
    - home: /var/lib/etcd
    - gid_from_name: True

/tmp/etcd:
  file.directory:
      - user: root
      - group: root

pull-etcd-image:
  {%- if grains['saltversioninfo'] < [2017, 7] %}
  dockerng.image_present:
  {%- else %}
  docker_image.present:
  {%- endif %}
    - name: {{ server.get('image', 'quay.io/coreos/etcd:latest') }}

copy-etcd-binaries:
  {%- if grains['saltversioninfo'] < [2017, 7] %}
  dockerng.running:
  {%- else %}
  docker_container.running:
  {%- endif %}
    - image: {{ server.get('image', 'quay.io/coreos/etcd:latest') }}
    - entrypoint: cp
    - command: -vr /usr/local/bin/ /tmp/etcd/
    - binds:
      - /tmp/etcd/:/tmp/etcd/
    - force: True
    - require:
      - file: /tmp/etcd
      {%- if grains['saltversioninfo'] < [2017, 7] %}
      - dockerng: pull-etcd-image
      {%- else %}
      - docker_image: pull-etcd-image
      {%- endif %}

{%- for filename in ['etcd', 'etcdctl'] %}

/usr/local/bin/{{ filename }}:
  file.managed:
    - source: /tmp/etcd/bin/{{ filename }}
    - mode: 755
    - user: root
    - group: root
    - require:
      {%- if grains['saltversioninfo'] < [2017, 7] %}
      - dockerng: copy-etcd-binaries
      {%- else %}
      - docker_container: copy-etcd-binaries
      {%- endif %}
    - watch_in:
      - service: etcd

{% endfor %}

/etc/systemd/system/etcd.service:
  file.managed:
    - source: salt://etcd/files/systemd/etcd.service
    - template: jinja
    - user: root
    - group: root

{% endif %}

{%- if server.get('engine', 'systemd') == 'kubernetes' %}

etcd_service:
  service.dead:
  - name: etcd
  - enable: False

/var/log/etcd.log:
  file.managed:
  - user: etcd
  - group: root
  - mode: 644

/etc/kubernetes/manifests/etcd.manifest:
  file.managed:
    - source: salt://etcd/files/etcd.manifest
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755

{%- else %}

/etc/default/etcd:
  file.managed:
    - source: salt://etcd/files/default
    - template: jinja
    - defaults:
{%- if salt['cmd.shell']('. /var/lib/etcd/configenv; etcdctl cluster-health > /dev/null 2>&1; echo $?') != '0' %}
        initial_cluster_state: new
{%- else %}
        initial_cluster_state: existing
{%- endif %}
    - watch_in:
      - service: etcd

/var/lib/etcd/:
  file.directory:
    - user: etcd
    - recurse:
      - user

/var/lib/etcd/configenv:
  file.managed:
    - source: salt://etcd/files/configenv
    - template: jinja
    - user: etcd
    - require:
      - file: /var/lib/etcd/

etcd:
  service.running:
  - enable: True
  - name: {{ server.services }}
  {%- if grains.get('noservices') %}
  - onlyif: /bin/false
  {%- endif %}

{%- endif %}

{%- endif %}
