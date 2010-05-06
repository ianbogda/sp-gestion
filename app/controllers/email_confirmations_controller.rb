class EmailConfirmationsController < BackController
  
  layout('login')
  navigation(:email_confirmations)
  
  skip_before_filter :require_user
  before_filter :require_no_user
  
  before_filter :load_user_using_perishable_token
  
  def edit
    @user_session = @station.user_sessions.new
  end
  
  def update
    @user_session = @station.user_sessions.new(:email => @user.email, :password => params[:user_session][:password])
    if @user_session.valid?
      if @user.swap_emails
        @station.user_sessions.create(:email => @user.email, :password => params[:user_session][:password])
        flash[:success] = "Le changement d'adresse email est effectué."
        redirect_to(profile_path)
      else
        flash.now[:error] = "La nouvelle adresse email est déjà utilisée. Impossible de procéder au changement."
        redirect_to(login_path)
      end
    else
      flash.now[:error] = "Erreur dans votre mot de passe."
      render(:action => :edit)
    end
  end
  
  private
  
  def load_user_using_perishable_token
    @user = @station.users.find_using_perishable_token(params[:id], 0)
    if @user.nil? or @user.new_email.blank?
      redirect_to(login_path)
    end
  end
  
end
