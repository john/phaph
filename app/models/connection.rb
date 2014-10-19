class Connections < ActiveRecord::Base
	serialize :followers, JSON
	serialize :following, JSON
end
