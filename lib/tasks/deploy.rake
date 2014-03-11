namespace :deploy do
  desc "deploy application"
  task :heroku do
    puts "Running the tests..."
    if system("rake test") == false
      puts "FAILURE: There is a problem with your tests."
      break
    end
    puts "Done."

    puts "Deploying to Heroku..."
    if system("git push heroku master") == false
      puts "FAILURE: There was a problem deploying to Heroku."
      break
    end
    puts "Done."

    puts "Running migrations..."
    if system("heroku run rake db:migrate") == false
      puts "FAILURE: There was a problem running your migrations."
      break
    end
    puts "Done."

    puts "The application was deployed successfully."
  end
end