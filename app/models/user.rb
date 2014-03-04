class User < ActiveRecord::Base
  has_one :application, inverse_of: :user

  def self.from_github(data)
    find_from_github(data) || create_from_github(data)
  end

  def self.find_from_github(data)
    user = User.find_by(github_id: data['id'])

    if user
      user.username = data['login']
      user.save
    end

    user
  end

  def self.create_from_github(data)
    user_data = {
      name:        data['name'],
      email:       data['email'],
      location:    data['location'],
      github_id:   data['id'],
      avatar_url:  data['avatar_url'],
      gravatar_id: data['gravatar_id'],
      username:    data['login']
    }

    user = User.create(user_data)
    user.send_welcome_email
    user
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver
  end

  def guest?
    false
  end

  def admin?
    is_admin
  end

  def applying?
    application && application.completed?('bio')
  end

  def apply
    build_application unless application
    application
  end

  def apply!
    create_application unless application
    application
  end

  def admin!
    self.is_admin = true
    save
  end
end
