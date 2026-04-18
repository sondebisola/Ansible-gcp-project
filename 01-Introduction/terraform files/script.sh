#!/bin/bash

#!/bin/bash

# 1. Ensure the ansible user's .ssh directory exists with secure permissions
sudo mkdir -p /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh

# 2. WAIT for GCP to populate the authorized_keys file (Safety Loop)
# This checks every 5 seconds (up to 60s) if the file has content (> 0 bytes)
timeout=60
while [ ! -s /home/ubuntu/.ssh/authorized_keys ] && [ $timeout -gt 0 ]; do
   echo "Waiting for GCP to inject SSH keys..."
   sleep 5
   ((timeout-=5))
done

# 3. Copy the keys using sudo to avoid "Permission Denied" errors
if [ -s /home/ubuntu/.ssh/authorized_keys ]; then
    sudo cp /home/ubuntu/.ssh/authorized_keys /home/ansible/.ssh/authorized_keys
    
    # 4. Set ownership and strict file permissions (Critical for SSH trust)
    sudo chown ansible:ansible /home/ansible/.ssh/authorized_keys
    sudo chmod 600 /home/ansible/.ssh/authorized_keys
    echo "SSH keys successfully migrated to ansible user."
else
    echo "Error: GCP keys were never populated. Check Metadata settings."
fi

# 5. Initialize the global Ansible configuration directory
sudo mkdir -p /etc/ansible
sudo chown -R ansible:ansible /etc/ansible

echo "Ansible environment setup complete."