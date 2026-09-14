module Api
  module V1
    class BaseController < ActionController::API
      private

      def current_user
        @current_user ||= User.first
      end
    end
  end
end
