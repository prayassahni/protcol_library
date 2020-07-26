
from scapy.all import *
import sys, os

TYPE_MYHEADER = 0x1212
TYPE_IPV4 = 0x0800
class MyHeader(Packet):
    name = "MyHeader"
    fields_desc = [
        StrField("country_id", "0"),
        StrField("state_id", "0"),
		StrField("city_id","0"),
		StrField("as_num","0"),
    ]
    def mysummary(self):
        return self.sprintf("country_id=%country_id%, state_id=%state_id%, city_id=%city_id%,as_id=%as_num%")


bind_layers(Ether, MyHeader, type=TYPE_MYHEADER)
bind_layers(MyHeader, IP, pid=TYPE_IPV4)

