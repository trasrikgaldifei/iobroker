# iobroker
This is an automated build based on Debian Stretch (slim image) to bring ioBroker to Docker environments (like NAS or home servers).

Features:
* NodeJS version can be selected using tags (currently, node 8 and node 10 are available)
* Mounted ioBorker folder is automatically populated on startup (if empty)
* Server name in iobroker-data/objects.json is automatically updated to the server name of the container on startup 


Example docker-compose.yml:

```
version: '2.3'
services:
    iobroker:
        image: trasrik/iobroker
        hostname: iobroker
        networks:
            - default
        volumes:
            - ./iobroker:/opt/iobroker
            - ./iobroker_backup:/otp/iobroker_backup
        expose:
            - "8081"
            - "8082"
            - "9000"
            - "9001"
        ports:
            - "8081:8081"
            - "8082:8082"
            - "9000:9000"
            - "9001:9001"
        restart: always
```

This is still work in progress. Use on your own risk.