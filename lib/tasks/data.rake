namespace :data do
  desc "migrate application status"
  task :migrate => :environment do
    Application.upto(:final).each do |application|
      if application.evaluations.count == 0
        application.update_attributes(status: 'completed')
      else
        application.update_attributes(status: 'evaluating')
      end
    end
  end
end
