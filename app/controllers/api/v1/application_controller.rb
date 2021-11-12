class Api::V1::ApplicationController < ActionController::API
	
	before_action :authenticate_api_user


	def authenticate_api_user
		begin

			data = decode(request.headers["Authorization"])
			raise "Seems you are logout" if !data.present?
			@current_api_user = User.find_by(email: data["email"])
			raise "Seems you are logout" if !@current_api_user.present?
	
		rescue Exception => @e
			err_hash = HashWithIndifferentAccess.new
			err_hash[:error] = @e.message
			status = :unauthorized
			render json: err_hash.to_json, status: status
		end
	end


  	def error_handle_bad_request(e)
	
		ary_errors = []
		ary_errors_obj = {}
		ary_errors_obj[:domain] = "usageLimits"
		ary_errors_obj[:reason] = e.message
		ary_errors_obj[:message] = e.message.humanize
		ary_errors_obj[:extendedHelp] = ""
		ary_errors.push(ary_errors_obj)
		error_obj = {}
		error_obj[:errors] = ary_errors
		error_obj[:code] = 400
		error_obj[:message] = e.message.humanize
		error_obj[:reason] = e.message
		err_hash = {}
		err_hash[:error] = error_obj 

		render :json => err_hash.to_json, status: :bad_request
	end

	private

	 	def decode(token)
	 		hmac_secret = 'my$ecretK3ynasbdgwejh34786&^&^V&3ytgrdcejg((**&^@#&$%^&'

			body = JWT.decode(token, hmac_secret)[0]
			HashWithIndifferentAccess.new body
			rescue
				nil
		end
end