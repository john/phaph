# To instantiate a new server:
# ruby lib/fog/init.rb

# Then deploy:
# cap production deploy

# Then, currently, you need to ssh into the instance, and start passenger:
# rvmsudo passenger start --daemonize --port 80 --user ubuntu --user=ubuntu

# TODO:
# - Script creation/attachment of an EBS volume
# - Script for setting up sidekiq
# - Move Elasticsearch stuff in to script for its own instance
#    - or not? Maybe that should start off on web instance, though it should then have it's own ebs i think

require 'rubygems'
require 'fog'

rails_root = '/Users/john/repos/phaph'
# API = YAML::load_file("#{Rails.root}/config/api_keys.yml")[Rails.env]
API = YAML::load_file("#{rails_root}/config/api_keys.yml")['development']

def cmd(server, command)
  puts command.to_s
  result = server.ssh(command)[0]

  if result.status != 0
    puts result.display_stderr
  end
end

region = 'us-west-2'
# image_id = 'ami-676e2b57'
image_id = 'ami-37501207'
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
cmd(server, "sudo apt-get -y -f install webhttrack build-essential openssl libreadline-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt1-dev autoconf libc6-dev libncurses5-dev automake libtool bison libcurl4-openssl-dev libmysqlclient-dev git unzip libreoffice unoconv libfreetype6-dev fontconfig libfontconfig1 libjpeg-turbo8 libxrender1 xorg libpng12-dev libjpeg-dev libmagic-dev" )

# puts '2nd batch...'
# cmd(server, "sudo apt-get -y libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison libcurl-dev libcurl3-dev libcurl3-gnutls libcurl4-openssl-dev")
#
# puts '3rd batch...'
# cmd(server, "sudo apt-get -y install libmysqlclient-dev git unzip" )
#
# puts '4th batch...'
# cmd(server, "sudo apt-get -y install libreoffice unoconv" )

server.wait_for { ready? }
puts '---'
puts 'installing wkhtmltopdf...'
# cmd(server, "sudo apt-get -y install libfreetype6-dev fontconfig libfontconfig1 libjpeg-turbo8 libxrender1 xorg libpng12-dev libjpeg-dev libmagic-dev")
cmd(server, "sudo wget http://sourceforge.net/projects/wkhtmltopdf/files/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb/download -O /usr/bin/wkhtmltopdf")
server.wait_for { ready? }
cmd(server, "sudo dpkg -i /usr/bin/wkhtmltopdf")


#
##############################################################


server.wait_for { ready? }
puts '---'
puts 'scping install_rvm.sh...'

server.scp("#{rails_root}/lib/fog/install_rvm.sh", '/home/ubuntu/', :recursive => true)

server.wait_for { ready? }
puts '---'
puts "installing RVM, Ruby, and Rubygems..."
# http://stackoverflow.com/questions/23493984/how-to-install-ruby-2-and-ruby-gems-on-ubuntu-box-with-ansible

cmd(server, "/home/ubuntu/install_rvm.sh")

# server.wait_for { ready? }
# puts '---'
# puts 'wgetting and installing puppet...'
#
# cmd(server, "wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb")
# cmd(server, "sudo dpkg -i puppetlabs-release-trusty.deb")
# cmd(server, "sudo apt-get -y install puppet")



server.wait_for { ready? }
puts '---'
puts 'Add phusion keys...'
cmd(server, "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7")
cmd(server, "sudo apt-get install apt-transport-https ca-certificates")

server.wait_for { ready? }
puts '---'
puts 'Add phusion repo to sources...'
cmd(server, "sudo touch /etc/apt/sources.list.d/passenger.list")
server.wait_for { ready? }

cmd(server, "sudo sh -c 'echo \"deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main\" >> /etc/apt/sources.list.d/passenger.list'")

# Secure passenger.list and update your APT cache:
server.wait_for { ready? }
puts '---'
puts 'update permissions...'
cmd(server, "sudo chown root: /etc/apt/sources.list.d/passenger.list")
cmd(server, "sudo chmod 600 /etc/apt/sources.list.d/passenger.list")

server.wait_for { ready? }
puts '---'
puts 'Run apt-get update...'
cmd(server, "sudo apt-get update")

server.wait_for { ready? }
puts '---'
puts 'installing passenger...'
cmd(server, "sudo apt-get -y install passenger")

server.wait_for { ready? }
puts '---'
puts 'wgetting elasticsearch...'
cmd(server, "wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.0.zip")

server.wait_for { ready? }
puts '---'
puts 'unzipping elasticsearch...'
cmd(server, "unzip elasticsearch-1.4.0.zip")

server.wait_for { ready? }
puts '---'
puts 'install es mappers...'
cmd(server, "cd elasticsearch-1.4.0; bin/plugin -install elasticsearch/elasticsearch-mapper-attachments/2.4.1")

# install es-mappers

# start es

# server.wait_for { ready? }
# puts '---'
# puts 'installing daemon_controller gem...'
# cmd(server, "sudo gem install daemon_controller")

# # then, from the rails root...
# # sudo passenger start -e production -p 80

# https://www.phusionpassenger.com/documentation/Users%20guide%20Standalone.html#starting_at_system_boot
# passenger start --daemonize --port 80 --user ubuntu
# which then says to run:
# rvmsudo passenger start --daemonize --port 80 --user ubuntu --user=ubuntu


# server.wait_for { ready? }
# puts '---'
# puts 'starting passenger...'
# cmd(server, "rvmsudo passenger start -p 80 --user=ubuntu")

puts "---"
puts "instance id: #{server.id}"
puts "connection string: ssh -i .certs/id_rsa ubuntu@#{server.dns_name}"