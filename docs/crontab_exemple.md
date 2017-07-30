here is an exemple of a working crontab:

### Use the root's crontab to run these jobs

```bash
sudo crontab -e
```

### Edit it so it looks like this :

```bash
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

@reboot /home/pi/rpi_RESTless/runMe.sh force
* * * * * /home/pi/rpi_RESTless/runMe.sh
* * * * * /etc/myDevices/crontab.sh

```

