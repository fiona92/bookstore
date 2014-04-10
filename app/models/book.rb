class Book < ActiveRecord::Base

	has_many :lineitems
	has_many :orders, :through => :lineitems
	has_many :comments, :dependent => :destroy

	mount_uploader :image, ImageUploader

	def self.cheaper_than(price)
		where (['price < ?', price])
	end

end