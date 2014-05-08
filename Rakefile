task 'add_fury_as_remote_repository' do
  unless %x(git remote).include?("fury")
    sh "git remote add fury https://jumpstartlab@git.fury.io/jumpstartlab/jsl-identity.git"
  end
end

desc 'Push the gem to gemfury, our host so that our apps can use it'
task 'push' => 'add_fury_as_remote_repository'
task 'push' do
  sh 'git push fury master:master'
end
