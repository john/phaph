# Create RDS instance:
# MySQL -> SingleAZ (in QA) -> 5.6.21, t2.small, root/DK ->
# Publicly Accessible: yes -> AZ: us-west-2a
# VPC Security Group: default, subnet default
# Database & instance name: phaph_production

# Instantiate a new server:
# ruby lib/fog/init.rb

# Change inbound permissions (?)

# Take RDS instance name and add to database.yml
# Take the public DNS of the new instance and add it to /config/deploy/production.rb

# Deploy:
# you may have to clear out junk in ~/.ssh/known_hosts
# cap production deploy
# cap production deploy:restart (fails now actually, because when it runs in a 
# non-login shell it can't find the correct gem bundles)

# ssh into box and fix this:
# http://stackoverflow.com/questions/23726110/missing-production-secret-key-base-in-rails
# - bundle exec rake secret
# edit secrets.yml, though real fix is in link above
# maybe not necessary?


# Create db and migrate. See if there's a cap task for this later, but for now, on the instance
# You need to first drop the db, because the one created when you spun up the RDS instance has the wrong collation.
# cd /home/ubuntu/phaph/current; bundle exec rake db:create RAILS_ENV=production
# cd /home/ubuntu/phaph/current; bundle exec rake db:create RAILS_ENV=production
# cd /home/ubuntu/phaph/current; bundle exec rake db:migrate RAILS_ENV=production

# script this too, easily, from fog init.rb, but for now you need to create the documents directory:
# mkdir /home/ubuntu/phaph/current/public/documents

# or maybe not--looks like it can't create directories?
# actually see document.rb 222: more like it can't wite to S3. open a port?

# Script all this later, but now ssh into the instance and start passenger:
# rvmsudo passenger start --daemonize --port 80 --user ubuntu --user=ubuntu --environment production
#
# To stop passenger:
# rvmsudo passenger stop --port 80

# Start Elasticsearch daemon
# cd ~/elasticsearch-1.4.1/bin; sudo ./elasticsearch -d
# (you can also pass through java params: http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup.html)

# this: https://gist.github.com/pvdb/868002
# says this: bundle exec passenger start --socket /tmp/passenger.socket --daemonize --port 80 --environment production

# Start Sidekiq:
# cd ~/phaph/current; bundle exec sidekiq -d -e production -L log/sidekiq.log

# Start Rails console: 
# cd ~/phaph/current; bundle exec rails c

# create index:
# Document.__elasticsearch__.create_index! force: true

# https://gist.github.com/rodleviton/74e22e952bd6e7e5bee1
# wget http://mirrors-usa.go-parts.com/mirrors/ImageMagick/ImageMagick-6.9.0-0.tar.gz
# tar xzvf ImageMagick-6.9.0-0.tar.gz
# cd ImageMagick-6.9.0-0/
# ./configure --prefix=/opt/imagemagick-6.9 && make


# TODO:
# - Script creation/attachment of an EBS volume
# - Script for setting up sidekiq
#   - Use elasticache, see if sidekiq can run on same instance as passenger
# - Move Elasticsearch stuff in to script for its own instance
#    - or not? Maybe that should start off on web instance, though it should then have it's own ebs i think

# some vpc info about creating a public ip address:
# http://serverfault.com/questions/623487/ssh-timeout-issue-connecting-to-an-ec2-instance-on-os-x


require 'rubygems'
require 'fog'

rails_root = '/Users/john/repos/phaph'
# API = YAML::load_file("#{Rails.root}/config/api_keys.yml")[Rails.env]
API = YAML::load_file("#{rails_root}/config/api_keys.yml")['development']

def cmd(server, command)
  puts command.to_s
  result = server.ssh(command)[0]

  if result.status != 0
    # puts result.display_stderr
    puts result.display_stdout
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


# https://github.com/fog/fog/issues/713
# connection.servers.create(
#       :vpc_id             => config[:vpc_id],
#       :subnet_id          => config[:subnet_id],
#       :availability_zone  => config[:availability_zone],
#       :security_group_ids => config[:security_group_ids],
#       :tags               => config[:tags],
#       :flavor_id          => config[:flavor_id],
#       :ebs_optimized      => config[:ebs_optimized],
#       :image_id           => config[:image_id],
#       :key_name           => config[:aws_ssh_key_id],
#     )
    
# some parameer examples:
# https://github.com/fog/fog/issues/713
puts "bootstrappng server..."
server = connection.servers.bootstrap(  :private_key_path => private_key_path,
                                        :public_key_path => public_key_path,
                                        :availability_zone => 'us-west-2a',
                                        :username => 'ubuntu',
                                        :image_id => image_id,
                                        :flavor_id =>  flavor_id,
                                        :subnet_id => 'subnet-165e9361',
                                        # :subnet_ids => ['subnet-165e9361','subnet-e8ec01b1','subnet-af03acca'], # <-- for vpc. make sure it allows ssh from your ip
                                        :groups => ['web'] # <-- for vpc
                                      )

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
cmd(server, "sudo apt-get -y -f install mysql-client-core-5.6 webhttrack httrack phantomjs imagemagick build-essential openssl libreadline-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt1-dev autoconf libc6-dev libncurses5-dev automake libtool bison libcurl4-openssl-dev libmysqlclient-dev git unzip libreoffice unoconv libfreetype6-dev fontconfig libfontconfig1 libjpeg-turbo8 libxrender1 xorg libpng12-dev libjpeg-dev libmagic-dev" )

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
cmd(server, "wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.1.zip")

server.wait_for { ready? }
puts '---'
puts 'unzipping elasticsearch...'
cmd(server, "unzip elasticsearch-1.4.1.zip")

server.wait_for { ready? }
puts '---'
puts 'install es mappers...'
cmd(server, "cd elasticsearch-1.4.1; bin/plugin -install elasticsearch/elasticsearch-mapper-attachments/2.4.1")

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