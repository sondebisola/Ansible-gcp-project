# 1. ANSIBLE CONTROL NODE
resource "google_compute_instance" "ansible_ubuntu" {
  name         = "ansible-ubuntu"
  machine_type = var.instance_type
  zone         = var.zone

  boot_disk {
    initialize_params { image = "ubuntu-os-cloud/ubuntu-2204-lts" }
  }

  network_interface {
    network = "default"
    access_config {} 
  }

  metadata_startup_script = <<EOF
#!/bin/bash
${file("${path.module}/ansible-install-ubuntu.sh")}
${file("${path.module}/vscode-install.sh")}
EOF

ssh-keys = "ansible:${file(var.my_key)}"
}

# 2. TWO UBUNTU MANAGED HOSTS
resource "google_compute_instance" "ubuntu_hosts" {
  count        = 2
  name         = "my-ubuntu-${count.index}"
  machine_type = var.instance_type
  zone         = var.zone

  boot_disk {
    initialize_params { image = "ubuntu-os-cloud/ubuntu-2204-lts" }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = file("${path.module}/create_ansible_user.sh")
  ssh-keys = "ansible:${file(var.my_key)}"
}

# 3. ONE RHEL MANAGED HOST
resource "google_compute_instance" "rhel_hosts" {
  name         = "my-rhel-0"
  machine_type = var.instance_type
  zone         = var.zone

  boot_disk {
    initialize_params { image = "rhel-cloud/rhel-9" }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = file("${path.module}/create_ansible_user.sh")
  ssh-keys = "ansible:${file(var.my_key)}"
}


