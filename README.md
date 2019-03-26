# Makerion

Makerion is a 3D printer management project intended to be run on a Raspberry Pi. It will support the official Raspberry Pi touchscreen, camera, and host an embdedded web server to upload files, control, and manager print jobs.

# 3D printer support

Initially, this project is starting as a method of supporting people who purchased the New Matter MOD-t printers. Since New Matter closed its doors, people can only print locally to the printer over USB. This project is intended to be installed on a Raspberry Pi 3 local to the printer, so that files can be uploaded remotely.

# Getting Started

## Hardware

* Raspberry Pi 3 (any of the variants should work)
* WiFi (Hardwired Ethernet not yet supported)
* HDMI display (only for initial setup to determined IP address)
* Laptop with Micro SD card slot

## Installation

* download the latest .fw file in the [releases page](https://github.com/makerion/makerion/releases)
* Using a toole like [Etcher](https://www.balena.io/etcher/), burn the fw file to a suitable SD card (8 GB minimum recommended)
* Remove and re-insert the SD card once the fw burning tool has finished
* on the /boot/ filesystem of the SD card, add a `wifi.yml` file with each of the networks you would like the device to be able to join.

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

* unmount the SD card and plug it into the Raspberry Pi 3
* Plug the Pi into a TV or HDMI monitor and power on the Pi
* You should see some boot up messages eventually followed by an IP address
* Write down the IP address for later
* Put the Raspberry Pi next to the MOD-t and plug the MOD-t into one of the Pi's USB ports
* Power on the Pi
* In a web browser, visit the IP address you wrote down. You should see a page with "Upload a New File" and "Printer Status" headers.
