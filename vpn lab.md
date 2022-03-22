# 1. Mô hình

```sh
                                  
                            +-----------+-----------+                 +-------------------+
                            |       [VPNServer]     |                 |    [VPNClient]    |
                            |       10.10.10.11     | 192.168.18.0/24 |                   |
                            |        10.0.0.51      +-----------------+   192.168.18.171  |
                            |      192.168.18.138   | ens33           |                   |
                            |                       |                 |                   |
                            |                       |                 |                   |
                            +-----------+-----------+                 +-------------------+
                               | ens34          | ens38
                               |                | 
                               |                |
                               |                |            
                               |                |             
            +------------------+----+    +------+----------------+
            |        [host01]       |    |        [host02]       | 
            |                       |    |                       |   
            |        10.0.0.52      |    |      10.10.10.128     |    
            |                       |    |                       |    
            |                       |    |                       | 
            |                       |    |                       |    
            +-----------+-----------+    +-----------------------+    
  ```
  
  ### Cài đặt OpenVPN
  
  ```sh
  root@server:~# wget https://git.io/vpn -O openvpn-ubuntu-install.sh
  root@server:~# ./openvpn-ubuntu-install.sh
  Welcome to this OpenVPN road warrior installer!

Which IPv4 address should be used?
     1) 10.10.10.51
     2) 172.16.1.130
     3) 10.0.0.53
     4) 192.168.18.138
IPv4 address [1]: 4

This server is behind NAT. What is the public IPv4 address or hostname?
Public IPv4 address / hostname [113.160.73.210]: 192.168.18.138

Which protocol should OpenVPN use?
   1) UDP (recommended)
   2) TCP
Protocol [1]: 

What port should OpenVPN listen to?
Port [1194]: 

Select a DNS server for the clients:
   1) Current system resolvers
   2) Google
   3) 1.1.1.1
   4) OpenDNS
   5) Quad9
   6) AdGuard
DNS server [1]: 3

Enter a name for the first client:
Name [client]: 

OpenVPN installation is ready to begin.
Press any key to continue...

root@server:~# ls
client.ovpn  openvpn-ubuntu-install.sh  snap
 ```
 ###  Trên Client
 
 <img src="https://github.com/lean15998/network-/blob/main/images/01.png">
 <img src="https://github.com/lean15998/network-/blob/main/images/02.png">
 <img src="https://github.com/lean15998/network-/blob/main/images/03.png">
 
 ```sh
 root@client:~# ip a | grep tun0
4: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 100
    inet 10.8.0.2/24 brd 10.8.0.255 scope global noprefixroute tun0
```
 ### Cấu hình định tuyến
 
 ```sh
root@client:~# ip route del 10.10.10.10/24 via 10.8.0.1
root@client:~# ip route del 10.0.0.0/24 via 10.8.0.1
```
 ```sh
 root@client:~# ip route
default via 192.168.18.1 dev ens33 proto dhcp metric 100 
10.0.0.0/24 via 10.8.0.1 dev tun0 
10.8.0.0/24 dev tun0 proto kernel scope link src 10.8.0.2 metric 50 
10.10.10.0/24 via 10.8.0.1 dev tun0 
169.254.0.0/16 dev ens37 scope link metric 1000 
172.16.1.0/24 dev ens37 proto kernel scope link src 172.16.1.128 metric 101 
192.168.18.0/24 dev ens33 proto kernel scope link src 192.168.18.171 metric 100 
192.168.18.138 dev ens33 proto static scope link metric 100 
```
### Ping

```sh
root@client:~# ping 10.10.10.128
PING 10.10.10.128 (10.10.10.128) 56(84) bytes of data.
64 bytes from 10.10.10.128: icmp_seq=1 ttl=63 time=4.60 ms
64 bytes from 10.10.10.128: icmp_seq=2 ttl=63 time=2.73 ms
64 bytes from 10.10.10.128: icmp_seq=3 ttl=63 time=2.53 ms
64 bytes from 10.10.10.128: icmp_seq=4 ttl=63 time=2.58 ms
```
```sh
root@client:~# ping 10.0.0.52
PING 10.0.0.52 (10.0.0.52) 56(84) bytes of data.
64 bytes from 10.0.0.52: icmp_seq=1 ttl=63 time=1.46 ms
64 bytes from 10.0.0.52: icmp_seq=2 ttl=63 time=2.55 ms
64 bytes from 10.0.0.52: icmp_seq=3 ttl=63 time=2.70 ms
64 bytes from 10.0.0.52: icmp_seq=4 ttl=63 time=2.78 ms
```
