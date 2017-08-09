class Source < ApplicationRecord
	has_many :items
	has_many :sessions
end
