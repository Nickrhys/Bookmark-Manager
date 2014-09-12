require_relative 'helpers/session'
require 'spec_helper'

feature 'password recovery' do 

	include SessionHelpers 

	before(:each) do
		user = User.create(:email=> "test@test.com",
					:password => "test",
					:password_confirmation => "test")
	end

	scenario 'when requesting a password reset token, user sees a message' do
		# user.password_token
		visit '/users/reset_password'
		fill_in 'email', with: "test@test.com"
		click_button 'Reset password request'

		expect(page).to have_content("We have sent you your password reset token. Please check your email")
	end

	scenario 'when producing a password reset token, a token is generated in the DB' do
		visit '/users/reset_password'
		fill_in 'email', with: "test@test.com"
		click_button 'Reset password request'
		
		# request_reset_password
		# user.password_token
		user = User.first(:email => "test@test.com")
		expect(user.password_token.class).to be(String)
		expect(user.password_token.length).to be(64)
	end
end
