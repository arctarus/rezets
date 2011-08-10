module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    "/"
  end

  def user_path(user)
    "/users/#{user.to_param}"
  end

  def edit_user_path(user)
    "#{user_path(user)}/edit"
  end

  def user_update_password(user)
    "#{user_path(user)}/update_password"
  end
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
