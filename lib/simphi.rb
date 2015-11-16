require "simple_form"
require "simphi/simphi_input"

module Simphi
  class Engine < Rails::Engine
  end
end

module SimpleForm
  class FormBuilder
    map_type :simphi, to: Simphi::SimphiInput
  end
end
