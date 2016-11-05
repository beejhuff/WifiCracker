# Programa en bash hecho para averiguar la contraseña de un Wifi por medio de
# deautenticación de clientes conectados a la misma - (https://github.com/Marcelorvp/WifiCracker)

# Copyright (c) 2016 Marcelo Raúl Vázquez Pereyra

#!/bin/bash

# ¡¡Debes de ejecutar el programa siendo superusuario!!

monitor="mon0"
usuario=$(whoami)
usuarioNormal="$USER"

monitorMode(){

  #Tienes que ser root para ejecutar esta opción, de lo contrario no podrás

  if [ "$usuario" = "root" ]; then
    echo " "
    echo "Abriendo configuración de interfaz..."
    echo " "
    sleep 2
    ifconfig
    echo " "
    echo "Iniciando modo monitor..."
    sleep 2
    if [ "ifconfig | grep $monitor" = "$monitor" ]; then
      echo " "
      echo "Ya iniciaste antes el modo monitor, no se te va a permitir iniciar otro"
      echo " "
      sleep 3
    else
      airmon-ng start wlp2s0
      echo " "
      echo "Dando de baja la interfaz mon0"
      echo " "
      sleep 2
      ifconfig mon0 down
      echo "Cambiando direccion MAC..."
      echo " "
      sleep 2
      macchanger -a mon0
      echo " "
      echo "Dando de alta la interfaz mon0"
      echo " "
      sleep 2
      ifconfig mon0 up
    fi
  elif [ "$usuario" = "$USER" ]; then
    echo " "
    echo "Para ejecutar esta opción primero debes ser superusuario"
    echo " "
    sleep 3
  fi

}

interfacesMode(){

  echo " "
  echo "Abriendo configuración de interfaz..."
  echo " "
  sleep 2
  ifconfig
  echo " "
  sleep 4

}

monitorDown(){

  echo " "
  echo "Dando de baja el modo monitor..."
  echo " "
  sleep 2
  if [ "ifconfig | grep $monitor" = "mon0" ]; then
    airmon-ng stop mon0
    echo " "
    sleep 4
  else
    echo "No hay interfaz mon0, tienes que iniciarla con la opción 1"
    sleep 3
  fi

}

while true
  do

    clear
    echo " "
    echo "*** Wifi Cracker ***"
    echo " "
    echo "1. Iniciar el modo monitor "
    echo "2. Mostrar interfaces"
    echo "3. Dar de baja el modo monitor"
    echo "4. Escanear redes wifis"
    echo "---------------------------"
    echo "0. Salir "
    echo "---------------------------"
    echo " "
    echo -n "Introduzca una opcion: "
    read opcionMenu

    if [ "$opcionMenu" = "1" ]; then
      monitorMode
    fi
    if [ "$opcionMenu" = "2" ]; then
      interfacesMode
    fi
    if [ "$opcionMenu" = "3" ]; then
      monitorDown
    fi
    if [ "$opcionMenu" = "0" ]; then
      echo " "
      exit
    fi

done
