# frozen_string_literal: true

class OmniAuth::Manager
  def initialize(auth, current_user = User.new)
    @auth         = auth
    @current_user = current_user if current_user.persisted?
  end

  def call
    ActiveRecord::Base.transaction do
      identity.update_attribute(:user, user) unless identity.user == user
      user.skip_confirmation!
      assign_user_role
      yield(user, @auth) if block_given? && user.persisted?
      user
    end
  end

  private

  def user
    @user ||= @current_user || identity.user || create_user
  end

  def identity
    @identity ||= Identity.find_for_oauth(@auth)
  end

  def create_user
    user = User.where(email: @auth.email).first
    user || User.create(email:      @auth.email,
                        password:   Devise.friendly_token[0, 20],
                        first_name: @auth.first_name,
                        last_name:  @auth.last_name)
  end

  def assign_user_role
    user.add_role(Role::USER) unless user.has_role?(Role::USER)
  end
end
