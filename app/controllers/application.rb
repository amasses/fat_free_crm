class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '165eb65bfdacf95923dad9aea10cc64a'

  #-------------------------------------------------------------------
  def tabs
    session[:current_tab] = :home unless session[:current_tab]
    [ # array of hashes
      { :active => (session[:current_tab] == :home),  :text => "Home",  :url => home_path },
      { :active => (session[:current_tab] == :tab2),  :text => "Tab 2", :url => "/" },
      { :active => (session[:current_tab] == :tab3),  :text => "Tab 3", :url => "/" },
      { :active => (session[:current_tab] == :tab4),  :text => "Tab 4", :url => "/" }
    ]
  end

  private
  #----------------------------------------------------------------------------
  def set_current_tab(tab = :none)
    session[:current_tab] = tab
  end
  
  #----------------------------------------------------------------------------
  def current_user_session
    @current_user_session = Authentication.find unless @current_user_session
    @current_user_session
  end
  
  #----------------------------------------------------------------------------
  def current_user
    @current_user = current_user_session && current_user_session.record unless @current_user
    @current_user
  end
  
  #----------------------------------------------------------------------------
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page."
      redirect_to login_url
      return false
    end
  end

  #----------------------------------------------------------------------------
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page."
      redirect_to profile_url
      return false
    end
  end
  
  #----------------------------------------------------------------------------
  def store_location
    session[:return_to] = request.request_uri
  end
  
  #----------------------------------------------------------------------------
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end