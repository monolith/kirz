# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'thread' # workaround latest rubygems, http://stackoverflow.com/questions/5176782/uninitialized-constant-activesupportdependenciesmutex-nameerror

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

