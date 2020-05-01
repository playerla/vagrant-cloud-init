# Vagrant file to test template building with minimum cloud-init support

# HEREDOC script
$script = <<-'SCRIPT'
apt install -y cloud-init
mkdir -p /var/lib/cloud/seed/nocloud-net
cat << EOF >> /etc/cloud/cloud.cfg
datasource_list: [ NoCloud ]
EOF
echo '#cloud-config' > /var/lib/cloud/seed/nocloud-net/meta-data
cat << EOF > /var/lib/cloud/seed/nocloud-net/user-data
#cloud-config
hostname: test-hostname
users:
- name: kadm
  sudo: ALL=(ALL) NOPASSWD:ALL
  password: password
- name: root
  ssh-authorized-keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJA+ieWRN4KIWrt8HqelXMHgpxhhqb0jVrUS/qpcyp+biXbumx+u4/AX5j0FyalcvRg7d1wBQKdryPxb06c0vEWl00kFR1bfJ3Dctttcz+VJBuXGOmyrfcLXo2SKwtDnfhQ988Bj+87yhc6zqp0CDpQk53ThbvUt47rEZ/JHsuOaulc0FFUjZX/+P5vkIVKowt/RQWWgX6zsuoeKXXyZ/wWrEXuE+rhxGeRAjS8gL8sX53aL/riIPL/DcN76THvBzv2Wir5e56cefCIINrJYto3vDSTa69f+H1vy0QTEOJ671GQ4H6sCwoluHB4KnNy+zLdTchWIWsXKAQmMmmsPnx deploy
runcmd:
  - echo 'no user-data' > /opt/user-data
EOF
reboot
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/debian10"
    config.vm.provision "shell" do |shell|
    shell.inline = $script
  end
end
