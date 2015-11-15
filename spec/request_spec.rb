require "simphi/request"
require "spec_helper"

describe Simphi::Request do
  context "#normalize_hash_params" do
    let(:request) { Simphi::Request.new(double) }

    before do
      allow_any_instance_of(Simphi::Request).to receive(:POST).and_return(params_before)
      allow_any_instance_of(Simphi::Request).to receive(:GET).and_return({})
    end

    context "when params not include hash" do
      let(:params_before) do
        {
          "five" => "five",
          "one" => {
            "two" => "two",
            "three" => "three"
          },
          "four" => "four"
        }
      end

      it "not change the hash" do
        request.normalize_hash_params

        expect(request.params).to eq params_before
      end
    end

    context "when params include well formed hashes" do
      let(:params_before) do
        {
          "one" => "one",
          "two" => {
            "more" => {
              "first-shi_hash" => {
                "first-pair" => {
                  "key" => "first-key",
                  "value" => "first-value"
                },
                "second" => {
                  "key" => "second-key",
                  "value" => "second-value"
                }
              }
            }
          },
          "three-shi_hash" => {
            "first-pair" => {
              "key" => "first-key",
              "value" => "first-value"
            }
          }
        }
      end

      let(:params_after) do
        {
          "one" => "one",
          "two" => {
            "more" => {
              "first" => {
                "first-key" => "first-value",
                "second-key" => "second-value"
              }
            }
          },
          "three" => {
            "first-key" => "first-value"
          }
        }
      end

      it "change the hash" do
        request.normalize_hash_params

        expect(request.params).to eq params_after
      end
    end

    context "when include not formed properly hash param because of" do
      context "include only key" do
        let(:params_before) do
          {
            "first-shi_hash" => {
              "first-pair" => {
                "key" => "first-key"
              }
            }
          }
        end

        it "should raise exception" do
          expect { request.normalize_hash_params }.to raise_error(ArgumentError)
        end
      end

      context "include key and value but with incorect names" do
        let(:params_before) do
          {
            "first-shi_hash" => {
              "first-pair" => {
                "k" => "first-key",
                "value" => "first-value"
              }
            }
          }
        end

        it "should raise exception" do
          expect { request.normalize_hash_params }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
