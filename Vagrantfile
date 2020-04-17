Vagrant.configure("2") do |config|
  config.vm.box =  "hashicorp/bionic64"
  config.vm.provision "shell", inline: "apt update && apt install -y jq"

  config.vm.define "controller0" do |c0|
    c0.vm.hostname = "controller0"
    c0.vm.network "private_network", ip: "172.20.120.10"
    c0.vm.provision "shell", inline: <<-EOF
      cd /vagrant

      jq --from-file extract_controller.jq -r < terraform.tfstate > ~vagrant/ca.pem \
        --arg class self_signed_cert --arg name ca --arg pem cert
      jq --from-file extract_controller.jq -r < terraform.tfstate > ~vagrant/ca-key.pem \
        --arg class private_key --arg name ca --arg pem private_key

      jq --from-file extract_controller.jq -r < terraform.tfstate > ~vagrant/kubernetes.pem \
        --arg class locally_signed_cert --arg name api --arg pem cert
      jq --from-file extract_controller.jq -r < terraform.tfstate > ~vagrant/kubernetes-key.pem \
        --arg class private_key --arg name api --arg pem private_key

      jq --from-file extract_controller.jq -r < terraform.tfstate > ~vagrant/service-account.pem \
        --arg class locally_signed_cert --arg name service_account --arg pem cert
      jq --from-file extract_controller.jq -r < terraform.tfstate > ~vagrant/service-account-key.pem \
        --arg class private_key --arg name service_account --arg pem private_key

      chown vagrant:vagrant ~vagrant/*.pem
    EOF
  end
  # config.vm.define "controller1" do |c1|
  #   c1.vm.network "private_network", ip: "172.20.20.11"
  # end

  config.vm.define "worker0" do |w0|
    w0.vm.hostname = "worker0"
    w0.vm.network "private_network", ip: "172.20.120.20"
    w0.vm.provision "shell", inline: <<-EOF
      cd /vagrant
      jq --from-file extract.jq -r < terraform.tfstate > ~vagrant/worker0.pem \
        --arg key worker0 --arg class locally_signed_cert --arg pem cert
      jq --from-file extract.jq -r < terraform.tfstate > ~vagrant/worker0-key.pem \
        --arg key worker0 --arg class private_key --arg pem private_key
      chown vagrant:vagrant ~vagrant/worker0{,-key}.pem
    EOF
  end
  # config.vm.define "worker1" do |w1|
  #   w1.vm.hostname = "worker1"
  #   w1.vm.network "private_network", ip: "172.20.120.21"
  # end
  # config.vm.define "worker2" do |w2|
  #   w2.vm.network "private_network", ip: "172.20.20.22"
  # end
end
