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