/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

const bit<16> TYPE_MYHEADER = 0x1212;
const bit<16> TYPE_IPV4 = 0x800;

/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}


header new_header
{
   bit<16> country_id;
   bit<16> state_id;
   bit<16> city_id;
   bit<16> as_num;
   bit<16> default;
}

header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

struct metadata {
    /* empty */
}

struct headers {
    ethernet_t   ethernet;
    new_header   myHeader;
    ipv4_t       ipv4;
    
}

/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            TYPE_MYHEADER : parse_myHeader;
            TYPE_IPV4: parse_ipv4;
            default: accept;
        }
    }

    state parse_myHeader {
        packet.extract(hdr.myHeader);
        transition parse_ipv4;
    }

    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition accept;
    }

}

/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {   
    apply {  }
}

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {

    bit<16> id;
    action drop() {
        mark_to_drop();
    }
    
    action ipv4_forward(macAddr_t dstAddr, egressSpec_t port) {
        standard_metadata.egress_spec = port;
        hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = dstAddr;
        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }
    
    table ipv4_lpm {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            ipv4_forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }
 

    
    action myHeader_forward(egressSpec_t port) {
        standard_metadata.egress_spec = port;
    }

    action setState(egressSpec_t port)
    {
    
    }
    table myHeader_exact_0 {
        key = {
            hdr.myHeader.country_id: exact;
        }
        actions = {
            myHeader_forward;
            drop;
        }
        size = 1024;
        default_action = drop();
    }

    table myHeader_exact_1 {
        key = {
            hdr.myHeader.state_id: exact;
        }
        actions = {
            myHeader_forward;
            drop;
        }
        size = 1024;
        default_action = drop();
    }


    table myHeader_exact_2 {
        key = {
            hdr.myHeader.city_id: exact;
        }
        actions = {
            myHeader_forward;
            drop;
        }
        size = 1024;
        default_action = drop();
    }

    table myHeader_exact_3 {
        key = {
            hdr.myHeader.as_num: exact;
        }
        actions = {
            myHeader_forward;
            drop;
        }
        size = 1024;
        default_action = drop();
    }
     table switch_class0 {
        key = {
            hdr.myHeader.country_id: exact;
        }
        actions = {
            setState;
        }
        size = 10;
    }
         table switch_class1 {
        key = {
            hdr.myHeader.country_id: exact;
        }
        actions = {
            setState;
        }
        size = 10;
    }
        table switch_class2 {
        key = {
            hdr.myHeader.country_id: exact;
        }
        actions = {
            setState;
        }
        size = 10;
    }

    table switch_class3 {
        key = {
            hdr.myHeader.country_id: exact;
        }
        actions = {
            setState;
        }
        size = 10;
    }
    table default_1 {
        key = {
            hdr.myHeader.default: exact;
        }
        actions = {
            myHeader_forward;
        }
        size = 10;
    }
        table default_2 {
        key = {
            hdr.myHeader.default: exact;
        }
        actions = {
            myHeader_forward;
        }
        size = 10;
    }
        table default_3 {
        key = {
            hdr.myHeader.defualt: exact;
        }
        actions = {
            myHeader_forward;
        }
        size = 10;
    }
        table default_0 {
        key = {
            hdr.myHeader.default: exact;
        }
        actions = {
            myHeader_forward;
        }
        size = 10;
    }
         table default_4 {
        key = {
            hdr.myHeader.default: exact;
        }
        actions = {
            myHeader_forward;
        }
        size = 10;
    }
    apply {
        if (hdr.ipv4.isValid() && !hdr.myHeader.isValid()) {
            // Process only non-tunneled IPv4 packets
        }

        if (hdr.myHeader.isValid()) {
            // process tunneled packets
            // apply the table depending on the layer that switch belongs
            if(switch_class0.apply().hit) 
            {

                myHeader_exact_0.apply();
            }
            else
            {
                if(switch_class1.apply().hit)
                {

                    if(!myHeader_exact_1.apply().hit)
                    {
                        default_1.apply();
                    }
                }
                else
                {
                    if(switch_class2.apply().hit)
                    {
                        if(!myHeader_exact_2.apply().hit)
                        {
                            default_2.apply();
                        }                   
                    }
                    else
                    {
                        if(switch_class3.apply().hit)
                        {
                            if(!myHeader_exact_3.apply().hit)
                            {
                                default_3.apply();
                            }
                        }
                        else
                        {
                            if(!ipv4_lpm.apply().hit)
                            {
                                default_4.apply();
                            }
                        }
                    }
                }
            }
            
        }
    }
}


/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {  }
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
     apply {
	update_checksum(
	    hdr.ipv4.isValid(),
            { hdr.ipv4.version,
	      hdr.ipv4.ihl,
              hdr.ipv4.diffserv,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);
    }
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.myHeader);
        packet.emit(hdr.ipv4);
    }
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;