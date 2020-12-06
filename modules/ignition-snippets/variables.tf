
variable "networks" {
  type = map(map(map(map(string))))
  description = <<EOD
Map of network configurations. Keys are for lookup in later typhoon snippets configuration, each key conforms to a host.
Values are maps of ipv4/ipv6 configurations with key/value pairs that conform to NetworkManager configuration INI. See
https://developer.gnome.org/NetworkManager/stable/nm-settings.html for a complete reference for a reference.

Example for eth0 static IPv4 configuration in the host named node1:

networks= {
  node1 = {
    ipv4 = {
      "method" = "manual"
      "address1" = "10.10.0.10/16,10.10.0.1"
      "dns" = "10.10.0.1;"
    }
  }
}

The values will be substituted in net-config.yaml and for each network interface there will be a config INI file placed
in /etc/NetworkManager/system-connections/<nic>.nmconnection. This serves the purpose of network configuration (see
https://docs.fedoraproject.org/en-US/fedora-coreos/sysconfig-network-configuration/ for more info)
EOD
}

variable "root_partition_size_gib" {
  type = map(number)
  description = <<EOD
Map of sizes of the root partition in provisioned CoreOS images. Keys are for lookup in later (typhoon) snippets
configuration, each key conforms to a host. If set to a value > 0, the install disk will be partitioned and the root
partition will be the given size. The remaining space will form a second partition which is mounted at /var/mnt/data.

Example for a 24 GB root partition in the host named node1:

root_partition_size_gib = {
  node1 = 24
}

This is useful if you want to have persistent data on the remaining space while still be able to recreate the hosts root
partition by reprovisioning via ignition. To do that, only the partition table must be deleted, e.g. on /dev/sda with

sudo dd if=/dev/zero of=/dev/sda bs=512 count=1

BE CAREFUL with the above command, it will render /dev/sda unbootable! Also, DON'T COPY/PASTE IT BLINDLY, without making
sure it is really what you want and the disk is correct. THE AUTHOR IS NOT RESPONSIBLE FOR ANY DAMAGE that you might do
to your setup.

EOD
}