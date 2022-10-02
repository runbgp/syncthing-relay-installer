# syncthing-relay-installer
A quick and simple script to deploy a Syncthing Relay Server on Ubuntu 20.04 & 22.04.

## Usage
Download the script and make it executable.
```
wget https://git.axite.dev/axite/syncthing-relay-installer/raw/branch/main/syncthing-relay-installer.sh
chmod +x syncthing-relay-installer.sh
```


Remember to update your node description/`-provided-by=` variable on line 28 if desired!


Run the script.
```
sudo ./syncthing-relay-installer.sh
```


Once completed, you should see your relay show up on the relay pool which you can view here https://relays.syncthing.net/