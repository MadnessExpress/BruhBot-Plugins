module BruhBot
  module Plugins
    # Emojicode plugin
    module Emojicode
      extend Discordrb::Commands::CommandContainer

      emojicode_config = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      command(
        :emojicode, min_args: 0,
        desc: "List of our emoji shorthand meanings",
        usage: "emojicode"
      ) do |event|
        event.channel.send_embed do |e|
          e.thumbnail = { url: emojicode_config['embed_image'] }
          e.color = emojicode_config['embed_color']
          e.title = 'Emoji Code'
          e.description = emojicode_config['emojicode']
        end
      end
    end
  end
end
