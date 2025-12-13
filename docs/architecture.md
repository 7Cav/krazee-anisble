# Architecture

The server is managed via ssh. All admins are intended to use one of the following shared users  
ssh keys are the only enabled authentication method
- `ubuntu`  
  Admin user with password-less sudo enabled
- `squad`  
  User with limited rights to manage squad related files & services. Owns /opt/squad/ and is able to call systemctl commands related to the squad servers.

For management of individual squad instances, there is also a web control panel. 

## System

### Updates

Ubuntu's Unattended-Upgrade is enabled, including normal updates and backports. So manual intervention should only be required in exceptional circumstances and when 24 LTS reaches EOL.    
The server is rebooted automatically after updates have been applied via `auto-update-reboot.timer` which calls `/usr/local/bin/reboot-if-squad-servers-are-empty` (this will ensure a reboot only happens if all squad servers are empty)

### Automations / Timers:
- Restart squad servers around 1400z if they are empty
  (systemd timer: squad-restart-training1.timer, ...)
- Reboot host if needed and all squad servers empty hourly
  (systemd timer: auto-update-reboot.timer)
- Squad admin list generator (see section “Squad Admins”)
  (systemd timer: squad-admin-list-generator.timer)
- Unattended updates for all types of updates
  (default ubuntu configuration)
- Servers will auto restart 30 seconds after they stopped (eg crash or stop via squad command)

## Squad

### folder structure

All gameserver related files are stored in `/opt/squad/` (See gameserver-instances.md for more information).  
Additionally, a web control panel is located in `/var/www/html/` which provides a simple user interface for `squadctl`

### `squadctl` 

squadctl is our main utility to manage squad instances. It's a wrapper around systemctl, steamcmd and rcon located in `/usr/local/bin/squadctl`. The following actions are available:
- **status**   
  current status of an instance. Will output something like `started \n empty` or `started \n has players`  
  The started/stopped state is determined via systemd. Player count is determined via rcon
- **restartIfEmpty**  
  Checks player count via rcon and restarts the instance if empty. May not work if the instance has crashed (use restart in that case)
- **restart**
- **start**
- **stopIfEmpty**
  Checks player count via rcon and restarts the instance if empty. May not work if the instance has crashed (use restart in that case)
- **stop**
- **listMods**
  Lists all downloaded and/or installed mods with an indication if they are just downloaded or enabled. 
- **update**  
  Updates the base gameserver and all mods listed in config.json via steamcmd (might take a long time). Should only be used on stopped instances.  
  This will also resolve dependencies of mods.

### Squad Admins 

The script `/usr/local/bin/squad-admin-list-generator` (run hourly by a systemd timer) will generate 2 admin lists based on the configuration in `/opt/squad/squad-admin-list-generator-config.yml`:  
- `/var/www/html/SquadAdminsGeneratedPublic.cfg`
- `/var/www/html/SquadAdminsGeneratedTraining.cfg`

The script fetches data from https://api.7cav.us/ and a steam id spreadsheet in the 3rd Battalion google drive. Based on that information, admin rights are automatically assigned to members based on SL/ASL billets and S-Departments (like MP, S3, S7, ...).

The admin list is served via a web server and loaded by the squad servers on every map change (this is configured via the RemoteAdminList.cfg file in each squad instance).  
The normal Admins.cfg file in each squad instance is left empty. However, should we need to manually assign additional admins, this is still possible in the Admins.cfg.
