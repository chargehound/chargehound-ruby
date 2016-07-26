# Chargehound Ruby bindings

[![Build Status](https://travis-ci.org/chargehound/chargehound-ruby.svg?branch=master)](https://travis-ci.org/chargehound/chargehound-ruby) [![Gem Version](https://badge.fury.io/rb/chargehound.svg)](https://badge.fury.io/rb/chargehound)

## Installation

`gem install chargehound`

## Usage

Import chargehound and set your API key.

```ruby
require 'chargehound'
Chargehound.api_key = '{ YOUR_API_KEY }'
```

## Documentation

[Disputes](https://www.chargehound.com/docs/api/index.html?ruby#disputes)

[Errors](https://www.chargehound.com/docs/api/index.html?ruby#errors)

## Development

To build and install from the latest source:

```bash
$ git clone git@github.com:chargehound/chargehound-ruby.git
$ bundle install
```

Run tests:

```bash
$ bundle exec rake
```

## Deployment

To deploy a new version of the SDK, perform the following steps:

 1. Update the CHANGELOG to describe what feature have been added.
 2. Bump the version number in `/lib/chargehound/version.rb`
 3. Rebuild the gem with:
   ```gem build chargehound.gemspec```
 4. Deploy the new gemfile to rubygems with:
   ``` gem push <name_of_generated_gem>```
 5. Confirm the new gem version is available at [https://rubygems.org/gems/chargehound](https://rubygems.org/gems/chargehound)
