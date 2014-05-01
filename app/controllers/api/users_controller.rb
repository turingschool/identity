module Api
  class UsersController < ApiController
    def show
      render json: User.find(params[:id])
    end

    def update
      user            = User.find params[:id]
      user.attributes = user_params
      user.save!
      render nothing: true
    end

    private

    def user_params
      params.require(:user)
            .permit(:name,
                    :email,
                    :location,
                    :username,
                    :github_id,
                    :avatar_url,
                    :gravatar_id,
                    :stripe_customer_id)
      # omitted:
      #   is_admin <-- might actually be reasonable to allow
      #   created_at
      #   updated_at
    end
  end
end
