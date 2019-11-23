# frozen_string_literal: true

require 'yard'

# Runs documentation rake task with `rake yard`
YARD::Rake::YardocTask.new do |t|
  t.options = ['-odocs', '-rREADME.md']
  t.stats_options = ['--list-undoc']
end
