# 1.Mo hinh

```sh
                                 10.0.0.0/24                10.10.10.0/24                172.16.1.0/24
                        +----------------------------+----------------------------+-----------------------------+
                        |                            |                            |                             |
                        |                            |                            |                             |
            +-----------+-----------+    +-----------+-----------+    +-----------+-----------+     +-----------+-----------+
            |        [host01]       |    |        [host02]       |    |        [host03]       |     |        [host04]       |
            |        10.0.0.52      +    +        10.0.0.51      +    +       10.10.10.51     |     |      172.16.1.128     |
            |                       |    |      10.10.10.11      |    |       172.16.1.130    |     |                       |
            |                       |    |                       |    |                       |     |                       |
            |                       |    |                       |    |                       |     |                       |
            |                       |    |                       |    |                       |     |                       |
            +-----------+-----------+    +-----------------------+    +-----------------------+     +-----------------------+
```



### Định tuyến host01 ping được tới host04


#### B1: enable tính năng IP packet forwarding

```sh
root@host01:~# sysctl -w net.ipv4.ip_forward=1
```
```sh
root@host02:~# sysctl -w net.ipv4.ip_forward=1
```
```sh
root@host03:~# sysctl -w net.ipv4.ip_forward=1
```
```sh
root@host04:~# sysctl -w net.ipv4.ip_forward=1
```

#### B2: Định tuyến host02 -> host04

```sh
root@host02:~# ip route add 172.16.1.0/24 via 10.10.10.51
```
```sh
root@host04:~# ip route add 10.10.10.0/24 via 172.16.1.130
```
- ping thử
```sh
root@host04:~# ping 10.10.10.11
PING 10.10.10.11 (10.10.10.11) 56(84) bytes of data.
64 bytes from 10.10.10.11: icmp_seq=1 ttl=63 time=1.80 ms
64 bytes from 10.10.10.11: icmp_seq=2 ttl=63 time=1.82 ms
64 bytes from 10.10.10.11: icmp_seq=3 ttl=63 time=1.81 ms
```
#### B3: Định tuyến host01 -> host04
```sh
root@host02:~# ip route add 172.16.1.0/24 via 10.0.0.51
```
```sh
root@host04:~# ip route add 10.0.0.0/24 via 10.10.10.11
```
- ping thử
```sh

root@h:~# ping 10.0.0.52
PING 10.0.0.52 (10.0.0.52) 56(84) bytes of data.
64 bytes from 10.0.0.52: icmp_seq=1 ttl=62 time=1.10 ms
64 bytes from 10.0.0.52: icmp_seq=2 ttl=62 time=2.46 ms
64 bytes from 10.0.0.52: icmp_seq=3 ttl=62 time=2.55 ms
```
