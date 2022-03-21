# 1. Mo hinh

```sh
                                  ens33 |
                            +-----------+-----------+                 +-------------------+
                            |       [VPNServer]     |                 |    [VPNClient]    |
                            |       10.10.10.11     |  10.10.10.0/24  |                   |
                            |        10.0.0.51      +-----------------+   192.168.18.171  |
                            |      192.168.18.138   | ens38           |                   |
                            |                       |                 |                   |
                            |                       |                 |                   |
                            +-----------+-----------+                 +-------------------+
                                        | ens34
                                        |
                                        | 
                        +----------------------------+
                        |                            |                   
                        |                            |           
            +-----------+-----------+    +-----------+-----------+
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
 
 <img src="">
 
 
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
root@host01:~# ip route del 10.8.0.0/24 via 10.0.0.51
```

 ```sh
root@host02:~# ip route del 10.8.0.0/24 via 10.10.10.11
```
