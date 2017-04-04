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
linux:
  system:
    name: hostname
    enabled: true
    repo:
      docker:
        source: 'deb http://ppa.launchpad.net/cloud-green/trusty-backports/ubuntu trusty main'
        key_id: E6396E0A9EA00B88BF1D40C434EDB5B7EC1764A6
        key_server: hkp://p80.pool.sks-keyservers.net:80
