#!/bin/bash

#
# Diseño y Administración de Sistemas y Redes.
# Practica 3: Vigilancia y supervisión del sistema.
# Autor: Roberto Gil
#

### PROC ###

show_uptime () {

    TIEMPO=`cat uptime | cut -d " " -f1`
    HORAS=`echo "$TIEMPO / 60 / 60" | bc`
    MIN=`echo "$TIEMPO / 60 % 60" | bc`
    SEG=`echo "$TIEMPO % 60" | bc`
    echo "El sistema lleva $HORAS horas, $MIN minutos y $SEG segundos encendido"
}


search_process () {

    PROCS_TOTAL=`ls [0-9]* -ld | wc -l`
    PROCS_ROOT=`ls [0-9]* -ld | grep root | wc -l`
    echo "Hay un total de $PROCS_TOTAL procesos en el sistema, de los cuales $PROCS_ROOT son de root"
}


search_diferent_users () {

    NUM_USERS=`ls -ld [[:digit:]]* | cut -d " " -f4 | sort | uniq | wc -l`
    echo "Existen procesos de $NUM_USERS usuarios distintos (incluyendo a root)"
}


search_max_pid () {

    PID_MAX=`ls -d [[:digit:]]* | sort -g | tail --lines 1`
    echo "El PID más alto es el $PID_MAX"
}


search_max_pid_fd () {

    FD_MAX=0
    for i in `ls [[:digit:]]* -d`
    do
        if [ -d $i/fd/ ] ; then
            FD=`ls $i/fd/ | wc -c`
        fi
        if [ $FD -gt $FD_MAX ] ; then
            FD_MAX=$FD
            PID_FD_MAX=$i
        fi
    done
    
    echo "El PID $i es el que más ficheros abiertos tiene ($FD_MAX en total)"
}
