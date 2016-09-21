
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
        proxy: true
        members:
        - host: 10.0.175.101
          name: etcd01
        - host: 10.0.175.102
          name: etcd02
        - host: 10.0.175.103
          name: etcd03

run ETCD on k8s
---------------

.. code-block:: yaml

    etcd:
      server:
        engine: kubernetes

Read more
=========

* links
