require 'chargehound/api_request'

module Chargehound
  # Access the Chargehound dispute resource
  class Disputes
    # Create a dispute
    # @option [Hash] A dispute create object
    # @return [Dispute]
    def self.create(create = {})
      ApiRequest.new(:post, 'disputes', body: create).run
    end

    # A list of disputes
    # This endpoint will list all the disputes that we have synced from Stripe.
    # By default the disputes will be ordered by `created` with the most recent
    # dispute first. { }`has_more` will be `true` if more results are available.
    # @option [Hash] params the query parameters
    # @return [Disputes]
    def self.list(params = {})
      ApiRequest.new(:get, 'disputes', query_params: params).run
    end

    # Retrieve a dispute
    # This endpoint will return a single dispute.
    # @param [String] dispute_id A dispute id
    # @return [Dispute]
    def self.retrieve(dispute_id)
      ApiRequest.new(:get, "disputes/#{dispute_id}").run
    end

    # Retrieve the response for a dispute.
    # @param [String] dispute_id A dispute id
    # @return [Dispute]
    def self.response(dispute_id)
      ApiRequest.new(:get, "disputes/#{dispute_id}/response").run
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
    # @return [Dispute]
    def self.submit(dispute_id, update = {})
      ApiRequest.new(:post, "disputes/#{dispute_id}/submit",
                     body: update).run
    end

    # Updating a dispute
    # You can update the template and the fields on a dispute.
    # @param dispute_id A dispute id
    # @option [Hash] update  A dispute update object
    # @return [Dispute]
    def self.update(dispute_id, update = {})
      ApiRequest.new(:put, "disputes/#{dispute_id}",
                     body: update).run
    end

    # Accept a dispute and do not submit a response
    # @param dispute_id A dispute id
    # @return [Dispute]
    def self.accept(dispute_id)
      ApiRequest.new(:post, "disputes/#{dispute_id}/accept").run
    end
  end
end
