# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = OmniAuth::Adapters::Facebook.new(request.env['omniauth.auth'])
    process_provider(OmniAuth::Manager.new(auth, current_user))
  end

  def twitter
    auth = OmniAuth::Adapters::Twitter.new(request.env['omniauth.auth'])
    process_provider(OmniAuth::Manager.new(auth, current_user))
  end

  def google_oauth2
    auth = OmniAuth::Adapters::Google.new(request.env['omniauth.auth'])
    process_provider(OmniAuth::Manager.new(auth, current_user))
  end

  def linkedin
    auth = OmniAuth::Adapters::Linkedin.new(request.env['omniauth.auth'])
    process_provider(OmniAuth::Manager.new(auth, current_user))
  end

  private

  def process_provider(service)
    service.call do |user, auth|
      plan = session[:subscription_plan_id]
      sign_in(user)
      return redirect_to(finish_redirect(user, auth, plan))
    end

    redirect_to new_user_registration_url
  end

  def finish_redirect(user, auth, plan)
    return new_finish_registration_path if auth.temporary_email?(user.email)
    return accounts_subscriptions_path(plan: plan) if plan.present?
    after_sign_in_path_for(user)
  end
end
