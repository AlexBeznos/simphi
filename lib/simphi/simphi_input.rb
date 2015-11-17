require 'simple_form'

####
# Simple Hash extending for code minimization
class Hash
  def exclude_keys(*keys)
    self.reject { |e| keys.include? e }
  end
end

module Simphi
  class SimphiInput < SimpleForm::Inputs::Base
    def input(wrapper_options)
      @io = ActiveSupport::SafeBuffer.new

      @builder.fields_for "#{attribute_name}-simphi" do |b|
        @hash_builder = b

        @io.tap do |sb|
          get_fields_for(required_attributes, 1, true)
          get_fields_for(not_required_attributes, required_attributes.count + 1)
          add_button
        end

      end
    end

    private
    def attribute_value
      object.send(attribute_name)
    end

    def required_attributes
      Array.new([ input_options.try(:[], :required_fields) ])
           .flatten
           .compact
           .map(&:to_s)
    end

    def not_required_attributes
      attribute_value.try(:keys).to_a - required_attributes + [:sample_simphi]
    end

    def get_fields_for(array, start, required = false)
      array.each_with_index.each do |key, index|
        @io << hash_pair(key, start + index, @hash_builder)
      end
    end

    ####
    # Button for adding new hash pairs
    def add_button
      @io << template.content_tag(:button, *add_button_options)
    end

    def add_button_options
      opts = input_options_for(:add_button)
      [
        opts.fetch(:label, I18n.t('simple_hash_input.add_button', default: 'Add more')),
        {
          class: "#{opts.fetch(:class, 'btn btn-block btn-primary')} add_hash_pair"
        }.merge(opts.exclude_keys(:label, :class))
      ]
    end

    ####
    # Hash pair is inputs for key, value of hash, also it is added remove button
    # and block for errors handling
    def hash_pair(key, index, builder)
      template.content_tag(:div, hash_pair_options(key, index)) do
        builder.fields_for "hash-#{index}" do |f|
          template.concat( wrapped_input(key, f, 'key') )
          template.concat( wrapped_input(key, f, 'value') )
          template.concat( remove_button() )
          template.concat( error_help_block(key) )
        end
      end
    end

    def hash_pair_options(key, index)
      opts = input_options_for(:hash_pair)
      klass = ["hash-#{index}"]
      klass << opts.fetch(:class, 'row hash-pair')
      klass << 'sample' if key == :sample_simphi
      klass << 'has_error' if error(key)
      klass * ' '

      {
        class: klass
      }.merge(opts.exclude_keys(:class))
    end

    ####
    # Input field, wrapped into block for better styling ability
    def wrapped_input(key, builder, name)
      opts = input_options_for("#{name}_input".to_sym).fetch(:wrapper, {})
      wrapper_opts = { class: 'col-xs-5' }.merge(opts)

      template.content_tag(:div, wrapper_opts) do
        builder.text_field(name, self.send("#{name}_options", key))
      end
    end

    def key_options(key)
      extends = if key == :sample_simphi
        { disabled: 'disabled' }
      else
        { value: key }
      end

      input_options_for(:key_input).merge(extends)
    end

    def value_options(key)
      value = attribute_value.try(:[], key)
      opts = {}
      opts.merge!({ disabled: 'disabled' }) if key == :sample_simphi
      opts.merge!(value ? { value: value } : {})
      opts.merge( input_options_for(:value_input) )
    end

    ####
    # Button for removing hash pair
    def remove_button
      opts = input_options_for(:remove_button).fetch(:wrapper, {})
      wrapper_opts = { class: 'col-xs-2' }.merge(opts)

      template.content_tag(:div, wrapper_opts) do
        template.concat( template.content_tag(:button, *remove_button_options) )
      end
    end

    def remove_button_options
      opts = input_options_for(:remove_button)
      [
        opts.fetch(:label, 'x'),
        {
          class: "#{opts.fetch(:class, 'btn btn-default pull-right')} remove_hash_pair"
        }.merge(opts.exclude_keys(:label, :class, :wrapper))
      ]
    end

    ####
    # Block for error handling
    def error_help_block(key)
      opts = { class: 'col-xs-12 help-block' }.merge(input_options_for(:error))
      template.content_tag(:span, error(key), opts)
    end

    ####
    # Error finder, which based on using store_accessor
    # and setting validation on hash attributs
    def error(key)
      if key.is_a? String
        k = key.to_sym
        messages = object.errors.messages

        messages.try(:[], k).try(:first)
      end
    end

    def input_options_for(key)
      opts = input_options.fetch(key, {})
      opts.is_a?(Hash) ? opts : {}
    end
  end
end
