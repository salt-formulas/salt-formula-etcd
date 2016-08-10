
==================================
ETCD Formula
==================================

Service etcd description

Sample pillars
==============

Single etcd service
---------------------

.. code-block:: yaml

    etcd:
      server:
        enabled: true
        bind:
          host: 10.0.175.101
        token: $(uuidgen) 
        members:
        - host: 10.0.175.101
          name: etcd01
          port: 4001

Cluster etcd service
----------------------

.. code-block:: yaml

    etcd:
      server:
        enabled: true
        bind:
          host: 10.0.175.101
        token: $(uuidgen)
        members:
        - host: 10.0.175.101
          name: etcd01
          port: 4001
        - host: 10.0.175.102
          name: etcd02
          port: 4001
        - host: 10.0.175.103
          name: etcd03
          port: 4001

ETCD proxy
-------------

.. code-block:: yaml

    etcd:
      server:
        enabled: true
        bind:
          host: 10.0.175.101
        proxy: on
        members:
        - host: 10.0.175.101
          name: etcd01
        - host: 10.0.175.102
          name: etcd02
        - host: 10.0.175.103
          name: etcd03

Read more
=========

* links
