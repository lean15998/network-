# 1.DHCP là gì?

- **DHCP(Dynamic Host Configuration Protocol)** là một giao thức mạng cho phép server tự động cấp phát IP và các tham số cấu hình mạng liên quan cho các client. Các IP được cấp cho Client sẽ nằm trong nhóm IP đã được chúng ta xác định trước. Khi một client khởi động thì nó sẽ nhận được một địa chỉ IP động. Địa chỉ IP được DHCP server gán cho DHCP client, thời gian được thay đổi IP có thể tùy thuộc vào thời gian hiệu lực cấp phát (hay leasetime) tùy theo cấu hình ở máy chủ DHCP.
- Cách hoạt động của DHCP:
<ul>
  <ul>
    <li> Khi client (được cấu hình để sử dụng DHCP) và được kết nối với mạng, nó sẽ chuyển tiếp thông báo DHCPDISCOVER đến máy chủ DHCP server. Và sau khi DHCP server nhận được thông báo yêu cầu DHCPDISCOVER, nó sẽ trả lời bằng DHCPOFFER.
    <li> Sau đó, client nhận được thông báo DHCPOFFER và nó sẽ gửi một thông điệp DHCPREQUEST đến cho server biết, nó đã được chuẩn bị để nhận cấu hình mạng được cung cấp trong tin nhắn DHCPOFFE.
    <li> Cuối cùng DHCP server nhận thông báo DHCPREQUEST từ client và gửi tin nhắn DHCPACK cho client hiện phép sử dụng địa chỉ IP được gán.
  </ul>
</ul>

# 2.Cấu hình DHCP sử dụng isc dhcp server

## Cấu hình tại DHCP Server

- Cài đặt gói `dhcp-server`.
```sh
root@server:~# apt -y install isc-dhcp-server
```
- Cấu hình tại file `/etc/dhcp/dhcpd.conf`. 

```sh
# add to the end
subnet 10.0.0.0 netmask 255.255.255.0 {
    # specify default gateway
    option routers 10.0.0.1;
    # specify subnet-mask
    option subnet-mask 255.255.255.0;
    # specify the range of leased IP address
    range dynamic-bootp 10.0.0.200 10.0.0.254;
}
```
- Khởi động lại dịch vụ
```sh
root@server:~# systemctl restart isc-dhcp-server
```

##  Tại DHCP Client

- Cấu hình interface về chế độ DHCP và kiểm tra .
```sh

root@client:~# vi /etc/netplan/01-netcfg.yaml
 
network:
  version: 2
  renderer: networkd
  ethernets:
    ens34:
      dhcp4: yes
```

```sh
root@client:~# netplan apply
```

```sh
root@client:~# ip a | grep ens34
3: ens34: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 10.0.0.203/24 brd 10.0.0.255 scope global dynamic ens34
```








