class Api::V1::UsersController < Api::V1::ApplicationController

	before_action :authenticate_api_user , except: [:sign_in,:sign_up]

	def sign_up
		begin
			user = User.find_by(email: params[:user][:email])
			if !user.present?
				user = User.create!(user_params)
				payload = {email: user.email, id: user.id}
				token = encode(payload, 24.hours.from_now )
				hsh = {}
				hsh[:token] = token
				hsh[:user] = user
				render :json => hsh.to_json, status: 200
			else
				raise "Email already present. Please try with new one."
			end
		rescue Exception => e
			error_handle_bad_request(e)
		end
	end

	def sign_in
		begin
			user = User.find_by(email: params[:user][:email])
			if user.present?
				if user.valid_password?(params[:user][:password])
					user.update!(user_params)
					payload = {email: user.email, id: user.id}
					token = encode(payload, 24.hours.from_now )
					hsh = {}
					hsh[:token] = token
					hsh[:user] = user
					render :json => hsh.to_json, status: 200
				else
					raise "Email/Password is incorrect."
				end
			else
				raise "Email/Password is incorrect."
			end			
		rescue Exception => e
			error_handle_bad_request(e)
		end
	end


	def create_goal
		begin
			@current_api_user.goals.create!(goal_params)
			hsh = {}
			hsh[:message] = "Goal created successfully"
			render :json => hsh.to_json, status: 200
		rescue Exception => e
			error_handle_bad_request(e)
		end
	end

	def getandupdateGoal
		begin
			goal = Goal.find_by(id: params[:id])
			hsh = {}
			if request.method == "PUT"
				goal.update!(goal_params)
				hsh[:message] = "Goal updated successfully"
			end
			hsh[:goal] = goal.as_json(methods: [:user])
			render :json => hsh.to_json, status: 200
		rescue Exception => e
			error_handle_bad_request(e)
		end
	end

	def getUserGoals
		begin
			goals = @current_api_user.goals
			hsh = {}
			hsh[:my_goals] = goals.as_json
			render :json => hsh.to_json, status: 200
		rescue Exception => e
			error_handle_bad_request(e)
		end
	end

	private

	def user_params
		params.require(:user).permit(:email, :password, :user_name)
	end

	def goal_params
		params.require(:goal).permit(:description, :amount, :goal_target_date)
	end

	def encode(payload, exp = 24.hours.from_now)
	     payload[:exp] = exp.to_i

	     hmac_secret = 'my$ecretK3ynasbdgwejh34786&^&^V&3ytgrdcejg((**&^@#&$%^&'

	     JWT.encode(payload, hmac_secret)
   	end
end
