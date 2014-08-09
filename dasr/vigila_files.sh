#!/bin/bash

#
# Diseño y Administración de Sistemas y Redes.
# Practica 3: Vigilancia y supervisión del sistema.
# Autor: Roberto Gil
#


### FILES ###

# Comprueba si alguna partición de las montadas en el sistema tiene un uso
# superior al 95%

get_partition_info() {
    
    step=1
    for i in `df | sed '1d'` ; do

        # Filesystem
        if [ $step -eq 1 ] ; then
            filesystem=$i
            step=`expr $step + 1`

        # Size, Used, Avail
        elif [ $step -eq 2 ] || [ $step -eq 3 ] || [ $step -eq 4 ]   ; then
            step=`expr $step + 1`
            continue

        # Use%
        elif [ $step -eq 5 ] ; then
            use=`echo $i | cut -d% -f1`
            step=`expr $step + 1`

        # Mount point
        elif [ $step -eq 6 ] ; then
            mount=$i
            step=1

            if [ $use -gt 95 ] ; then
                echo "La partición $filesystem (montada en $mount) está llena al $use%"
            fi
        fi
    done
}


# Comprueba si algún fichero que pertenezca a alguno de los directorios /bin, 
# /boot, /etc, /lib, /home, /root, /sbin o /usr  (o alguno de sus 
# subdirectorios) tiene permisos de escritura para "others" (esto es, alguien 
# que no sea el dueño del fichero ni pertenezca a su grupo)

search_universal () {

    list=`find /bin /boot /etc /lib /home /root /sbin /usr -perm -2 -print`

    for i in $list ; do
        echo "El fichero $i tiene permisos de escritura universales"
    done
}


# Comprueba si a partir de los directorios /home, /tmp  o /var/tmp hay ficheros
# con set-uid

search_setuid () {

    list=`find /home /tmp /var/tmp -perm -4000 -print`

    for i in $list ; do
        echo "El fichero $i tiene modo set-uid"
    done
}
