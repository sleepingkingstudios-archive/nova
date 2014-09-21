# lib/errors/authentication_error.rb

module Nova
  class AuthenticationError < StandardError
    def initialize request
      @action     = request[:action]
      @controller = request[:controller]
      @params     = request[:params]

      @request    = request
    end # method initialize

    attr_reader :action, :controller, :params, :request

    def message
      "user not authorized to perform that action"
    end # method message
  end # class
end # module
