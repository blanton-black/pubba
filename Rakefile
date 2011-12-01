begin
  require 'bundler'
  Bundler::GemHelper.install_tasks
rescue Exception => e
end

require 'rake/testtask'

Rake::TestTask.new('test') do |t|
  t.libs << 'lib' << 'test'
  t.test_files = FileList['test/pubba/test_*.rb']
  t.verbose = true
end

task 'test:ci' do |t|
  Rake::Task[ENV['TASK']].execute
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'lib' << 'test'
    t.test_files = FileList['test/pubba/test_*.rb']
    t.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: gem install rcov"
  end
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files = %w(lib/**/*.rb)
  end
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yard, you must: gem install yard"
  end
end

desc "Generate Documentation"
task :doc => :yard

task :default => 'test'
