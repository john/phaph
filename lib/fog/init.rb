# to run:
# ruby lib/fog/init.rb

require 'rubygems'
require 'fog'

API = YAML::load_file("#{Rails.root}/config/api_keys.yml")[Rails.env]

def cmd(server, command)
  puts command.to_s
  result = server.ssh(command)[0]

  if result.status != 0
    puts result.display_stderr
  end
end

region = 'us-west-2'
image_id = 'ami-676e2b57'
flavor_id = 'm3.large'

# fnnny account:

private_key_path = '/Users/john/.ssh/id_rsa'
public_key_path = '/Users/john/.ssh/id_rsa.pub'

# Q: Security group? VPC

# puts "up the default timeout to 20 minutes..."
# Fog.timeout = 1200

puts "creating connection..."
connection = Fog::Compute.new(
  :provider => 'AWS',
  :region => region,
  :aws_access_key_id => API['aws']['key'],
  :aws_secret_access_key => API['aws']['secret'],
)

puts '---'

puts "bootstrappng server..."
server = connection.servers.bootstrap(  :private_key_path => private_key_path,
                                        :public_key_path => public_key_path,
                                        :username => 'ubuntu',
                                        :image_id => image_id,
                                        :flavor_id =>  flavor_id,
                                        :groups => ['default'] )

##############################################################
#
# I think a lot of this shit can and should be done with Puppet

# In puppet manifest:
# package { 'build-essential':
#   ensure      => installed,
# }
# 
# package { 'webhttrack':
#   ensure      => installed,
# }

server.wait_for { ready? }
puts '---'
puts 'apt-get update...'

cmd(server, "sudo apt-get update")

server.wait_for { ready? }
puts '---'
puts 'apt-get upgrade...'

cmd(server, "sudo apt-get -y upgrade")

server.wait_for { ready? }
puts '---'
puts 'apt-getting openssl and friends...'

cmd(server, "sudo apt-get -y install webhttrack build-essential openssl libreadline-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison libcurl4-openssl-dev")



cmd(server, "sudo apt-get -y install libre-office unoconv" )

server.wait_for { ready? }
puts '---'
puts 'installing wkhtmltopdf...'
cmd(server, "sudo apt-get -y install libfreetype6-dev fontconfig xorg libpng-dev libjpeg-dev libmagic")
cmd(server, "sudo wget http://sourceforge.net/projects/wkhtmltopdf/files/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb/download -O /usr/bin/wkhtmltopdf")
server.wait_for { ready? }
cmd(server, "sudo dpkg -i /usr/bin/wkhtmltopdf")


#
##############################################################


server.wait_for { ready? }
puts '---'
puts 'scping install_rvm.sh...'

server.scp("/Users/john/projects/apps/phaph/lib/fog/install_rvm.sh", '/home/ubuntu/', :recursive => true)

server.wait_for { ready? }
puts '---'
puts "installing RVM, Ruby, and Rubygems..."
# http://stackoverflow.com/questions/23493984/how-to-install-ruby-2-and-ruby-gems-on-ubuntu-box-with-ansible

cmd(server, "/home/ubuntu/install_rvm.sh")

server.wait_for { ready? }
puts '---'
puts 'wgetting and installing puppet...'

cmd(server, "wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb")
cmd(server, "sudo dpkg -i puppetlabs-release-trusty.deb")
cmd(server, "sudo apt-get -y install puppet")

# server.wait_for { ready? }
# puts '---'
# puts "Sending puppet manifests ..."
#
# system("rm -f /tmp/puppet.tar && tar -cf /tmp/puppet.tar #{@entelo_root}/lib/puppet")
# server.scp("/tmp/puppet.tar", '/home/ubuntu/', :recursive => true)
#
# server.wait_for { ready? }
# puts '---'
# puts "Running puppet ..."
# cmd(server, "tar xf /home/ubuntu/puppet.tar")
# cmd(server, "sudo env PATH=$PATH puppet apply --modulepath=lib/puppet/modules lib/puppet/manifests/#{@options[:puppet]} --verbose")


puts "---"
puts "instance id: #{server.id}"
puts "connection string: ssh -i .certs/id_rsa ubuntu@#{server.dns_name}"