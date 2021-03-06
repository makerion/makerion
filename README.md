# Makerion

Makerion is a 3D printer management project intended to be run on a Raspberry Pi. It will support the official Raspberry Pi touchscreen, camera, and host an embedded web server to upload files, control, and manage print jobs.

![Screenshot](https://github.com/makerion/makerion/blob/master/images/Main.png)

# 3D printer support

* New Matter MOD-t

# Getting Started

## Get the Hardware

* Raspberry Pi 3
  * (You can also use a Raspberry Pi Zero W if you prefer)
* Micro SD card -- anything 2GB or larger should do fine
* WiFi network -- you'll need your ssid and psk (password) to connect
* Computer with Micro SD card slot

## Installation

### Download the files

* Download [balena Etcher](https://www.balena.io/etcher/)
* Go to the latest Makerion [release page](https://github.com/makerion/makerion/releases/latest)
* Download the img file matching your Raspberry Pi
  * If you have a Pi0W, you want `makerion_firmware_rpi_v[x.x.x].img`
  * If you have a Pi3, you want `makerion_firmware_rpi3_v[x.x.x].img`
  
### Create the SD card

* Insert the micro SD card into your laptop or desktop
* Using Etcher, burn the img file to the SD card
  * Under "Select image", choose the img file you downloaded
  * Under "Select drive", choose the CD card you inserted (it is usually auto-selected for you)
  * Click "Flash!" and follow the prompts
  
### Configure WiFi

* Remove and re-insert the SD card once the fw burning tool has finished
* on the BOOT-A volume of the SD card, add a `wifi.yml` file with each of the networks you would like the device to be able to join.

Example `wifi.yml` file:

```yaml
networks:
  - ssid: Home
    psk: wheretheheartis
    priority: 100
  - ssid: Work
    psk: gettinstuffdone
    priority: 99
```
_Note: indentation matters in the file. Use the above as a template if it helps._
_Another Note: for priority, higher numbers indicate higher preference for that access point_

### Hook it up

* Eject the SD card and plug it into the Raspberry Pi
* Put the Raspberry Pi next to the MOD-t and plug the MOD-t into one of the Pi's USB ports
* Power on the Pi
* In a web browser, visit (http://makerion.local). You should see a page with "Upload a New File" and "Printer Status" headers.

## Upgrading to a new version of Makerion

Makerion Firmware has the capability of self-updating to a new version. In order to check for an update and apply it:

* visit (http://makerion.local/firmware)
* If an update is available you'll have the option to apply it. Click the button, wait a minute, and the device will reboot into the new firmware!

![Firmware Update Available](https://github.com/makerion/makerion/blob/master/images/Firmware%20Available.png)
![Firmware Update in progress](https://github.com/makerion/makerion/blob/master/images/Firmware%20Update.png)
