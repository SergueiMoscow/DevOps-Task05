# Vagrantfile
Vagrant.configure("2") do |config|
    (1..3).each do |i|
      config.vm.define "machine-#{i}" do |machine|
        machine.vm.box = "yandex-cloud"
        machine.vm.provider :yandex do |yc|
          yc.image_id = "fd8tvc3529h2cpjvpkr5"
          yc.zone = "ru-central1-a"
          yc.subnet_id = "e9bsl2o51eg78tjo00vm"
          yc.preemptible = true
          yc.cores = 2
          yc.memory = 2
          yc.core_fraction = 20
        end
      end
    end
  end