class Product < ActiveRecord::Base
	#if i want to specify another table name. 
	#self.table_name = "another name"  

	CATEGORY_TYPES = ["Books", "Laptops", "Mobile Phones", "Computer Games"]

	#not sexy validation
	# validates_presence_of 	:name, :sku, :category
	# validates_length_of 		:name, within: 1..35
	# validates_length_of 		:sku, within: 1..35
	# validates_uniqueness_of 	:sku
	# validates_length_of 		:category, within: 1..35
	# validates_inclusion_of 	:category, in: CATEGORY_TYPES, message: "Category must be one of the 
	# 	following: #{CATEGORY_TYPES.join(', ')}."

	# sexy validation
	validates :name, 	 :presence 	 => true,
					 	 :length 	 => {within: 1..35}
	validates :sku,  	 :uniqueness => true,
					 	 :length 	 => {within: 1..35}
	validates :category, :length 	 => {within: 1..35},
						 :inclusion  => {in:  CATEGORY_TYPES, message: "Category must be one of the 
						 		following: #{CATEGORY_TYPES.join(', ')}."}
	# can also add:
	# :numericality => boolean
	# :format => options_hash
	# :exclusion => {:in => array_of_range}
	# :acceptence => boolean
	# :confirmation => boolean

	# custom validation
	# syntax:
	# validate :username_is_allowed
	# def username_is_allowed
	# 	if FORBIDDEN_USERNAMES.include?(username)
	# 		errors.add(:username (#the attr to add the error on), "custom error message to add")
	# 	end
	# end

	# another custom validation example
	# validate :no_new_users_on_saturday, :on => :create  #the :on is on what the validate will be triggered, :create- the method on the controller 
	# def no_new_users_o n_saturday
	# 	if Time.now.wday == 6
	# 		error[:base] << "some error message"
	# 	end
	# end

	scope :books, lambda{ where(category: "Books") }
	scope :mobile_phones, lambda{ where(category: "Mobile Phones") }
	scope :category, lambda{|cat| 
		where(['category LIKE ?', "%#{cat}%"])
	}
	scope :sorted, lambda{ order("name ASC") }
	scope :id_sorted, lambda{ order("id ASC") }
	scope :sku_sorted, lambda{ order("sku ASC") }
	scope :newest_first, lambda{ order("created_at ASC") }
	scope :search, lambda{|name|
		where(['name LIKE ?', "%#{name}%"])
	}
	scope :id_search, lambda{|number|
		where(id: number)
	}
	scope :sku_search, lambda{|number|
		where(sku: number)
	}


	# scope :num_search, lambda{|number|
	# 	where(id: "number"),
	# 	where(sku: "number"),
	# 	where(['name LIKE ?', "%#{number}%"])
	# 	where(['category LIKE ?', "%#{number}%"])
	# }
end
