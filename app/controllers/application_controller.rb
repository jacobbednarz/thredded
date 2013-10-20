class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :extra_data

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to site_home
  end

  def authenticate_admin_user!
    unless current_user && current_user.superadmin?
      redirect_to '/'
    end
  end

  private

  def merge_default_topics_params
    params.deep_merge!({
      topic: {
        last_user: current_user,
        user: current_user,
        posts_attributes: {
          '0' => {
            messageboard: messageboard,
            ip: request.remote_ip,
            user: current_user,
          }
        }
      }
    })
  end

  def extra_data
    ''
  end

  def get_project
    @app_config ||= AppConfig.first
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:redirect_url] || site_home
  end

  def after_sign_out_path_for(resource_or_scope)
    site_home
  end

  def site_home
    '/'
  end

  def default_home
    root_path
  end
end
