class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: []
  #before_action :authenticate_user!
  before_action :configure_permitted_parameters, only: [:update]
  before_action :sign_up_permitted_parameters, only: [:create]

  def new
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path, alert: 'login error.'
    end
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        redirect_to root_path
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  def sign_up_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

end
