module ApplicationHelper

  def checkuser
    if session[:id] == nil
      redirect_to logins_path
    end
  end

end
