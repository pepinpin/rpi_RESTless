## Welcome rpi_RESTless

This bash script will help you monitor a REST API heartbeat with a Raspberry Pi

### Installation

* Clone this repo
```bash
git clone https://github.com/pepinpin/rpi_RESTless.git
```
* cd into the project folder
```bash
cd rpi_RESTless
```
* rename the CONFIG_FILE.sample to CONFIG_FILE
```bash
mv CONFIG_FILE.sample CONFIG_FILE
```
* edit the CONFIG_FILE to suit your needs
```bash
nano CONFIG_FILE
# or
vim CONFIG_FILE
```
* Run the script to see if it works
```bash
./testAPI.sh
```
* setup a cron (every minute or so)
```bash
crontab -e
```

### TODO

* send an email when the API is down
* trigger a GPIO pin when API is down (to turn on a light, a LED or anything else)
