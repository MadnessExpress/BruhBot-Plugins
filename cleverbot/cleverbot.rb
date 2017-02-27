module BruhBot
  module Plugins
    # Cleverbot plugin
    module CleverbotPlugin
      require 'ruby-cleverbot-api'

      extend Discordrb::EventContainer

      clever_conf = Yajl::Parser.parse(File.new("#{__dir__}/config.json", 'r'))
      apikey = false if BruhBot.api['cleverbot_api_key'].nil? || BruhBot.api['cleverbot_api_key'].empty?
      # Connect to Cleverbot
      cleverbot = Cleverbot.new(BruhBot.api['cleverbot_api_key']) unless apikey == false

      time = Time.new
      last_mention = time.strftime('%Y%m%d%H%M%S').to_i
      # On bot mention.
      mention do |event|
        next puts 'You have not added an API key for Cleverbot.' if apikey == false
        time = Time.new
        current_mention = time.strftime('%Y%m%d%H%M%S').to_i
        cleverbot.reset if (current_mention - last_mention) / 60 >= clever_conf['reset_time']
        last_mention = current_mention
        # Scrubbed message
        message = event.message.content.gsub(/<@#{clever_conf['bot_id']}>/, '')
        message = message.gsub(/<@!#{clever_conf['bot_id']}>/, '')
        message = message.gsub(/<@!?(\d+)>/) do
          event.bot.user(Regexp.last_match(1).to_i.to_i).on(event.server).display_name
        end

        response = cleverbot.send_message(message.strip)
        # Submit message to Cleverbot minus the mention and output the response.
        event.respond response unless response.empty?
        event.respond 'Empty Response' if response.empty?
      end
      # End bot mention event.
    end
    # End CleverbotPlugin module
  end
end
