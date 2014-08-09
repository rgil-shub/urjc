#!/bin/bash

#
# Diseño y Administración de Sistemas y Redes.
# Practica 1: Análisis de directorios.
# Autor: Roberto Gil
# Fecha: 2005-03-15
#

if [ $# != 1 ] ; then
   echo "Número de argumentos incorrecto"
elif test -d $1 ; then

   TOTAL=$(find $1 | wc -l)

   NORMALES=$(find $1 -type f | wc -l)
   NORMALES_AUX=`expr $NORMALES \* 100`
   XNORMALES=`expr $NORMALES_AUX / $TOTAL`

   DIRECTORIOS=$(find $1 -type d | wc -l)
   DIRECTORIOS_AUX=`expr $DIRECTORIOS \* 100`
   XDIRECTORIOS=`expr $DIRECTORIOS_AUX / $TOTAL`

   BLOQUES=$(find $1 -type b | wc -l)
   BLOQUES_AUX=`expr $BLOQUES \* 100`
   XBLOQUES=`expr $BLOQUES_AUX / $TOTAL`

   CARACTER=$(find $1 -type c | wc -l)
   CARACTER_AUX=`expr $CARACTER \* 100`
   XCARACTER=`expr $CARACTER_AUX / $TOTAL`

   PIPES=$(find $1 -type p | wc -l)
   PIPES_AUX=`expr $PIPES \* 100`
   XPIPES=`expr $PIPES_AUX / $TOTAL`

   SOCKETS=$(find $1 -type s | wc -l)
   SOCKETS_AUX=`expr $SOCKETS \* 100`
   XSOCKETS=`expr $SOCKETS_AUX / $TOTAL`

   ENLACES=$(find $1 -type l | wc -l)
   ENLACES_AUX=`expr $ENLACES \* 100`
   XENLACES=`expr $ENLACES_AUX / $TOTAL`

   echo Análisis de $1 
   echo "$TOTAL ficheros encontrados:"
   if [ $NORMALES != 0 ] ; then
      echo " * $NORMALES ficheros normales ($XNORMALES%)"
   fi
   if [ $DIRECTORIOS != 0 ] ; then
      echo " * $DIRECTORIOS directorios ($XDIRECTORIOS%)"
   fi
   if [ $BLOQUES != 0 ] ; then
      echo " * $BLOQUES dispositivos de bloque ($XBLOQUES%)"
   fi
   if [ $CARACTER != 0 ] ; then
      echo " * $CARACTER dispositivos de caracteres ($XCARACTER%)"
   fi
   if [ $PIPES != 0 ] ; then 
      echo " * $PIPES pipes ($XPIPES%)"  
   fi
   if [ $SOCKETS != 0 ] ; then
      echo " * $SOCKETS sockets ($SOCKETS%)"
   fi
   if [ $ENLACES != 0 ] ; then
      echo " * $ENLACES enlaces simbólicos ($XENLACES%)"   
   fi
else
   echo $1": No es un directorio"
fi

