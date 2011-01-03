namespace :sample_data do
  desc "Load a sample job"
  task :job => :environment do
    job = Job.new(:name => 'Sample Job', :browsers => 'popular', :suites => 'Sample: http://localhost:3000/sample_tests')
    job.user = User.first
    puts job.save ? "Added job for #{job.user.email}" : job.errors.full_messages.to_sentence
  end
end
