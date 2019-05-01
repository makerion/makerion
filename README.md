# Makerion

Makerion is a 3D printer management project intended to be run on a Raspberry Pi. It will support the official Raspberry Pi touchscreen, camera, and host an embedded web server to upload files, control, and manage print jobs.

![Screenshot](https://github.com/makerion/makerion/blob/master/images/Main.png)

# 3D printer support

Initially, this project is starting as a method of supporting people who purchased the New Matter MOD-t printers. Since New Matter closed its doors, people can only print locally to the printer over USB. This project is intended to be installed on a Raspberry Pi 3 local to the printer, so that files can be uploaded remotely.

# Getting Started

## Software Prerequisites

Makerion is distributed in both .img and .fw formats. If you're familiar with Raspbian, you've encountered img files before. Using a tool like [balena Etcher](https://www.balena.io/etcher/), you can burn the img file to an SD card.

## Hardware

* Raspberry Pi Zero W or 3/3A
* Micro SD card -- anything 2GB or larger should do fine
* WiFi network -- you'll need your ssid and psk (password) to connect
* Laptop with Micro SD card slot

## Installation

* download the latest .img file in the [releases page](https://github.com/makerion/makerion/releases)
  * Look for the filename matching your system
  * If you have a Pi0W, you'll want makerion_firmware_rpi_v[x.x.x].img
  * If you have a Pi3, you'll want makerion_firmware_rpi3_v[x.x.x].img
* Insert the micro SD card into your laptop or desktop
* Using a tool like [balena Etcher](https://www.balena.io/etcher/), burn the image to an SD card
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
_Note: higher numbers are higher priority, as with wpa-supplicant_

* Eject the SD card and plug it into the Raspberry Pi
* Put the Raspberry Pi next to the MOD-t and plug the MOD-t into one of the Pi's USB ports
* Power on the Pi
* In a web browser, visit (http://makerion.local). You should see a page with "Upload a New File" and "Printer Status" headers.

## Upgrade

Makerion Firmware has the capability of self-updating to a new version. In order to check for an update and apply it:

* visit (http://makerion.local/firmware)
* If an update is available you'll have the option to apply it. Click the button, wait a minute, and the device will reboot into the new firmware!

![Firmware Update Available](https://github.com/makerion/makerion/blob/master/images/Firmware%20Available.png)
![Firmware Update in progress](https://github.com/makerion/makerion/blob/master/images/Firmware%20Update.png)
