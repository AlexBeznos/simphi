require "simple_form"
require "simphi/simphi_input"

module SimpleForm
  class FormBuilder
    map_type :simphi, to: Simphi::SimphiInput
  end
end
