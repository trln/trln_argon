# frozen_string_literal: true

module LayoutHelper
  include Blacklight::LayoutHelperBehavior

  def main_content_classes
    'col-lg-9 col-md-8 col-sm-7'
  end

  def sidebar_classes
    'col-lg-3 col-md-4 col-sm-5'
  end
end
