#
# Workstation External IP

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

