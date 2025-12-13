# Initial Setup

**IMPORTANT: Do not make manual changes to the system outside of what is documented here.**   
This playbook may overwrite manual changes at any time.  
Additionally, this playbook is intended as complete documentation of the initial and ongoing configuration of the server.

1. install ubuntu server 24 LTS (this playbook assumes a ubuntu user with sudo access exists)
1. Manually disable IPv6 in netplan 
    The file might be `/etc/netplan/50-cloud-init.yaml` and look like this:
    ```yml
    network:
      version: 2
      ethernets:
        enp6s0:
          match:
            macaddress: "xx:xx:xx:xx:xx:xx"
          addresses:
          - "2607:5300:203:c8dd::/64"
          dhcp4: true
          accept-ra: false
          set-name: "enp6s0"
          routes:
          - on-link: true
            to: "default"
            via: "2607:5300:203:c8ff:ff:ff:ff:ff"
    ```
    change the content to remove IPv6. The final file content should look something like this:
    ```yml
    network:
      version: 2
      ethernets:
        enp6s0:
          match:
            macaddress: "xx:xx:xx:xx:xx:xx"
          dhcp4: true
          dhcp6: false
          accept-ra: false
          set-name: "enp6s0"
    ```
   (we are not automating this step on purpose, as the risk of lockout is high if hardware changed)
1. place the `vault-password.txt` file in your local ansible directory  
   Reach out through your CoC to obtain it. If you already have ssh access, a copy of this file can be found on the old server in `/home/ubuntu/vault-password.txt`    
   (this file contains the encryption password for files like `/vault/secrets.yml`, which contains API keys and passwords)
1. Run ansible `./main.sh --check --diff` to do a dry run or `./main.sh` to execute the playbook  
   This will install required software, change some system configuration and create folders for the game servers
1. Use letsencrypt to create SSL certificates and restart the webserver
   ```
   sudo letsencrypt certonly --standalone --agree-tos -m <email> -d <domain> --no-eff-email
   sudo systemctl restart apache2.service
   ```
1. Install the squad gameserver control panel in `/var/www/html`
1. Finish the setup for each gameserver instance (see "Adding a Gameserver Instance" in [gameserver-instances.md](gameserver-instances.md))

See [architecture.md](architecture.md) for more information on how a server will be configured and intendet to be used.