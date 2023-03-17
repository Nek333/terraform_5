terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

 backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "forstate"
    region     = "ru-central1"
    key        = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {

  folder_id = "b1g4q5tlm30vjh648j62"
  zone = "ru-central1-a"

}
