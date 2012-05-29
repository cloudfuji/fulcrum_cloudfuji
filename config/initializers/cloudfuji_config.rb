if ::Cloudfuji::Platform.on_cloudfuji?
  # Override Fulcrum.devise_modules with Cloudfuji authentication
  module Fulcrum
    def self.devise_modules
      [:cloudfuji_authenticatable, :trackable, :token_authenticatable]
    end
  end
end
