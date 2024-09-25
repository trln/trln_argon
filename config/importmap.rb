# frozen_string_literal: true

# See example pattern in BL engine:
# https://github.com/projectblacklight/blacklight/blob/release-8.x/config/importmap.rb
# https://github.com/rails/importmap-rails?tab=readme-ov-file#composing-import-maps
pin_all_from File.expand_path("../app/javascript/trln_argon", __dir__), under: "trln_argon"
