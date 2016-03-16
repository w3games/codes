#!/bin/bash


#### Clear ####

iptables -F
iptables -X
iptables -Z

#++++++++++++++


#### Policy #################

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#++++++++++++++++++++++++++++


##### INPUT BLOCK REJECT ######################################################

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 3 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 11 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 12 -j ACCEPT
iptables -A INPUT -p tcp --syn --dport 113 -j REJECT --reject-with tcp-reset
iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#!/bin/bash


#### Clear ####

ip6tables -F
ip6tables -X
ip6tables -Z

#++++++++++++++


#### Policy #################

ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT

#++++++++++++++++++++++++++++


##### INPUT BLOCK REJECT ######################################################

ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP
ip6tables -A INPUT -s fe80::/10 -p ipv6-icmp -j ACCEPT
ip6tables -A INPUT -s fde1:6a62:9da2::/64 -p ipv6-icmp -j ACCEPT
ip6tables -A INPUT -s fde1:6a62:9da2::/64 -p tcp -j ACCEPT
ip6tables -A INPUT -p udp -m conntrack --ctstate NEW -j REJECT --reject-with icmp6-port-unreachable
ip6tables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j REJECT --reject-with tcp-reset

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
