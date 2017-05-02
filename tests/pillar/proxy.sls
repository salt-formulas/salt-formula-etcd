etcd:
  server:
    image: quay.io/coreos/etcd:latest
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
