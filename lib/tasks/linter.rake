# frozen_string_literal: true

require 'rubycritic/rake_task'

# Runs linter rake task with `rake rubycritic`
RubyCritic::RakeTask.new do |task|
  task.paths = FileList['app/**/*.rb', 'lib/**/*.rb']
end
