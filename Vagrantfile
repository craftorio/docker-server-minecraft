Vagrant.configure(2) do |config|
  HOSTNAME="minecraft.local"

  config.vm.hostname = HOSTNAME
  config.vm.network "private_network", type: "dhcp"

  # Hostnamager configuration
  config.hostmanager.enabled           = true
  config.hostmanager.manage_host       = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline   = false
  config.vbguest.auto_update           = false

  # Dinamic ip resolver for vagrant hostmanager plugin
  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
    begin
      buffer = '';
        vm.communicate.execute("/sbin/ifconfig") do |type, data|
        buffer += data if type == :stdout
      end

      ips = []
        ifconfigIPs = buffer.scan(/inet addr:(\d+\.\d+\.\d+\.\d+)/)
        ifconfigIPs[0..ifconfigIPs.size].each do |ip|
          ip = ip.first

          next if /^(10|127)\.\d+\.\d+\.\d+$/.match ip

          if Vagrant::Util::Platform.windows?
            next unless system "ping #{ip} -n 1 -w 100>nul 2>&1"
          else
            next unless system "ping -c1 -t1 #{ip} > /dev/null"
          end

          ips.push(ip) unless ips.include? ip
        end
        ips.first
      rescue StandardError => exc
        return
      end
  end

  # Avoid possible request "vagrant@127.0.0.1's password:" when "up" and "ssh"
  config.ssh.password = "vagrant"

  # Env
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Virtualbox provider
  config.vm.provider "virtualbox" do |v, override|
    override.vm.box = "williamyeh/ubuntu-trusty64-docker"
    v.memory = 2048
    v.cpus = 2
    
    #override.vm.provision :shell, :inline => "grep -q 'swapfile' /etc/fstab || fallocate -l 2048M /swapfile &&  chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && echo '/swapfile none swap defaults 0 0' >> /etc/fstab"
    override.vm.provision :shell, :inline => "apt-get update && apt-get -y upgrade && apt-get -y install vim mc"
    override.vm.provision :shell, :inline => "ln -s /vagrant/mc-docker-run /usr/local/bin/mc-docker-run && chmod +x /usr/local/bin/mc-docker-run"
    override.vm.provision :shell, :inline => "adduser --disabled-password --gecos '' minecraft && usermod -G sudo,docker minecraft"
  end
end
