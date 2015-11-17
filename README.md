# Simphi

## Description

This gem were implemented for natural using hashes in web development.
The gem divided in two parts: middleware and simple_form custom input.
With *Simphi::Middleware* you can send params to server and they will be rebuilt to normal hash and with simple_form input the hash can be sended in proper format to server.

#### Middleware
The middleware relies to `-simphi` part of the hash key.
```ruby
  "contacts-simphi": {
    "don't matter what here": {
      "key": "email",
      "value": "beznosa@yahoo.com"
    },
    "don't matter what here too": {
      "key": "skype",
      "value": "mix_beznos"
    }
  }

  # will be replaced with:

  "contacts": {
    "email": "beznosa@yahoo.com"
    },
    "skype": "mix_beznos"
    }
  }
```

#### Hash Input
SimphiInput is a SimpleForm custom input which create a typical hash structure for input with key, value.

![Simphi Hash Input](http://gdurl.com/wTNH)

It can be used as usual custom input:
```ruby
= simple_form_for do |f|
  = f.input :contacts, as: :simphi
   # Required fields can be passed as array of symbols or single symbol.
   # It works as field which will be presetted even if 'contacts' will be empty.
  = f.input :contacts, as: :simphi, required_fields: [:phone, :skype]
  # Also it can be populated with options for key_input, value_input, remove_button, error, add_button
  = f.input :contacts, as: :simphi, key_input: { class: 'shi_key' }, add_button: { id: 'custom_button_id' }
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simphi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simphi

## Usage
#### Middleware
To use middleware you need to add such lines to your `config/application.rb` file:

```ruby
require "simphi/middleware"

class Application < Rails::Application
  config.middleware.use Simphi::Middleware
end
```

#### Simphi Input
Hash input can be used as simple_form input with `as: :simphi` option. But you can reassign `simphi` to another name:
```ruby
# config/initializer/simphi.rb
module SimpleForm
  class FormBuilder
    map_type :name_which_you_want, to: Simphi::SimphiInput
  end
end
```
But to make `simphi` fully functional assets should be included

```js
// app/assets/javascripts/application.js

//= require simphi
```

```js
// app/assets/stylesheets/application.css

*= require "simphi" // NOTE: this file is only for hidding 'sample' hash element which used for generating new hash pairs
```
## Contributing

1. Fork it ( https://github.com/AlexBeznos/simphi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
