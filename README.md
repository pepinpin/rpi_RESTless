## Welcome rpi_RESTless

This bash script will help you monitor a REST API heartbeat with a Raspberry Pi  
(or any linux box for that matter) and set off an alert if it goes down

* NO PYTHON (full bash script)
* Easy to configure
* Usable via a cron job (use the root's crontab, see the docs directory for more info)
* Trigger a GPIO pin on Raspberry Pi
* Sends a message on Rocket Chat
* Sends an email (requires sendmail, see the docs directory for more info)

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
  cURL, jq (JSON processor), realpath, dirname & git (to clone the repo, you can uninstall it afterwards)
```bash
sudo apt install -y curl jq dirname realpath git
```
* Sendmail installed for email alerting  
  Check the docs directory for instructions on how to

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
(check the docs directory for more info)
```bash
sudo crontab -e
```

### Post install setup

* check this picture to know which pin to set in the CONFIG_FILE  
![pin layout](https://user-images.githubusercontent.com/8282491/28756006-d8ec0a0c-7566-11e7-8044-b8889db79cf1.png)
