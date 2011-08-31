module FederatedRails
  class SecurityManager
    attr_accessor :warden
    def initialize(w)
      @warden = w
    end
    def method_missing(name, *args)
      warden.send name, *args
    end
    def subject
      warden.user
    end
  end
end