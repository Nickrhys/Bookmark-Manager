# bcrypt will gemerate the password hash
require 'bcrypt'
class User

	include DataMapper::Resource 

	property :id, Serial
	property :email, String

	property :password_digest, Text

	attr_reader :password
	attr_accessor :password_confirmation

	validates_confirmation_of :password, message: "There's already a page of that title in this section"
	validates_uniqueness_of :email, message: "Get a new email"

	def password=(password)	
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

end