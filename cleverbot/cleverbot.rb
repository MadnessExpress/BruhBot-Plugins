module BruhBot
  module Plugins
    # Cleverbot plugin
    module CleverbotPlugin
      require 'ruby-cleverbot-api'

      extend Discordrb::EventContainer

      apikey = false if BruhBot.api['cleverbot_api_key'].nil? || BruhBot.api['cleverbot_api_key'].empty?
      # Connect to Cleverbot
      cleverbot = Cleverbot.new(BruhBot.api['cleverbot_api_key']) unless apikey == false

      # On bot mention.
      mention do |event|
        next puts 'You have not added an API key for Cleverbot.' if apikey == false
        # Scrubbed message
        message = event.message.content.gsub(/<@192334740651638784>/, '')
        message = message.gsub(/<@!192334740651638784>/, '')
        message = message.gsub(/<@!?(\d+)>/) do
          event.bot.user(Regexp.last_match(1).to_i.to_i).on(event.server).display_name
        end

        response = cleverbot.send_message(message)
        # Sumbit message to Cleverbot minus the mention and output the response.
        event.respond response unless response.empty?
        event.respond 'Empty Response' if response.empty?
      end
      # End bot mention event.
    end
    # End CleverbotPlugin module
  end
end
