module TrlnArgon
  class AdvancedSearchFormComponent < Blacklight::AdvancedSearchFormComponent
    include RangeLimitHelper
    include ViewHelpers
  end
end
