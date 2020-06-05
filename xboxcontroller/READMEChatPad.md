# XboX Controller Wireless USB Adapter
![01](https://www.journaldulapin.com/wp-content/uploads/2013/07/DSC03025.jpg)

---

The Xbox 360 ChatPad is a keyboard originally intended to connect to the controllers 

What is interesting is that the keyboard uses a very simple protocol: it is completely classic. We therefore have a connector with 4 pins
 TX, RX, 3.3 V and ground.

![11](https://www.journaldulapin.com/wp-content/uploads/2013/07/IMG_2758.jpg)

It is therefore necessary to connect the 
power supply to PIN 1 of the Raspberry Pi (3.3 V), the 
ground to PIN 6, the 
keyboard RX to PIN 14 (TX) and the 
keyboard TX to PIN 15 (RX).

A 1000 Ω resistor should be placed at the RX and TX connectors
![12](https://www.journaldulapin.com/wp-content/uploads/2013/07/IMG_2759.jpg)



Installation on the Raspberry Pi
```shell
sudo wget http://www.newsdownload.co.uk/downloads/RemoteKeypadDriver.tar.gz
sudo gunzip RemoteKeypadDriver.tar.gz
sudo tar -xf RemoteKeypadDriver.tar
cd / root / RemoteKeypadDriver /
sudo chmod + x install.sh
sudo ./install.sh
```
We can then exit root mode and return to a more traditional user.

If you have overclocked the Raspberry Pi, be careful: the serial connector does not like that and you have to set the frequency of the controller at 250 Mhz.
```shell
sudo nano /boot/config.txt
```
Add the following line if it is not present (or set the value to 250).
```shell
core_freq = 250
```
If ever the keyboard seems to work strangely, which was my case, you have to go fix a point in the pilot. By default, it listens in effect on several GPIO connectors and this can cause problems in some cases.
```shell
sudo nano /root/RemoteKeypadDriver/RemoteKeypad.ini
```
It is necessary to seek the line which begins with GPIO_PINS = and to replace all the values ​​by -1, except obviously the two connectors actually used (ie the values ​​14 and 15).

Once it's done, restart the Raspbbery Pi and the keyboard should be usable.

---

[![Solid00](https://raspberry-valley.azurewebsites.net/img/raspibanner.jpg)](https://github.com/D3vD3m0n/)
