#!/bin/bash

#
# Diseño y Administración de Sistemas y Redes.
# Practica 2: Creación y borrado de cuentas de usuario.
# Autor: Roberto Gil
# Fecha: 2005-04-10
#

# set -x

PASSWD=/etc/passwd
PASSWDAUX=/etc/passwd.aux
GROUP=/etc/group

MIN_GID=100
MAX_GID=999

MIN_UID_PROFE=1000
MAX_UID_PROFE=1999

MIN_UID_ALUMNO=2000
MAX_UID_ALUMNO=2999

MIN_UID_OTRO=3000
MAX_UID_OTRO=3999


# Obtiene el primer id libre en el rango $1 $2 dentro del fichero $3
get_next_id() {

   min=$1
   max=$2
   fichero=$3

   i=$min
   while [ $i -lt $max ] ; do
      id=`cut -d: -f3 $fichero | grep $i`
      case $id in
      "")
         userid=$i
         break;;
      esac
      i=`expr $i + 1`
   done

   echo $userid # siguiente id
}

check_gid() {

   grupo=$1

   if [ ! "`grep "^$grupo:" $GROUP`" ] ; then
      gid=`get_next_id $MIN_GID $MAX_GID $GROUP`
      if [ ! $gid ] ; then
         echo "No hay GIDs libres"; exit 0
      fi
      
      echo "$grupo:x:$gid:" >> $GROUP
      echo $gid
   fi
}

check_uid() {

   grupo=$1
   
   if [ $grupo == "profe" ] ; then
      uid=`get_next_id $MIN_UID_PROFE $MAX_UID_PROFE $PASSWD`
   elif [ $grupo == "alumno" ] ; then
      uid=`get_next_id $MIN_UID_ALUMNO $MAX_UID_ALUMNO $PASSWD`
   elif [ $grupo == "otro" ] ; then
      uid=`get_next_id $MIN_UID_OTRO $MAX_UID_OTRO $PASSWD`
   fi

   if [ ! $uid ] ; then
      echo "No hay UIDs libres"; exit 0
   fi
   echo $uid
}


password() {

   usuario=$1

   i=0
   while [ $i -lt 3 ] ; do

      if passwd $usuario ; then
         break
      else
         echo "contraseña incorrecta, introdúzcala de nuevo por favor"
      fi

      i=`expr $i + 1`

      if [ $i -eq 3 ] ; then
         # bloquear cuenta
         sed "/^$usuario:/s/\/bin\/bash/\/bin\/false/" $PASSWD > $PASSWDAUX
         mv $PASSWDAUX $PASSWD
      fi
   done
}

crea_cuenta() {
   
   usuario=$1
   nombre=$2
   grupo=$3
   uid=$4
   gid=$5
   
   # Añadir usuario a /etc/passwd
   echo "$usuario:!:$uid:$gid:$nombre:/home/$usuario:/bin/bash" >> $PASSWD
   
   # Crear la home del usuario
   mkdir /home/$usuario

   # Copiarle el skel
   cp /etc/skel/.* /home/$usuario 2>/dev/null

   # Permisos
   chown -R $usuario /home/$usuario
   chgrp -R $grupo /home/$usuario

   # Password
   password $usuario
}


#
# Requisitos para la ejecucion de crea-cuenta:
# - 3 argumentos
# - 1er argumento con más de 3 y menos de 8 caracteres (minusculas) 
# - El usuario no debe estar en /etc/passwd
# - 2º argumento no debe contener ":"
# - 3er argumento debe ser "profe", "alumno" u "otro"
#

if [ $# != 3 ] ; then
   echo "Número de argumentos incorrecto"
elif [ `expr length $1` -lt 3 ] || [ `expr length $1` -gt 8 ] || [ `echo $1 | grep [[:upper:]]` ] ; then
   echo "El login \"$1\" no es válido"
elif [ "`grep "^$1:" $PASSWD`" ] ; then 
   echo "El login \"$1\" ya existe"
elif [ $(echo $2 | grep :) ] ; then
   echo "El nombre real no puede contener el carácter \":\""
elif [ $3 != "profe" ] && [ $3 != "alumno" ] && [ $3 != "otro" ] ; then
   echo "El grupo ha de ser \"alumno\", \"profe\" u \"otro\""

# Todo correcto, creamos el usuario.
else

   # Si el grupo no existe, crearlo con el primer GID que que esté libre.
   gid=`check_gid $3`
   #echo $gid
  
   # El UID será el primer valor libre dentro de los asignados a su grupo.
   uid=`check_uid $3`
   #echo $uid

   crea_cuenta $1 $2 $3 $uid $gid 

fi

