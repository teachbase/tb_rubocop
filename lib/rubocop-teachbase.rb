# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/teachbase'
require_relative 'rubocop/teachbase/version'
require_relative 'rubocop/teachbase/inject'

RuboCop::Teachbase::Inject.defaults!

require_relative 'rubocop/cop/teachbase_cops'
