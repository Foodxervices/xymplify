class ApplicationController < PublicController
  before_action :authenticate_user!
end
