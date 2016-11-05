#**Wifi Cracker**

##Program made in bash that allows you to obtain Wifi's passwords.

###Program works with WPA/WPA2 protocol using PSK authentication, for this option Dictionaries are needed for brute forcing

###Also you can use the program with WEP Wifi's protocol, for this option you don't need any dictionary

###Remember you need to install 'aircrack-ng' and 'macchanger':

| Program  | command |
| ------------- | ------------- |
| **aircrack-ng**  | sudo apt-get install aircrack-ng  |
| **macchanger**  | sudo apt-get install macchanger  |

###Mediafire links for dictionaries: [Dictionaries](https://mega.nz/#F!PB0ljZwC!H1CdY80f0mrTS4AdUm3BZw)

###---------------------------------------------------------------------------------------------------------------------------

### All the process has to be done from 3 terminals. First you have to choose option 1, and then monitor interface is enabled. After that, you choose option 4 and after targetting a Wifi, you have to open a new terminal. Then execute the program again and (with Terminal 1 running) choose option 5 in Terminal 2. You have to wait 1 minute in option 5, and then press Ctrl+C. After that, open a new terminal and choose option 7 from Terminal 3 for finishing. If option 7 doesn't work, try again... that's because you need the user reconnects to the network.

###That's the error you could have

![Little Mistake](error.png)

###Otherwise, routter password appears

![Working Good](funciona.png)

###***************************************************************

###For option 6, you make a fake auth client. Sometimes, there are no clients connected to the network, so you have to create one tricking the routter. You can use your own mac to make fake authentications.

###Here you can see there are some clients connected, but particulary... i want to authenticate the client whose MAC adress is C8:38:70:59:31:4B:

![Unassociated](Unassociated.png)

###So doing option 6 look what happens with C8:38:70:59:31:4B, now it's connected to the network:

![Unassociated](Associated.png)


