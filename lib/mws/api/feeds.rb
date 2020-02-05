module MWS
  module API
    # Feeds
    class Feeds < Base
      XSD_PATH = File.join(File.dirname(__FILE__), 'feeds', 'xsd')

      ACTIONS = [:get_feed_submission_list, :get_feed_submission_list_by_next_token,
                 :get_feed_submission_count, :cancel_feed_submissions, :get_feed_submission_result].freeze

      def initialize(connection)
        @uri = '/'
        @version = '2009-01-01'
        @verb = :post
        super
      end

      def submit_feed(params = {})
        xml_envelope = Envelope.new(params.merge!(merchant_id: connection.seller_id))
        params = params.except(*params_to_except(params))
        call(:submit_feed, params_to_request(params, xml_envelope))
      end

      protected

      def params_to_except(params)
        except_params = [:merchant_id, :message_type, :message, :messages, :skip_schema_validation]
        except_params << :type if params[:message_type].to_s == 'invoice'
        except_params
      end

      def params_to_request(params, envelope)
        request_params = {
          body: envelope.to_s,
          headers: { 'Content-MD5' => envelope.md5, 'Content-Type' => 'text/xml' }
        }

        if params[:message_type].to_s == 'invoice'
          request_params[:headers] = { 'Content-MD5' => envelope.md5, 'Content-Type' => 'application/octet-stream' }
        else
          request_params[:format] = :xml
        end

        params.merge!(request_params: request_params)
      end
    end
  end
end
