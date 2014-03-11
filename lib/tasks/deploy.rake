namespace :deploy do
  desc "deploy application"
  task :heroku do
    run_tests
    deploy_to_heroku
    run_migrations

    puts "The application was deployed successfully."
  end
end

private

def run_tests
  puts "Running the tests..."
  if system("rake test") == false
    puts "FAILURE: There is a problem with your tests."
    break
  end
  puts "Done."
end

def deploy_to_heroku
  puts "Deploying to Heroku..."
  if system("git push heroku master") == false
    puts "FAILURE: There was a problem deploying to Heroku."
    break
  end
  puts "Done."
end

def run_migrations
  puts "Running migrations..."
  if heroku("run rake db:migrate") == false
    puts "FAILURE: There was a problem running your migrations."
    break
  end
  puts "Done."
end

def heroku(command)
  system("GEM_HOME='' BUNDLE_GEMFILE='' GEM_PATH='' RUBYOPT='' /usr/local/heroku/bin/heroku #{command}")
end