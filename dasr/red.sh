#!/bin/bash

#
# Diseño y Administración de Sistemas y Redes.
# Practica 4: Monitorizacion de red
# Autor: Roberto Gil
# Fecha: 2005-05-21
#

total_ifaces=`ifconfig -a | grep encap | cut -d " " -f1`
total_num_ifaces=`ifconfig -a | grep encap | cut -d " " -f1 | wc -l`
echo "*** Existen en total $total_num_ifaces interfaces de red:" $total_ifaces

active_ifaces=`ifconfig | grep encap | cut -d " " -f1`
active_num_ifaces=`ifconfig | grep encap | cut -d " " -f1 | wc -l`
echo -e "\n*** De los $total_num_ifaces interfaces de red, $active_num_ifaces de ellos están activos:"

echo -e "\nInterface HWaddr                IP              Broadcast       Netmask"
echo "------- ----------------------- --------------- --------------- --------------"


for i in $active_ifaces ; do

    # mac
    ifconfig $i  | grep HWaddr > ${i}.tmp
    mac=`awk -F " "  '{print $5}' ${i}.tmp`
    rm ${i}.tmp
    if [ ! $mac ] ; then 
        mac="(no tiene)      "
    fi

    # ip
    ip=`ifconfig $i | grep "inet addr" | cut -d: -f2 | cut -d " " -f1`
    if [ ! $ip ] ; then
        ip="(no tiene)      "
    fi

    # broadcast
    bcast=`ifconfig eth0 | grep "Bcast" | cut -d: -f3 | cut -d " " -f1`
    if [ ! $bcast ] ; then
        bcast="(no tiene)      "
    fi

    # netmask
    mask=`ifconfig eth0 | grep "Mask" | cut -d: -f4 | cut -d " " -f1`
    if [ ! $mask ] ; then
        mask="(no tiene)      "
    fi

    echo -e "$i \t$mac \t$ip \t$bcast \t$mask" 
    
done


num_routes=`route | grep -v Destination | grep -v Kernel | wc -l`
echo -e "\n*** Existen $num_routes rutas en la tabla de rutas:"
echo -e "\nIP              Netmask         Interface Gateway"
echo "--------------- --------------- --------- ---------------"

    step=1
    for i in `route |  grep -v Destination | grep -v Kernel | sed s/*/"0.0.0.0"/g` ; do
        #echo - $i -
        if [ $step -eq 1 ] ; then
            if [ $i = "default" ] ; then
                route_ip="0.0.0.0"
            else
                route_ip=$i
            fi
            step=`expr $step + 1`
        
        elif [ $step -eq 2 ] ; then
            route_gateway=$i
            step=`expr $step + 1`

        elif [ $step -eq 3 ] ; then
            route_netmask=$i
            step=`expr $step + 1`

        elif [ $step -eq 4 ] || [ $step -eq 5 ] || [ $step -eq 6 ] || [ $step -eq 7 ]   ; then
            step=`expr $step + 1`
            continue
    
        elif [ $step -eq 8 ] ; then
            route_iface=$i
            step=1
        
            echo -e "$route_ip \t$route_netmask \t$route_iface \t$route_gateway"
        fi
    done


num_arps=`arp | grep -v Address | wc -l`
echo -e "\n*** Hay $num_arps entradas en la tabla ARP:"
echo -e "\nIP              HWaddr            Interface"
echo "--------------- ----------------- ---------"

    step=1
        for i in `arp | grep -v Address` ; do
            if [ $step -eq 1 ] ; then
                arp_ip=$i
                step=`expr $step + 1`
            
            elif [ $step -eq 2 ] ; then
                step=`expr $step + 1`
                continue

            elif [ $step -eq 3 ] ; then
                arp_hw=$i
                step=`expr $step + 1` 

            elif [ $step -eq 4 ] ; then
                step=`expr $step + 1`
                continue
            
            elif [ $step -eq 5 ] ; then
                arp_iface=$i
                step=1

                echo -e "$arp_ip \t$arp_hw $arp_iface"
            fi
        done


num_ports_tcp=`netstat -an | grep -w tcp | grep LISTEN | wc -l`
ports_tcp=`netstat -an | grep -w tcp | grep LISTEN | cut -d: -f2 | cut -d " " -f1` 
echo -e "\n*** $num_ports_tcp puertos TCP en espera de una nueva conexión:" $ports_tcp

num_ports_udp=`netstat -an | grep -w udp | grep LISTEN | wc -l`
ports_udp=`netstat -an | grep -w udp | grep LISTEN | cut -d: -f2 | cut -d " " -f1`
echo -e "\n*** $num_ports_tcp puertos UDP en espera de una nueva conexión:" $ports_tcp

num_dns=`cat /etc/resolv.conf | grep -v ^# | grep [[:digit:]] | wc -l`
dns=`cat /etc/resolv.conf | grep -v ^# | grep [[:digit:]] | cut -d " " -f2`
echo -e "\n*** $num_dns nameservers en la configuración del DNS:" $dns

num_hosts=`cat /etc/hosts | grep -v ^# | grep [[:digit:]] | wc -l`
echo -e "\n*** $num_hosts entradas en el fichero /etc/hosts."

