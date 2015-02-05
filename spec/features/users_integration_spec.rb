require 'rails_helper'
require 'helpers/wait_for_ajax_helper'
include Warden::Test::Helpers

feature 'User management', js: true do 
		
	feature "adds a new user" do
		
		background do		
			visit root_path
		end		

		scenario "when modal for log in must available from modal for sign up" do
			expect(page).to have_selector("input[value='Register']")
			expect(find("#ajax-modal", visible: false).visible?).to be_falsey 
			click_button "Register"
			wait_for_ajax
			expect(find("#ajax-modal", visible: true).visible?).to be_truthy
			expect(find("#ajax-modal")).to have_link("Log in", :href => "/users/sign_in")
			click_link "Log in"
			wait_for_ajax
			expect(find("#ajax-modal")).to have_link("Sign up", :href => "/users/sign_up")
 			expect(find("#ajax-modal")).to have_link("Forgot your password?", :href => "/users/password/new")
		end	

		scenario "with a blank email" do
			click_button "Register"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => "  "
			end
			expect{
				find("#ajax-modal").click_button "Sign up"
				wait_for_ajax
				}.not_to change{User.count}
			expect(find("#ajax-modal")).to have_content("This field is required.")
		end

		scenario "with a blank password" do
			click_button "Register"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => Faker::Internet.email
			end
			expect{
				find("#ajax-modal").click_button "Sign up"
				wait_for_ajax
				}.not_to change{User.count}
			expect(find("#ajax-modal")).to have_content("This field is required.")
		end		

		scenario "with a blank password confirmation" do
			click_button "Register"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => Faker::Internet.email
				fill_in "user[password]", :with => "a"*8
			end
			expect{
				find("#ajax-modal").click_button "Sign up"
				wait_for_ajax
				}.not_to change{User.count}
			expect(find("#ajax-modal")).to have_content("This field is required.")
		end

		scenario "with a password less then 8 characters" do
			click_button "Register"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => Faker::Internet.email
				fill_in "user[password]", :with => "a"*6
			end
			expect{
				find("#ajax-modal").click_button "Sign up"
				wait_for_ajax
				}.not_to change{User.count}
			expect(find("#ajax-modal")).to have_content("Please enter at least 8 characters.")
		end		

		scenario "with a password confirmation less then 8 characters" do
			click_button "Register"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => Faker::Internet.email
				fill_in "user[password]", :with => "a"*8
				fill_in "user[password_confirmation]", :with => "a"*6
			end
			expect{
				find("#ajax-modal").click_button "Sign up"
				wait_for_ajax
				}.not_to change{User.count}
			expect(find("#ajax-modal")).to have_content("Please enter at least 8 characters.")
		end		

		scenario "when a password and password confirmation doesn't match" do
			click_button "Register"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => Faker::Internet.email
				fill_in "user[password]", :with => "a"*8
				fill_in "user[password_confirmation]", :with => "b"*8
			end
			expect{
				find("#ajax-modal").click_button "Sign up"
				wait_for_ajax
				}.not_to change{User.count}
			expect(find("#ajax-modal")).to have_content("Password confirmation doesn't match Password")
		end		

		scenario "with a valid information" do
			click_button "Register"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => Faker::Internet.email
				fill_in "user[password]", :with => "a"*8
				fill_in "user[password_confirmation]", :with => "a"*8
			end
			expect{
				find("#ajax-modal").click_button "Sign up"
				wait_for_ajax
				}.to change{User.count}.by(1)
			expect(page).to have_content("Welcome! You have signed up successfully.")
		end

	end

	feature "sign in the user" do

		background do
			visit root_path
			@user = FactoryGirl.create(:user)
		end


		scenario "when modals for sign up and password reset must available from modal for log in" do
			expect(page).to have_selector("input[value='Log In']")
			expect(find("#ajax-modal", visible: false).visible?).to be_falsey 
			click_button "Log In"
			wait_for_ajax
			expect(find("#ajax-modal", visible: true).visible?).to be_truthy
			expect(find("#ajax-modal")).to have_link("Sign up", :href => "/users/sign_up")
 			expect(find("#ajax-modal")).to have_link("Forgot your password?", :href => "/users/password/new")
			click_link "Sign up"
			wait_for_ajax
			expect(find("#ajax-modal")).to have_link("Log in", :href => "/users/sign_in")
		end	

		scenario "with a blank email" do
			click_button "Log In"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => "  "
			end
			find("#ajax-modal").click_button "Log in"
			expect(find("#ajax-modal")).to have_content("This field is required.")			
		end

		scenario "with a blank password" do
			click_button "Log In"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => @user.email
			end
			find("#ajax-modal").click_button "Log in"
			expect(find("#ajax-modal")).to have_content("This field is required.")						
		end

		scenario "with a password less then 8 characters" do
			click_button "Log In"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => @user.email
				fill_in "user[password]", :with => "a"*6
			end
			find("#ajax-modal").click_button "Log in"
			expect(find("#ajax-modal")).to have_content("Please enter at least 8 characters.")
		end		

		scenario "with a invalid email" do
			click_button "Log In"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => Faker::Internet.email
				fill_in "user[password]", :with => @user.password
			end
			find("#ajax-modal").click_button "Log in"
			wait_for_ajax
			expect(find("#ajax-modal")).to have_content("Invalid email or password.")			
		end		

		scenario "with a invalid password" do
			click_button "Log In"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => @user.email
				fill_in "user[password]", :with => "12345678"
			end
			find("#ajax-modal").click_button "Log in"
			wait_for_ajax
			expect(find("#ajax-modal")).to have_content("Invalid email or password.")			
		end		

		scenario "with a valid information" do
			click_button "Log In"
			wait_for_ajax
			within "#ajax-modal form" do
				fill_in "user[email]", :with => @user.email
				fill_in "user[password]", :with => @user.password
			end
			find("#ajax-modal").click_button "Log in"
			wait_for_ajax
			expect(page).to have_content("Signed in successfully.")
		end

	end

	feature "reset new password for user" do

		background do
			visit root_path
			@user = FactoryGirl.create(:user)
			click_button "Log In"
			wait_for_ajax
			click_link "Forgot your password?"
			wait_for_ajax
		end

		scenario "with a blank email" do
			within "#ajax-modal form" do
				fill_in "user[email]", :with => "  "
			end
			click_button "Send me reset password instructions"
			expect(find("#ajax-modal")).to have_content("This field is required.")			
		end

		scenario "with not registered email" do
			within "#ajax-modal form" do
				fill_in "user[email]", :with => Faker::Internet.email
			end
			click_button "Send me reset password instructions"
			wait_for_ajax
			expect(find("#ajax-modal")).to have_content("Email not found")			
		end

		scenario "with a valid information" do
			within "#ajax-modal form" do
				fill_in "user[email]", :with => @user.email
			end
			click_button "Send me reset password instructions"
			wait_for_ajax
			expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")			
		end


	end

	feature "edit profile user" do
		
		background do
			@user = FactoryGirl.create(:user)
			login_as @user, :scope => :user
			visit root_path
			click_button "#{@user.email}"
			click_link "Settings"
			wait_for_ajax
		end

		scenario "with blank email" do		
			within "#ajax-modal form" do
				fill_in "user[email]", :with => "  "
				fill_in "user[current_password]", :with => @user.password 
			end
			find("#ajax-modal").click_button "Update"
			expect(find("#ajax-modal")).to have_content("This field is required.")
		end

		scenario "with blank current password" do
			within "#ajax-modal form" do
				fill_in "user[current_password]", :with => " "
			end
			find("#ajax-modal").click_button "Update"
			expect(find("#ajax-modal")).to have_content("This field is required.")		
		end

		scenario "with invalid current password" do
			within "#ajax-modal form" do
				fill_in "user[current_password]", :with => "a"*8
			end
			find("#ajax-modal").click_button "Update"
			expect(find("#ajax-modal")).to have_content("Current password is invalid")			
		end

		scenario "with current password less than 8 characters" do
			within "#ajax-modal form" do
				fill_in "user[current_password]", :with => "a"*6 
			end
			find("#ajax-modal").click_button "Update"
			expect(find("#ajax-modal")).to have_content("Please enter at least 8 characters.")					
		end

		scenario "with password and password confirmation less then 8 characters" do
			within "#ajax-modal form" do
				fill_in "user[password]", 							:with => "a"*6
				fill_in "user[password_confirmation]",  :with => "a"*6				
				fill_in "user[current_password]", 			:with => @user.password 
			end
			find("#ajax-modal").click_button "Update"
			expect(find("#ajax-modal")).to have_content("Please enter at least 8 characters.")		
		end

		scenario "when password and password confirmation doesn't match" do
			within "#ajax-modal form" do
				fill_in "user_password", 							:with => "a"*8
				fill_in "user_password_confirmation",  :with => "b"*8				
				fill_in "user_current_password", 			:with => @user.password 
			end
			find("#ajax-modal").click_button "Update"
			expect(find("#ajax-modal")).to have_content("Password confirmation doesn't match Password")		
		end

		scenario "with valid information" do
			within "#ajax-modal form" do
				fill_in "user[password]", 							:with => "a"*8
				fill_in "user[password_confirmation]",  :with => "a"*8	
				fill_in "user[current_password]", :with => @user.password 
			end
			find("#ajax-modal").click_button "Update"
			expect(page).to have_content("Your account has been updated successfully.")		
		end

	end

	feature "sign out the user" do
		
		background do
			@user = FactoryGirl.create(:user)
			login_as @user, :scope => :user
			visit root_path
			click_button "#{@user.email}"
			wait_for_ajax
		end

		scenario "with flash message" do
			click_link "Log out"
			expect(page).not_to have_button("#{@user.email}")
			expect(page).to have_button("Log In")
			expect(page).to have_content("Signed out successfully.")
		end

	end

end