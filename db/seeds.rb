User.destroy_all
Application.destroy_all
FileUtils.rm_rf('./public/uploads')

require_relative '../test/support/factory'

unless Rails.env.production?
  (1..500).each do |i|
    user = Factory::User.create_user(github_id: -1*i)
    user.apply!
    app = user.application
    Factory::Apply.randomly_progress app
  end
end
