class Session < ApplicationRecord
	belongs_to :sources
	has_many :task
end
