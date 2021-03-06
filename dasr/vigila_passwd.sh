#!/bin/bash

#
# Diseño y Administración de Sistemas y Redes.
# Practica 3: Vigilancia y supervisión del sistema.
# Autor: Roberto Gil
#

### PASSWD ###


# Variables para hacer pruebas
PASSWD="/etc/passwd"
GROUP="/etc/group"
SHADOW="/etc/shadow"


# Comprobar que cada fichero tiene información valida

check_files () {

    ## passwd ## 

    #( 6 : ) 
    lines=`cat $PASSWD | egrep -nv ".*:.*:.*:.*:.*:.*:.*" | cut -d: -f1`
    for i in $lines ; do 
        echo "Error en la línea $i del fichero /etc/passwd (numero de campos incorrecto)"
    done

    # Login compuesto por letras
    line=0
    for i in `awk -F: '{print $1}' $PASSWD`; do
        line=`expr $line + 1`
        if [ `echo $i | grep [[:digit:]]` ] ; then
            echo "Error en la línea $line del fichero /etc/passwd (login con numeros)"
        fi
    done

    # UID con valor entre 0 y 65535
    line=0
    for i in `awk -F: '{print $3}' $PASSWD`; do 
        line=`expr $line + 1`
        if [ `echo $i | grep [a-zA-Z]` ] ; then
            echo "Error en la línea $line del fichero /etc/passwd (UID con letras)"
        elif [ $i -gt 65535 ] || [ $i -lt 0 ] ; then
            echo "Error en la línea $line del fichero /etc/passwd (UID con valor fuera de rango)"
        fi
    done  

    # GUID con valor entre 0 y 65535
    line=0
    for i in `awk -F: '{print $4}' $PASSWD`; do
        line=`expr $line + 1`
        if [ `echo $i | grep [a-zA-Z]` ] ; then
            echo "Error en la línea $line del fichero /etc/passwd (GUID con letras)"
        elif [ $i -gt 65535 ] || [ $i -lt 0 ] ; then
            echo "Error en la línea $line del fichero /etc/passwd (GUID con valor fuera de rango)"
        fi
    done 


    ## shadow ## 
    
    # ( 8 : )
    lines=`cat $SHADOW | egrep -nv ".*:.*:.*:.*:.*:.*:.*:.*:.*" | cut -d: -f1`
    for i in $lines ; do
        echo "Error en la línea $i del fichero /etc/shadow (numero de campos incorrecto)"
    done

    # Login compuesto por letras
    line=0
    for i in `awk -F: '{print $1}' $SHADOW`; do
        line=`expr $line + 1`
        if [ `echo $i | grep [[:digit:]]` ] ; then             
            echo "Error en la línea $line del fichero /etc/shadow (login con numeros)"
        fi
    done


    ## group ##
 
    # ( 3 : )
    lines=`cat $GROUP | egrep -nv ".*:.*:.*:.*" | cut -d: -f1`
    for i in $lines ; do
        echo "Error en la línea $i del fichero /etc/group  (numero de campos incorrecto)"
    done

    # GUID con valor entre 0 y 65535
    line=0
    for i in `awk -F: '{print $3}' $GROUP`; do
        line=`expr $line + 1`
        if [ `echo $i | grep [a-zA-Z]` ] ; then
            echo "Error en la línea $line del fichero /etc/group  (GUID con letras)"
        elif [ $i -gt 65535 ] || [ $i -lt 0 ] ; then
            echo "Error en la línea $line del fichero /etc/group  (GUID con valor fuera de rango)"
        fi
    done
}


# Comprueba si hay algún login en el /etc/passwd que no este en el 
# /etc/shadow, o viceversa.

check_login () {

    for user in `awk -F: '{print $1}' $PASSWD`; do 
        if [ "`grep $user $SHADOW`" == "" ]; then
            echo "El usuario $user está en /etc/passwd pero no en /etc/shadow"
        fi
    done

    for user in `awk -F: '{print $1}' $SHADOW`; do 
        if [ "`grep $user $PASSWD`" == "" ]; then
            echo "El usuario $user está en /etc/shadow pero no en /etc/passwd"
        fi
    done
}


# Comprueba si alguna línea del /etc/group contiene un login que no esté en el
# /etc/passwd

check_lines () {

    for users in `awk -F: '{print $4}' $GROUP`; do
        
        #split: convertir "user1,user2,user3" a "user1 user2 user3"
        user=`echo $users |  sed s/,/" "/g`
        
        for i in $user ; do
            if [ "`grep $i $PASSWD`" == "" ]; then
                echo "El usuario $i en el fichero /etc/group no existe en el sistema"
            fi
        done
    done
}


# Comprueba si dos líneas del /etc/passwd o dos líneas del /etc/shadow 
# contienen el mismo login

search_login_repeats () {
    
    for i in `awk -F: '{print $1}' $PASSWD | sort -g | uniq` ; do
        repeats=`cat $PASSWD | grep -w ^$i | wc -l`
        if [ $repeats -eq 2 ] ; then
            echo "El usuario $i está repetido en el fichero /etc/passwd"
        fi
    done
    
    for i in `awk -F: '{print $1}' $SHADOW | sort -g | uniq` ; do
        repeats=`cat $SHADOW | grep -w ^$i | wc -l`
        if [ $repeats -eq 2 ] ; then
            echo "El usuario $i está repetido en el fichero /etc/shadow"
        fi
    done
}


# Comprueba si dos líneas del /etc/group contienen el mismo nombre de grupo

search_group_repeats () {

    for i in `awk -F: '{print $1}' $GROUP | sort -g | uniq` ; do
        repeats=`cat $GROUP | grep -w ^$i | wc -l`
        if [ $repeats -eq 2 ] ; then
            echo "El grupo $i está repetido en el fichero /etc/group"
        fi
    done
}


# Comprueba si el /etc/passwd tiene dos líneas con el mismo UID

search_UID_repeats () {

    for i in `awk -F: '{print $3}' $PASSWD | sort -g | uniq` ; do
        repeats=`cat $PASSWD | cut -d: -f3 | grep -w $i | wc -l`
        if [ $repeats -eq 2 ] ; then
            user1=`cat $PASSWD | grep -w $i | cut -d: -f1 | tail --lines=1`
            user2=`cat $PASSWD | grep -w $i | cut -d: -f1 | head --lines=1`
            echo "El UID $i pertenece a dos usuarios: $user1 y $user2"
        fi
    done
}


# Comprueba si el /etc/group tiene dos líneas con el mismo GID

search_GID_repeats () {
 
    for i in `awk -F: '{print $3}' $GROUP | sort -g | uniq` ; do
        repeats=`cat $GROUP | cut -d: -f3 | grep -w $i | wc -l`
        if [ $repeats -eq 2 ] ; then
            group1=`cat $GROUP | grep -w $i | cut -d: -f1 | tail --lines=1`
            group2=`cat $GROUP | grep -w $i | cut -d: -f1 | head --lines=1`
            echo "El GID $i pertenece a dos grupos: $group1 y $group2"
        fi
    done
}


# Comprueba si hay usuarios sin contraseña (campo passwd vacío en el 
# /etc/passwd  o en el /etc/shadow)

search_no_pass () {

    for i in `awk -F: '{if ($2 == "") print $1}' $PASSWD $SHADOW | sort | uniq` ; do
        echo "El usuario $i no tiene contraseña"
    done
}
    
