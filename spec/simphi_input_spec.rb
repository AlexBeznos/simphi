require "spec_helper"
require "simphi"
require "simphi/simphi_input"

RSpec.shared_examples "with add more button" do
  it "include add more button" do
    assert_select ".add_hash_pair", 1
  end
end

RSpec.shared_examples "errors block" do
  it "include certain number of errors" do
    assert_select ".help-block", count + 1
  end
end

RSpec.shared_examples "include hash elements" do
  it "include certain number of hash elements with certain number of inputs(key, value for each)" do
    assert_select hash_element_class, elements_count + 1 do |hash_element|
      hash_element.each do |element|
        assert_select element, "input", 2
        assert_select element, ".remove_hash_pair", 1
      end
    end
  end
end

RSpec.shared_examples "include sample element" do
  it "include certain number of hash elements with certain number of inputs(key, value for each)" do
    assert_select "#{hash_element_class}.sample", 1 do |hash_element|
      hash_element.each do |element|
        assert_select element, "input", 2
        assert_select element, ".remove_hash_pair", 1
      end
    end
  end
end


describe "Simphi::SimphiInput", type: :input do
  let(:klass_name) { "RandomRecord" }
  let(:attr) { :fake_attr }

  let(:am) { double("ActiveModel", param_key: klass_name) }
  let!(:record) { double(klass_name, model_name: am, to_key: [1]) }

  let(:hash_element_class) { ".hash-pair" }

  context "with empty hash" do
    before do
      allow(record).to receive(attr)
      allow_any_instance_of(Simphi::SimphiInput).to receive(:error).and_return(nil)

      concat input_for(record, attr, options)
    end

    context "and without options" do
      let(:options) { { as: :simphi } }

      it "not include hash elements" do
        assert_select hash_element_class, 1
      end

      include_examples "with add more button"
      include_examples "include sample element"
      include_examples "errors block" do
        let(:count) { 0 }
      end
    end

    context "and with required fields" do
      let(:req_fields) { [:param_1, :param_2] }
      let(:options) do
        {
          as: :simphi,
          required_fields: req_fields
        }
      end

      include_examples "include hash elements" do
        let(:elements_count) { 2 }
      end

      include_examples "with add more button"
      include_examples "include sample element"
      include_examples "errors block" do
        let(:count) { 2 }
      end
    end
  end

  context "with full hash" do
    before do
      allow(record).to receive(attr) do
        {
          param_1: "first param",
          param_2: "second param"
        }
      end
    end

    context "and without options" do
      let(:options) { { as: :simphi } }

      before do
        allow_any_instance_of(Simphi::SimphiInput).to receive(:error).and_return(nil)
        concat input_for(record, attr, options)
      end

      include_examples "with add more button"
      include_examples "include sample element"
      include_examples "include hash elements" do
        let(:elements_count) { 2 }
      end
      include_examples "errors block" do
        let(:count) { 2 }
      end
    end

    context "and without options but with errors" do
      let(:options) { { as: :simphi } }
      let(:message) { "message" }

      before do
        allow(record).to receive(attr).and_return(param_1: "first param")
        allow_any_instance_of(Simphi::SimphiInput).to receive(:error).and_return(message)
        concat input_for(record, attr, options)
      end

      include_examples "include sample element"
      include_examples "with add more button"
      include_examples "errors block" do
        let(:count) { 1 }
      end
      include_examples "include hash elements" do
        let(:elements_count) { 1 }
      end
    end
  end

  context "with options" do
    possible_attributes = %i( key_input value_input remove_button error )
    let(:fake_attr_name) { "fake_attr_name" }

    before do
      allow(record).to receive(attr).and_return(param_2: "second param")
      allow_any_instance_of(Simphi::SimphiInput).to receive(:error).and_return(nil)

      concat input_for(record, attr, options)
    end

    context "class" do
      possible_attributes.each do |attribute|
        let(:options) { { as: :simphi, attribute => { class: fake_attr_name } } }

        it "applies" do
          assert_select [".", fake_attr_name].join, 2
        end
      end
    end

    context "id" do
      possible_attributes.each do |attribute|
        let(:options) { { as: :simphi, attribute => { id: fake_attr_name } } }

        it "applies" do
          assert_select ["#", fake_attr_name].join, 2
        end
      end
    end
  end
end
