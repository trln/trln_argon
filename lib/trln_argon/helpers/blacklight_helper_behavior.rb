module TrlnArgon
  # Put any shared overrides of BlacklightHelperBehavior
  # in this module. Overrides in the local TRLN Argon based
  # applications go in app/helpers/blacklight_helper.rb
  module BlacklightHelperBehavior
    def application_name
      TrlnArgon::Engine.configuration.application_name
    end
  end
end
