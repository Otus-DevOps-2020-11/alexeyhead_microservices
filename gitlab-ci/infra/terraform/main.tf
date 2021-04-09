provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  version                  = "~>0.35.0"
}

resource "yandex_compute_instance" "gitlab" {
  count  = var.vm_count
  name   = "gitlab-${count.index}"

  labels = {
    tags = "gitlab"
  }

  resources {
    cores         = 2
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size = 50
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type = "ssh"
    host = self.network_interface.0.nat_ip_address
    user = "ubuntu"
    agent = false
    private_key = file(var.private_key_path)
  }

//  provisioner "remote-exec" {
//    inline = [
//      "docker container run -d -p 9292:9292 oleksiihead/otus-reddit:1.0"
//    ]
//  }

}
