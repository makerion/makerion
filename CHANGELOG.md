# Changelog

## v0.2.3

* Improvements
  * Initial picam support (disabled)
  * Upgraded nerves to 1.5

## v0.2.2

* Improvements
  * Setting `mdns_domain` on wifi.yml top level now sets the hostname (eg: `mdns_domain: makeriontest.local`)
  * Adding an `ssh_authorized_keys` list on wifi.yml top level with each entry as a public key to be authorized now sets up remote ssh and firmware over ssh using those public keys. This is mostly for development and troubleshooting and is not expected for typical use cases.

* Bugfixes
  * Touch/click works to select a print file on mobile Safari browsers now

## v0.2.1

* Bugfixes
  * Read from status address after write batches of 20 to ensure the printer can keep up

## v0.2.0

* Improvements
  * switch to use the native Elixir/libusb driver

## v0.1.10

* Improvements
  * Added progress bar for firmware
  * Links to firmware upgrade from nav bar when one is available
  * Separate printer controls from printer status
  * Minor visual tweaks (still a long way to go here)

## v0.1.9

* Improvements
  * Add status updates during a firmware upgrade
  * Detach firmware upgrades from phoenix request process

## v0.1.8

* Bugfixes
  * Fix rpi firmware self-upgrade to look for the correct system on GitHub releases

## v0.1.7

* Improvements
  * Moved network initiailization down into the shoehorn application (so that network is initialized before everything else comes up)
  * Added mdns so that makerion.local is autoconfigured as the hostname

## v0.1.6

* Improvements
  * Add initial firmware self-update capability using GitHub releases

## v0.1.5

* Improvements
  * Generate a sha256 for each artifact (for firmware file verification after download)

## v0.1.4

* Improvements
  * Add last printed at to print files

## v0.1.3

* Bugfixes
  * Update kiosk application to use new push: graph

## v0.1.2

* Improvements
  * Add rpi0 as a target in addition to the rpi3 (but without kiosk app)

## v0.1.1

* Bugfixes
  * Compile phoenix assets on firmware generation

* Changes
  * Use VERSION file to bump package version

## v0.1.0

Initial release!
