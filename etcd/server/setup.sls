{%- from "etcd/map.jinja" import server with context %}
{%- if server.enabled %}

{%- for name,setup in server.setup.iteritems() %}

{{ setup.key }}:
  etcd.set:
    - value: '{{ setup.value }}'

{%- endfor %}


{%- endif %}
