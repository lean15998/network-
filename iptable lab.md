# 1. LAB1

```sh
                                        | ens33
                            +-----------+-----------+
                            |        [iptable]      |
                            |         iptable       |
                            |                       | 
                            |                       |
                            |                       | 
                            |                       |
                            +-----------+-----------+    
                              10.0.0.51 | ens34
                                        |
                                        | 
                        +----------------------------+
                        |                            |                   
                        |10.0.0.52                   |10.0.0.53           
            +-----------+-----------+    +-----------+-----------+
            |        [host01]       |    |        [host02]       | 
            |                       |    |                       |   
            |                       |    |                       |    
            |                       |    |                       |    
            |                       |    |                       | 
            |                       |    |                       |    
            +-----------+-----------+    +-----------------------+    
            ```
            
- Mặc định, DROP INPUT.
```sh
root@quynv:~# iptables -P INPUT DROP
```
- Mặc định, ACCEPT OUTPUT.
```sh
root@quynv:~# iptables -P OUTPUT ACCEPT
```
- Mặc định, DROP FORWARD.
```sh
root@quynv:~# iptables -P FORWARD DROP
```
- ACCEPT Established Connection.
```sh
root@quynv:~# iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
```
- ACCEPT kết nối từ loopback.
```sh
root@quynv:~# iptables -A INPUT -s 127.0.0.1 -j ACCEPT
```
- ACCEPT kết nối Ping với 5 lần mỗi phút từ mạng LAN.
```sh
root@quynv:~# iptables -A INPUT -p icmp --icmp-type 8 -m limit --limit 5/m --limit-burst 5 -s 10.0.0.0/24 -d 10.0.0.51 -j ACCEPT
```
- ACCEPT kết nối SSH từ trong mạng LAN. 

```sh
root@quynv:~# iptables -A INPUT -p tcp -s 10.0.0.0/24 -d 10.0.0.51 --dport 22 -j ACCEPT
```
- ACCEPT Outgoing gói tin thông qua Server từ mạng LAN (10.0.0.0/24) và nat địa chỉ nguồn của gói tin.
```sh
root@quynv:~# iptables -t nat -A POSTROUTING -o ens34 -d 10.0.0.52 -j SNAT --to-source 10.0.0.51
root@quynv:~# iptables -t nat -A POSTROUTING -o ens34 -d 10.0.0.53 -j SNAT --to-source 10.0.0.51
```
- FORWARD gói tin đến port 80 trên ens33 đến port tương tự trên host01.

```sh
root@quynv:~# iptables -A FORWARD -p tcp -i ens33 -o ens34 -d 10.0.0.52 --dport 80 -j ACCEPT
```
- FORWARD gói tin đến port 443 trên ens33 đến port tương tự trên h2.
```sh
root@quynv:~# iptables -A FORWARD -p tcp -i ens33 -o ens34 -d 10.0.0.53 --dport 443 -j ACCEPT
```
- DROP gói tin từ 192.168.18.29

```sh
root@quynv:~# iptables -A INPUT -s 192.168.18.29 -j DROP
```

# 2. LAB2            
            
            
```sh
                                        | ens33
                            +-----------+-----------+                 +-------------------+
                            |        [iptable]      |                 |    [Web server]   |
                            |       10.10.10.11     |  10.10.10.0/24  |                   |
                            |        10.0.0.51      +-----------------+     10.10.10.51   |
                            |      192.168.18.47    | ens38           |                   |
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
            |        10.0.0.52      |    |        10.0.0.53      |    
            |                       |    |                       |    
            |                       |    |                       | 
            |                       |    |                       |    
            +-----------+-----------+    +-----------------------+    
            
```    

- Mặc định, DROP INPUT.
```sh
root@quynv:~# iptables -P INPUT DROP
```
- Mặc định, ACCEPT OUTPUT.
```sh
root@quynv:~# iptables -P OUTPUT ACCEPT
```
- Mặc định, DROP FORWARD.
```sh
root@quynv:~# iptables -P FORWARD DROP
```
- ACCEPT Established Connection.
```sh
root@quynv:~# iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
```

- ACCEPT kết nối SSH từ trong mạng LAN. 

```sh
root@quynv:~# iptables -A INPUT -p tcp -s 10.0.0.0/24 -d 10.0.0.51 --dport 22 -j ACCEPT
```

- FORWARD gói tin đến port 80 trên ens33 sang port ens38 và đến port 80 trên Webserver.

```sh
root@quynv:~# iptables -A FORWARD -p tcp -i ens33 -o ens38 -d 10.10.10.51 --dport 80 -j ACCEPT
```
Cho phép 1 máy (host01) trong dải 10.0.0.0/24 quản trị Webserver.
```sh
root@host01:~# ip route add 10.10.10.0/24 via 10.0.0.51
root@host01:~# ip route add 10.0.0.0/24 via 10.10.10.11
root@quynv:~# iptables -A FORWARD -i ens34 -o ens38 -p tcp -s 10.0.0.52 -d 10.10.10.51 --dport 22 -j ACCEPT
```
- Cho phép các máy trong dải 10.0.0.0/24 kết nối ra Internet.

```sh
root@quynv:~# iptables -A FORWARD -i ens34 -o ens33 -j ACCEPT
root@quynv:~# iptables -t nat -A POSTROUTING -o ens33 -s 10.0.0.0/24 -j SNAT --to-source 192.168.18.47
```
