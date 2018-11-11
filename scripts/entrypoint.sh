#!/bin/bash

# Populate empty mounted ioBroker directory
if [ ! -f /opt/iobroker/iobroker ];
then
	cp -Rf /opt/iobroker_install/* /opt/iobroker
fi

# Update container hostname from installation (if necessary)
sed -i "s/IOBROKER_INSTALL_HOST/$(hostname)/g" iobroker-data/objects.json

# Correct hostname from last start (if necessary)
if [ -f /opt/.last_hostname ];
then
	sed -i "s/$(cat /opt/.last_hostname)/$(hostname)/g" iobroker-data/objects.json
fi
echo $(hostname) >/opt/.last_hostname

/usr/bin/node node_modules/iobroker.js-controller/controller.js

tail -f /dev/null