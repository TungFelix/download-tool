class Item < ApplicationRecord
	belongs_to :source
	has_many :task
end
