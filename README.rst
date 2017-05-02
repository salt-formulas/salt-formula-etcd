
==================================
etcd Formula
==================================

Service etcd description

Possible `source.engine`:

- **pkg** - install etcd package (default)
- **docker_hybrid** - copy binaries from docker image (specified in `server.image`)

Sample pillars
==============

Certificates
-------------

Use certificate authentication (for peers and clients). Certificates must be prepared in advance.

.. code-block:: yaml

    etcd:
      server:
        enabled: true
        ssl:
          enabled: true
        bind:
          host: 10.0.175.101
        token: $(uuidgen)
        members:
        - host: 10.0.175.101
          name: etcd01
          port: 4001

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

etcd proxy
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

Run etcd on k8s
---------------

.. code-block:: yaml

    etcd:
      server:
        engine: kubernetes
        image: etcd:latest

Copy etcd binary from container
---------------

.. code-block:: yaml

    etcd:
      server:
        image: quay.io/coreos/etcd:latest

Read more
=========

* https://github.com/coreos/etcd

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-etcd/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-etcd

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
