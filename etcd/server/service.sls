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

etcd_support_packages:
  pkg.installed:
    - pkgs:
{%- for pkg in server.pkgs %}
{%- if pkg != 'etcd' %}
      - {{ pkg }}
{%- endif %}
{%- endfor %}

/tmp/etcd:
  file.directory:
      - user: root
      - group: root

copy-etcd-binaries:
  dockerng.running:
    - image: {{ server.get('image', 'quay.io/coreos/etcd:latest') }}
    - entrypoint: cp
    - command: -vr /usr/local/bin/ /tmp/etcd/
    - binds:
      - /tmp/etcd/:/tmp/etcd/
    - force: True
    - require:
      - file: /tmp/etcd

{%- for filename in ['etcd', 'etcdctl'] %}

/usr/local/bin/{{ filename }}:
  file.managed:
    - source: /tmp/etcd/bin/{{ filename }}
    - mode: 755
    - user: root
    - group: root
    - require:
      - dockerng: copy-etcd-binaries
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
  - user: root
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
{%- if salt['cmd.run']('. /var/lib/etcd/configenv; etcdctl cluster-health > /dev/null 2>&1; echo $?') != '0' %}
        initial_cluster_state: new
{%- else %}
        initial_cluster_state: existing
{%- endif %}
    - watch_in:
      - service: etcd

/var/lib/etcd/:
  file.directory:
    - user: etcd

/var/lib/etcd/configenv:
  file.managed:
    - source: salt://etcd/files/configenv
    - template: jinja
    - require:
      - file: /var/lib/etcd/

etcd:
  service.running:
  - enable: True
  - name: {{ server.services }}

{%- endif %}

{%- endif %}
