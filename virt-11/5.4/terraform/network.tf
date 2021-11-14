# Network
resource "yandex_vpc_network" "default" {
  name = "network01"
}

resource "yandex_vpc_subnet" "default" {
  name = "sub-network01"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.101.0/24"]
}