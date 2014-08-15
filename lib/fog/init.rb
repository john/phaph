# to run:
# ruby lib/fog/init.rb

require 'rubygems'
require 'fog'

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

# # entelo account:
# aws_access_key_id = 'AKIAIXNUOB552ORTAHPA'
# aws_secret_access_key = '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'
# private_key_path = "#{ENV['HOME']}/.ssh/entelo/id_rsa"
# public_key_path = "#{ENV['HOME']}/.ssh/entelo/id_rsa.pub"

# fnnny account:
aws_access_key_id = 'AKIAIHXOIL4LVGJVMXFA'
aws_secret_access_key = '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'
private_key_path = '/Users/john/.ssh/id_rsa'
public_key_path = '/Users/john/.ssh/id_rsa.pub'

# Q: Security group? VPC

# puts "up the default timeout to 20 minutes..."
# Fog.timeout = 1200

puts "creating connection..."
connection = Fog::Compute.new(
  :provider => 'AWS',
  :region => region,
  :aws_access_key_id => aws_access_key_id,
  :aws_secret_access_key => aws_secret_access_key,
)

puts '---'

puts "bootstrappng server..."
server = connection.servers.bootstrap(  :private_key_path => private_key_path,
                                        :public_key_path => public_key_path,
                                        :username => 'ubuntu',
                                        :image_id => image_id,
                                        :flavor_id =>  flavor_id,
                                        :groups => ['default'] )
                                        # :groups => ['linkedout-fetcher']
                                        # :groups => 'default'
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
puts 'apt-getting libffi6 and friends...'

cmd(server, "sudo apt-get -y install libffi6 libyaml-0-2 libssl0.9.8")

server.wait_for { ready? }
puts '---'
puts 'scping install_rvm.sh...'

server.scp("/Users/john/projects/apps/phaph/lib/fog/install_rvm.sh", '/home/ubuntu/', :recursive => true)

server.wait_for { ready? }
puts '---'
puts "installing RVM, Ruby, and Rubygems..."
install_rvm.sh
# http://stackoverflow.com/questions/23493984/how-to-install-ruby-2-and-ruby-gems-on-ubuntu-box-with-ansible

cmd(server, "/home/ubuntu/install_rvm.sh")

server.wait_for { ready? }
puts '---'
puts 'wgetting and installing puppet...'

cmd(server, "wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb")
cmd(server, "sudo dpkg -i puppetlabs-release-trusty.deb")
cmd(server, "sudo apt-get -y install puppet")

server.wait_for { ready? }
puts '---'
puts "Sending puppet manifests ..."

system("rm -f /tmp/puppet.tar && tar -cf /tmp/puppet.tar #{@entelo_root}/lib/puppet")
server.scp("/tmp/puppet.tar", '/home/ubuntu/', :recursive => true)

server.wait_for { ready? }
puts '---'
puts "Running puppet ..."
cmd(server, "tar xf /home/ubuntu/puppet.tar")
cmd(server, "sudo env PATH=$PATH puppet apply --modulepath=lib/puppet/modules lib/puppet/manifests/#{@options[:puppet]} --verbose")


puts "---"
puts "instance id: #{server.id}"
puts "connection string: ssh -i .certs/id_rsa ubuntu@#{server.dns_name}"