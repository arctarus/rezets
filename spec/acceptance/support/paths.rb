module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    "/"
  end

  def user_path(user)
    "/users/#{user.to_param}"
  end
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
