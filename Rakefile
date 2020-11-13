# frozen_string_literal: true

require 'fileutils'

task :cleanup do
puts ' ========Deleting old reports ang logs========='
FileUtils.rm_rf('reports')
File.delete('cucumber_failures.log') if File.exist?('cucumber_failures.log')
File.new('cucumber_failures.log', 'w')
Dir.mkdir('reports')
end

task :parallel_run do
puts '===== Executing Tests in parallel'
system 'bundle exec parallel_cucumber features/ -o "-p parallel -p pretty" -n 1'
puts ' ====== Parallel execution finished and cucumber_failure.log created ========='
end

task :parallel_run_stage do
  puts '===== Executing Tests in parallel'
  system 'bundle exec parallel_cucumber features/ -o "-p parallel_stage -p pretty" -n 1'
  puts ' ====== Parallel execution finished and cucumber_failure.log created ========='
end

task :rerun do
if File.size('cucumber_failures.log') == 0
puts '==== No failures. Everything Passed ========='
else
puts ' =========Re-running Failed Scenarios============='
system 'bundle exec cucumber @cucumber_failures.log -f pretty'
end
end

task test: %i[cleanup parallel_run rerun]
task stage: %i[cleanup parallel_run_stage rerun]

task :stage do
  Rake::Task['stage'].invoke
end

task :test do
  Rake::Task['test'].invoke
end






