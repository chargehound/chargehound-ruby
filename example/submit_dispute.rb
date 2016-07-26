$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

# import Chargehound and set your API key
require 'chargehound'
Chargehound.api_key = ENV['CHARGEHOUND_API_KEY']

# List currently active disputes and then submit
# the most recent with the 'crowdfunding' template
# and update the `customer_ip` evidence field, along
# with some product information.
disputes = Chargehound::Disputes.list
first = disputes['data'][0]
submitted = Chargehound::Disputes.submit(first['id'],
                                         template:
                                             'crowdfunding',
                                         fields: {
                                           customer_ip: '0.0.0.0'
                                         },
                                         products: [
                                           {
                                             name: 'Saxophone',
                                             description:
                                               'Alto saxophone, ' \
                                               'with carrying case',
                                             image:
                                               'http://s3.amazonaws.com/' \
                                               'chargehound/saxophone.png',
                                             sku: '17283001272',
                                             quantity: 1,
                                             amount: 20_000,
                                             url: 'http://www.example.com'
                                           }, {
                                             name: 'Milk',
                                             description:
                                               'Semi-skimmed Organic',
                                             image:
                                               'http://s3.amazonaws.com/' \
                                               'chargehound/milk.png',
                                             sku: '26377382910',
                                             quantity: '64oz',
                                             amount: 400,
                                             url: 'http://www.example.com'
                                           }
                                         ])

puts "Submitted with fields: #{submitted['fields']}"
