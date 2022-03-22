# 1. Lý thuyết

-  VPN (Virtual Private Network) - mạng riêng ảo, là một công nghệ mạng giúp tạo kết nối mạng an toàn khi tham gia vào mạng công cộng như Internet hoặc mạng riêng do một nhà cung cấp dịch vụ sở hữu. Các tập đoàn lớn, các cơ sở giáo dục và cơ quan chính phủ sử dụng công nghệ VPN để cho phép người dùng từ xa kết nối an toàn đến mạng riêng của cơ quan mình.
-  Bản chất giao thức VPN là một tập hợp gồm nhiều giao thức. Mỗi loại giao thức có những chức năng khác nhau:
<ul>
  <ul>
<li> Tunnelling: Là kỹ thuật truyền dữ liệu qua nhiều mạng có giao thức khác nhau. VPN có chức năng cơ bản là phân phối các gói từ điểm này tới điểm khác một cách bảo mật. Để làm được điều đó thì tất cả các gói dữ liệu cần được định dạng sao cho chỉ máy khách và máy chủ hiểu được. Bên gửi dữ liệu sẽ định dạng chúng theo Tunnelling để bên nhận có thể trích xuất được thông tin.
<li> Mã hóa: Vì Tunnelling không có tính năng bảo vệ nên bất cứ ai cũng có thể trích xuất dữ liệu. Khi đó, bạn cần phải mã hóa trên đường truyền sao cho chỉ bên nhận mới có thể giải mã.
<li> Quản lý phiên: Là cách duy trì phiên để khách hàng tiếp tục giao tiếp trong một khoảng thời gian nhất định.
<li> Xác thực: Là cách xác nhận danh tính để bảo mật an toàn hơn.
  </ul>
  </ul>
  
### Phân loại VPN

- Site-to-Site VPN: là mô hình dùng để kết nối các hệ thống mạng ở các nơi khác nhau tạo thành một hệ thống mạng thống nhất. Ở loại kết nối này thì việc chứng thực an đầu phụ thuộc vào thiết bị đầu cuối ở các Site, các thiết bị này hoạt động như Gateway và đây là nơi đặt nhiều chính sách bảo mật nhằm truyền dữ liệu một cách an toàn giữa các Site.

- Remote Access VPN: loại này thường áp dụng cho nhân viên làm việc lưu động hay làm việc ở nhà muốn kết nối vào mạng công ty một cách an toàn. Cũng có thể áp dụng cho văn phòng nhỏ ở xa kết nối vào Văn phòng trung tâm của công ty. Remote Access VPN còn được xem như là dạng User-to-LAN, cho phép người dùng ở xa dùng phần mềm VPN Client kết nối với VPN Server. VPN hoạt động nhờ vào sự kết hợp với các giao thức đóng gói PPTP, L2TP, IPSec, GRE, MPLS, SSL, TLS.
  # 2. Mô hình

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
