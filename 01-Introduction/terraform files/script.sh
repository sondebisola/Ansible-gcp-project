#!/bin/bash

# 1. Prepare the directory
sudo mkdir -p /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh

# 2. WAIT for GCP to populate the keys (checks for > 0 bytes)
timeout=60
while [ ! -s /home/ubuntu/.ssh/authorized_keys ] && [ $timeout -gt 0 ]; do
   echo "Waiting for GCP keys to arrive..."
   sleep 5
   ((timeout-=5))
done

# 3. Use SUDO to copy (This is why it was failing!)
if [ -s /home/ubuntu/.ssh/authorized_keys ]; then
    sudo cp /home/ubuntu/.ssh/authorized_keys /home/ansible/.ssh/authorized_keys
    sudo chown ansible:ansible /home/ansible/.ssh/authorized_keys
    sudo chmod 600 /home/ansible/.ssh/authorized_keys
    echo "Keys migrated successfully."
else
    echo "Timeout reached: No keys found."
fi

# 4. Set up Ansible config access
sudo mkdir -p /etc/ansible
sudo chown -R ansible:ansible /etc/ansible