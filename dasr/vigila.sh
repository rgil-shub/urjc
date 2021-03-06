#!/bin/bash

# -----------------------------------------------------------#
# Diseño y Administración de Sistemas y Redes.               #
# Practica 3: Vigilancia y supervisión del sistema.          #
# Autor: Roberto Gil                                         #
# Fecha: 2005-05-09                                          #
# Ficheros: vigila, vigila_proc, vigila_files, vigila_passwd #
# -----------------------------------------------------------#

# Cada punto pedido en el enunciado se corresponde con una funcion.
# Cada una de las tres partes pedidas corresponde con un fichero:
# proc   -> vigila_proc
# files  -> vigila_files
# passwd -> vigila_passwd


. vigila_files.sh
. vigila_proc.sh
. vigila_passwd.sh


if [ $# != 1 ] ; then
   echo "Numero de argumentos incorrecto"

elif [ $1 != "passwd" ] && [ $1 != "files" ] && [ $1 != "proc" ] ; then
   echo "El primer argumento ha de ser \"psswd\", \"files\" o \"proc\""

### PASSWD ###
elif [ $1 = "passwd" ] ; then

    # Ficheros con informacion valida
    check_files

    # Linea del group tiene login que no esta en passwd
    check_lines

    # Logins en passwd que no estan en shadow
    check_login

    # Logins repetidos
    search_login_repeats

    # Grupos repetidos
    search_group_repeats

    # UIDs repetidos
    search_UID_repeats

    # GUIDs repetidos
    search_GID_repeats

    # Usuarios sin password
    search_no_pass

### FILES ###
elif [ $1 = "files" ] ; then

    # Particiones con mas del 95% de uso
    get_partition_info

    # Ficheros con permisos de escritura universales
    search_universal    

    # Ficheros con bit set-uid
    search_setuid

### PROC ###
elif [ $1 = "proc" ] ; then

    cd /proc

    # Uptime (/proc/uptime)
    show_uptime

    # Procesos totales y de root
    search_process

    # Numero de usuarios distintos con procesos
    search_diferent_users
    
    # PID mas alto
    search_max_pid

    # PID con mas ficheros abiertos
    search_max_pid_fd

fi
