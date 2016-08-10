{%- from "etcd/map.jinja" import server with context %}
{%- if server.enabled %}

etcd_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

/etc/default/etcd:
  file.managed:
    - source: salt://etcd/files/default
    - template: jinja
    - require:
      - pkg: etcd_packages

etcd_service:
  service.running:
  - name: etcd
  - enable: True
  - watch:
    - file: /etc/default/etcd

{%- endif %}
