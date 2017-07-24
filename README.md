## Welcome rpi_RESTless

This bash script will help you monitor a REST API heartbeat with a Raspberry Pi (or any linux box for that matter)
and trigger the GPIO pins (on Raspi only) to turn on a light, a motor or whatever you fancy ^-^ 
(send an email, a message on slack / rocket chat, start another script...)

* NO PYTHON (full bash script)
* Easy to configure

### Requirements

* The API you want to monitor needs to be able to send a JSON object
when querying a specific endpoint with a common HTTP verb (GET, POST, PUT...)
* The default expected response should look like :
```json
{
  "response":"PONG"
}
```
* The following packages installed :
    cURL, jq (JSON processor) & git (to clone the repo, you can uninstall it afterwards)
```bash
sudo apt install curl jq git
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
* Run the script to see if it works
```bash
./runMe.sh
```
* setup a cron (every minute or so)
```bash
crontab -e
```

### Post install setup

* check this picture to know which pin to set in the CONFIG_FILE
![pin layout](https://user-images.githubusercontent.com/8282491/28538336-3c943326-70ae-11e7-8049-c2b9b3c98167.png)

### TODO

* make the script runnable via a cron
* send an email when the target API is down
