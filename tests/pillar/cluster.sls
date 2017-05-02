etcd:
  server:
    image: quay.io/coreos/etcd:latest
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
