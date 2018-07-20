# frozen_string_literal: true

class OmniAuth::Adapters::Linkedin < OmniAuth::Adapters::Base
  def name
    @auth[:info][:name]
  end

  def first_name
    @auth[:info][:first_name]
  end

  def last_name
    @auth[:info][:last_name]
  end

  private

  def email_is_verified?
    @auth[:info][:email].present?
  end
end
