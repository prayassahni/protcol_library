#!/usr/bin/env python
import argparse
import sys
import socket
import random
import struct
import argparse

from scapy.all import sendp, send, get_if_list, get_if_hwaddr, hexdump
from scapy.all import Packet
from scapy.all import Ether, IP, UDP, TCP
from myTunnel_header import MyHeader

def get_if():
    ifs=get_if_list()
    iface=None # "h1-eth0"
    for i in get_if_list():
        if "eth0" in i:
            iface=i
            break;
    if not iface:
        print "Cannot find eth0 interface"
        exit(1)
    return iface

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('ip_addr', type=str, help="The destination IP address to use")
    parser.add_argument('message', type=str, help="The message to include in packet")
    parser.add_argument('country_id', type=str, help="The destination country address to use")
    parser.add_argument('state_id', type=str, help="The destination state address to use")
    parser.add_argument('city_id', type=str, help="The destination city address to use")
    parser.add_argument('as_num', type=str, help="The destination AS address to use")
    #parser.add_argument('--dst_id', type=int, default=None, help='The myTunnel dst_id to use, if unspecified then myTunnel header will not be included in packet')
    args = parser.parse_args()
    addr = socket.gethostbyname(args.ip_addr)
    arg0 = args.country_id
    arg1 = args.state_id
    arg2 = args.city_id
    arg3 = args.as_num
    iface = get_if()

    if (arg0 is not None):
        print "sending on interface {} to country_id {}".format(iface, arg0)
        pkt =  Ether(src=get_if_hwaddr(iface), dst='ff:ff:ff:ff:ff:ff')
        pkt = pkt / MyHeader(country_id = arg0 , state_id =arg1 , city_id = arg2 , as_num = arg3) / IP(dst=addr) / args.message
    else:
        print "sending on interface {} to IP addr {}".format(iface, str(addr))
        pkt =  Ether(src=get_if_hwaddr(iface), dst='ff:ff:ff:ff:ff:ff')
        pkt = pkt / IP(dst=addr) / TCP(dport=1234, sport=random.randint(49152,65535)) / args.message

    #pkt.show2()
#    hexdump(pkt)
#    print "len(pkt) = ", len(pkt)
    sendp(pkt, iface=iface, verbose=False)


if __name__ == '__main__':
    main()
