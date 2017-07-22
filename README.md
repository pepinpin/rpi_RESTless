## Welcome rpi_RESTless

This bash script will help you monitor a REST API heartbeat with a Raspberry Pi

### Requirements

* The API you want to monitor needs to be able to send a JSON object
when querying a specific endpoint with a common HTTP verb (GET, POST, PUT...)
* The default expected response should look like :
```json
{
  "response":"PONG"
}
```

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
* make sure you have jq (JSON processor) installed
```bash
sudo apt install jq
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
* trigger a GPIO pin when the API is down (to turn on a light, a LED or anything else)
