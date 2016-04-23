$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

# import Chargehound and set your API key
require 'chargehound'
Chargehound.api_key = ENV['CHARGEHOUND_API_KEY']

# List currently active disputes and then submit
# the most recent with the 'crowdfunding' template
# and update the `customer_ip` evidence field.
disputes = Chargehound::Disputes.list
first = disputes['data'][0]
submitted = Chargehound::Disputes.submit(first['id'],
                                         template: 'crowdfunding',
                                         fields: {
                                           'customer_ip' => '100'
                                         })

puts "Submitted with fields: #{submitted['fields']}"
