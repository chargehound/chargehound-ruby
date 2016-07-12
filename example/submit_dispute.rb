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
                                             name:
                                               'Product Name 1',
                                             description:
                                               'Product Description (optional)',
                                             image:
                                               'Product Image URL (optional)',
                                             sku:
                                               'Stock Keeping Unit (optional)',
                                             quantity:
                                               1,
                                             amount:
                                               1000,
                                             url:
                                               'Product URL (optional)'
                                           }, {
                                             name:
                                               'Product Name 2',
                                             description:
                                               'Product Description (optional)',
                                             image:
                                               'Product Image URL (optional)',
                                             sku:
                                               'Stock Keeping Unit (optional)',
                                             quantity:
                                               '10oz',
                                             amount:
                                               2000,
                                             url:
                                               'Product URL (optional)'
                                           }
                                         ])

puts "Submitted with fields: #{submitted['fields']}"
