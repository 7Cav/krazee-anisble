# 7Cav Squad Server

**This repository contains the ansible playbook and all documentation related to our squad infrastructure.**

Any changes made to the architecture of the squad server should be done via ansible or at least documented here.  
**IMPORTANT: Do not make manual changes to the system outside of what is documented in this repository.** This playbook may overwrite manual changes at any time.   

The server is managed via ssh and ansible, individual squad instances can be managed either through squadctl via ssh or the web control panel. 

For more details on the architecture and how to use this playbook, see the [docs folder](docs/) and the yml files in [tasks folder](tasks/) (the yml tasks are intended to be both the automation and documentation). 

## Useful commands
The following example commands contain the name `training1`. Check the web control panel or inventory.yml for a list of available servers.  

##### Squad server - check status, start, stop, restart:
```
squadctl --name training1 --action status
squadctl --name training1 --action restartIfEmpty
squadctl --name training1 --action restart
squadctl --name training1 --action start
squadctl --name training1 --action stopIfEmpty
squadctl --name training1 --action stop
squadctl --name training1 --action listMods
```

##### Status of the Server (via rcon, show game info):
```
/opt/squad/training1/rcon showserverinfo | jq
```

##### Reboot the host if all squad servers are empty:
```
sudo reboot-if-squad-servers-are-empty
```

##### Reboot the host (even if squad servers are populated):
```
sudo reboot
```

##### View Server output log file (you can close the window with q):
```
journalctl --namespace squad-training1
```

##### Live view of the Server output log file (you can stop with CTRL+C):
```
journalctl --namespace squad-training1 -f -n 100
```

##### Edit Server Config (name, password, ...) (keyboard only editor, exit: CTRL+X):
```
nano /opt/squad/training1/SquadGame/ServerConfig/Server.cfg
```

##### Edit mod list (list of steam workshop IDs) (keyboard only editor, exit: CTRL+X):
```
nano /opt/squad/training1/config.json
```

##### Update squad & mods (make sure you stop the server first):
```
squadctl --name training1 --action update
```

##### Enable a server auto start after reboot:
```
sudo systemctl enable squad-training1.service
```

##### Disable a server auto start after reboot:
```
sudo systemctl disable squad-training1.service
```


