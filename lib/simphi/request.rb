require 'rack/request'

module Simphi
  class Request < Rack::Request
    def normalize_hash_params
      params.each do |key, value|
        normalize_to_proper_params(value) if with_hash? value

        if with_hash? key
          param = delete_param(key)
          update_param(key.gsub(/-simphi/, ''), normalized_hash(param))
        end


      end if with_hash? params
    end

    private

    def with_hash?(param)
      return param =~ /-simphi/ if param.is_a? String
      return param.to_s =~ /-simphi/ if param.is_a? Hash
    end

    def normalized_hash(params)
      hashes = params.map do |_, v|
        if v.length <= 1 || !v.has_key?('key') || !v.has_key?('value')
          raise ArgumentError, 'Every hash element should include key and value'
        end

        { v['key'] => v['value'] } if v['key'].present? && v['value'].present?
      end.compact

      hashes.reduce Hash.new, :merge
    end

    def normalize_to_proper_params(hash)
      if hash.is_a? Hash

        list = hash.map do |k, v|
          normalize_to_proper_params(v) if with_hash? v

          if with_hash? k
            {
              key: k,
              obj: { k.gsub(/-simphi/, '') => normalized_hash(v) }
            }
          end

        end.compact

        list.each do |v|
          hash.delete(v[:key])
          hash.merge!(v[:obj])
        end

      end
    end
  end
end
