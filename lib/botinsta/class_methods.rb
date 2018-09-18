# require 'actions'
require 'helpers'
require 'login'
require 'modes'
require 'pages'
require 'requests'

module ClassMethods

  include Actions
  include Helpers
  include Login
  include Modes
  include Pages
  include Requests

end