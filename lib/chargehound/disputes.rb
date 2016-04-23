require 'chargehound/api_request'

module Chargehound
  # Access the Chargehound dispute resource
  class Disputes
    # A list of disputes
    # This endpoint will list all the disputes that we have synced from Stripe.
    # By default the disputes will be ordered by `created` with the most recent
    # dispute first. { }`has_more` will be `true` if more results are available.
    # @option [Hash] params the optional parameters
    # @option params [Float] :limit Maximum number of disputes to return.
    #   Default is 20, maximum is 100.
    # @option params [String] :starting_after A dispute id.
    #   Fetch disputes created after this dispute.
    # @option params [String] :ending_before A dispute id.
    #   Fetch disputes created before this dispute.
    # @return [Disputes]
    def self.list(params = {})
      ApiRequest.new(:get, 'disputes', query_params: params).run
    end

    # Retrieve a dispute
    # This endpoint will return a single dispute.
    # @param dispute_id A dispute id
    # @return [Dispute]
    def self.retrieve(dispute_id)
      ApiRequest.new(:get, "disputes/#{dispute_id}").run
    end

    # Submitting a dispute
    # You will want to submit the dispute through Chargehound after you recieve
    # a notification from Stripe of a new dispute. With one `POST` request
    # you can update a dispute with the evidence fields and send the generated
    # response to Stripe.
    # The response will have a `201` status if the submit was successful.
    # The dispute will also be in the submitted state.
    # @param dispute_id A dispute id
    # @option [Hash] update  A dispute update object
    # @option update [String] :template The id of the template to use.
    # @option update [Object] :fields Key value pairs to hydrate the
    #   template's evidence fields.
    # @option update [String] :customer_name Update the customer name.
    #   Will also update the customer name in the evidence fields.
    # @option update [String] :customer_email Update the customer email.
    #   Will also update the customer email in the evidence fields.
    #   Must be a valid email address.
    # @return [Dispute]
    def self.submit(dispute_id, update = {})
      ApiRequest.new(:post, "disputes/#{dispute_id}/submit", body: update).run
    end

    # Updating a dispute
    # You can update the template and the fields on a dispute.
    # @param dispute_id A dispute id
    # @option [Hash] update  A dispute update object
    # @option update [String] :template The id of the template to use.
    # @option update [Object] :fields Key value pairs to hydrate the template's
    #   evidence fields.
    # @option update [String] :customer_name Update the customer name.
    #   Will also update the customer name in the evidence fields.
    # @option update [String] :customer_email Update the customer email.
    #   Will also update the customer email in the evidence fields.
    #   Must be a valid email address.
    # @return [Dispute]
    def self.update(dispute_id, update = {})
      ApiRequest.new(:put, "disputes/#{dispute_id}", body: update).run
    end
  end
end
