require "simple_form"

module Simphi
end

SimpleForm::Inputs.send(:include, Simphi)
