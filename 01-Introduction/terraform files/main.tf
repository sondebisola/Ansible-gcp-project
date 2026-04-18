# 1. THE CONTROL NODE (Ansible-Ubuntu)
resource "google_compute_instance" "ansible_ubuntu" {
  name         = "ansible-ubuntu"
  machine_type = var.my_instance_type
  zone         = var.gcp_region == "us-central1" ? "us-central1-a" : "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {} # Assigns a Public IP
  }

  # This creates the 'ansible' user and injects your MacBook's key
  metadata = {
    ssh-keys = "ansible:${file(var.my_key)}"
  }

  metadata_startup_script = <<EOF
#!/bin/bash
${file("${path.module}/ansible-install-ubuntu.sh")}
${file("${path.module}/vscode-install.sh")}
EOF
}

# 2. THE MANAGED UBUNTU NODES (Count = 2)
resource "google_compute_instance" "ubuntu_hosts" {
  count        = 2
  name         = "my-ubuntu-${count.index}"
  machine_type = var.my_instance_type
  zone         = var.gcp_region == "us-central1" ? "us-central1-a" : "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ansible:${file(var.my_key)}"
  }

  metadata_startup_script = file("${path.module}/create_ansible_user_ubuntu.sh")
}

# 3. THE MANAGED RHEL NODE (Count = 1)
resource "google_compute_instance" "rhel_hosts" {
  name         = "my-rhel-0"
  machine_type = var.my_instance_type
  zone         = var.gcp_region == "us-central1" ? "us-central1-a" : "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-9"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ansible:${file(var.my_key)}"
  }

  metadata_startup_script = file("${path.module}/create_ansible_user_rhel.sh")
}

# 4. FIREWALL RULE (To allow you to SSH from your Mac)
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-ansible-lab"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # For learning; restrict to your IP for better security
}


