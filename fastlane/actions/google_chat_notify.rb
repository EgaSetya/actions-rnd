require 'net/http'
require 'json'

module Fastlane
  module Actions
    class GoogleChatNotifyAction < Action
      def self.run(params)
        webhook_url = "https://chat.googleapis.com/v1/spaces/AAAATcXS17w/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=fnc4MP1lpXNb834FOhi0-gq6dDnqut6EGZJLTk3zQo4"
        message = params[:message]

        uri = URI(webhook_url)
        header = { 'Content-Type': 'application/json' }

        # Try parsing the message as JSON to check if it's a card
        begin
          parsed_message = JSON.parse(message)
          # If message is already JSON (card format), use it directly
          payload = message
        rescue JSON::ParserError
          # If message is plain text, wrap it in text format
          payload = { text: message }.to_json
        end

        response = Net::HTTP.post(uri, payload, header)

        if response.code.to_i == 200
          UI.success("Successfully sent message to Google Chat!")
        else
          UI.error("Failed to send message to Google Chat: #{response.body}")
          UI.error("Payload sent: #{payload}")
        end
      end

      def self.description
        "Send notifications to Google Chat (supports both text and card format)"
      end

      def self.authors
        ["Ega"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :webhook_url,
            description: "Google Chat webhook URL",
            type: String,
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :message,
            description: "Message to send to Google Chat (can be text or card JSON)",
            type: String,
            optional: false,
            verify_block: proc do |value|
              if value.nil? || value.empty?
                UI.user_error!("No message provided")
              end
            end
          )
        ]
      end

      def self.example_code
        [
          'google_chat_notify(
            message: "Simple text message"
          )',
          'google_chat_notify(
            message: {
              cardsV2: [{
                card: {
                  header: {
                    title: "Card Title",
                    subtitle: "Card Subtitle"
                  },
                  sections: [{
                    widgets: [{
                      textParagraph: {
                        text: "Card content"
                      }
                    }]
                  }]
                }
              }]
            }.to_json
          )'
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end