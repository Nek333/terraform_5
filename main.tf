resource "yandex_lb_target_group" "foo" {
  name      = "my-target-group"

  target {
    subnet_id = yandex_vpc_subnet.tar-subnet-a.id
    address   = yandex_compute_instance.vm-1.network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.tar-subnet-a.id
    address   = yandex_compute_instance.vm-2.network_interface.0.ip_address
  }

}

resource "yandex_lb_network_load_balancer" "foo" {
  name = "my-network-load-balancer"
  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_lb_target_group.foo.id}"
    healthcheck {
      name = "http"
        http_options {
          port = 80
          path = "/"
        }
    }
  }
}

data "yandex_compute_image" "my_image" {
  family = "lemp"
}

resource "yandex_compute_instance" "vm-1" {

  name = "terraform1"
  zone = var.zone1

  resources {
    cores  = 2
    memory = 1
	core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.tar-subnet-a.id
    nat       = true  # автоматически установить динамический ip
  }

  metadata = {
    ssh-keys = "sa3:${file("/home/sa/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_vpc_network" "tar-net" {
  name = "tarnet"
}

resource "yandex_vpc_subnet" "tar-subnet-a" {
  name           = "tar-subnet-a"
  v4_cidr_blocks = [var.net1]
  network_id     = "${yandex_vpc_network.tar-net.id}"
}




resource "yandex_compute_instance" "vm-2" {

  name = "terraform2"
  zone = var.zone1

  resources {
    cores  = 2
    memory = 1
	core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.tar-subnet-a.id
    nat       = true  # автоматически установить динамический ip
  }

  metadata = {
    ssh-keys = "sa3:${file("/home/sa/.ssh/id_et.pub")}"
  }
}

