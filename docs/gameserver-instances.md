# Managing Gameserver Instance

## Adding a Gameserver Instance
1. Add the desired server in `inventory.yml` under `all.children.gameservers.<hostname>.squad.instances`:
   ```yml
   training1: # unique name, used as folder and systemd service name and in commands like squadctl. (must start with a letter and may not contain spaces or special characters)
     gamePort: 7787 # ensure no overlap with any other port. Recommended to simply increment the highest gamePort by 1 
     queryPort: 27165 # ensure no overlap with any other port. Recommended to simply increment the highest queryPort by 1
     beaconPort: 15000 # ensure no overlap with any other port. Recommended to simply increment the highest beaconPort by 1
     rconPort: 21114 # ensure no overlap with any other port. Recommended to simply increment the highest rconPort by 1
     cpuList: 0-3 # specifies which cpu cores to pin the process to. Avoid overlap with other instances. Check CPU specification to ensure all selected cores are on the same package. Choose chores with cache for the best performance 
   ```
1. run `./main.sh`  
   This will rerun the entire playbook (but that's ok, Ansible is designed to be repeatedly run) and create:
   - the folder for the gameserver instance (eg: `/opt/squad/training1`)
   - the systemd service file for the gameserver instance in `/etc/systemd/system`    
       
   (please note that the web control panel will cache the list of servers. So it might take up to 10 minutes before the server is visible there)
1. run `squadctl --name training1 --action update`  
   squadctl update will call steamcmd to download the gameserver files (also creates default squad config files)  
   You can also use the web control panel, however, the initial download will take a long time and might timeout when run through the panel
1. Edit the gameserver config files
   - either the config files in `/opt/squad/training1/SquadGame/ServerConfig`
   - or use the web control panel
1. install mods (optional) (see below)
1. run  `squadctl --name training1 --action start`
1. auto restart
   ```
   sudo systemctl start squad-restart-fireteam1.timer
   ```
1. autostart (optional)   
   - enable:
      ```
      sudo systemctl enable squad-training1.service
      ```
   - disable:
      ```
      sudo systemctl disable squad-training1.service
      ```
1. add the server to battlemetrics (optional)     

## Managing mods 
Mods are managed via `config.json` and `squadctl`.  
You can add/remove mods in two ways:
- using the web control panel
  - navigate to the desired server
  - stop the server
  - edit config.json (see below for an example file content)
  - update the server
  - start the server
- using ssh / `squadctl` (the example assumes the server is named `training1`):
  - stop the server: `squadctl --name training1 --action stopIfEmpty` (or `squadctl --name training1 --action stop`)
  - edit the config file in `/opt/squad/training1/config.json`
  - start the server: `squadctl --name training1 --action update`
  - start the server: `squadctl --name training1 --action start`

The `config.json` file contains a list of mods.  
The update script will take those IDs and download them from the workshop (including dependencies).  

Mods are listed as steam workshop ids, seperated by a comma.   
The id can be found in the workshop url. For example, if you wish to install "SquidBots Zeus" and "RiseEventSquad", the links would be:  
https://steamcommunity.com/sharedfiles/filedetails/?id=2914624834  
https://steamcommunity.com/sharedfiles/filedetails/?id=3096159619  
We can take the IDs from the end of the URL and put them into the `config.json` file:
```json 
{
    "mods": [
        2914624834,
        3096159619
    ]
}
```
