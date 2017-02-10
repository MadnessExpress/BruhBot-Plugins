module BruhBot
  module Plugins
    # Wikipedia plugin
    module Tnotifications
      require 'kappa'
      extend Discordrb::EventContainer

      twitch_notifications_config = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      Twitch.configure do |config|
        config.client_id = BruhBot.api['twitch']
      end

      chanid = twitch_notifications_config['notification_channel']
      servid = twitch_notifications_config['notification_server']
      streaming = []

      BruhBot.bot.ready do |event|
        loop do
          twitch_notifications_config['users'].each do |u|
            user = Twitch.channels.get(u)
            stream = user.streaming?
            msg = ''
            game = 'N/A'
            channel = 'N/A'
            puts stream

            if user.streaming? &&
               !streaming.include?(u)
              streaming += [u]
              msg = 'A live stream has begun.'
              embed_image = twitch_notifications_config['stream_on_image']
              game = user.stream.game_name unless user.stream.game_name.empty?
              channel = user.stream.url
            elsif !user.streaming? &&
                  streaming.include?(u)
              streaming -= [u]
              msg = 'A live stream has ended.'
              embed_image = twitch_notifications_config['stream_off_image']
            end

            if msg != ''
              BruhBot.bot.channel(chanid, server = servid).send_embed do |e|
                e.thumbnail = {
                  url: embed_image
                }
                e.title = 'Twitch Stream'
                e.description = msg
                e.add_field name: 'Streamer:', value: u, inline: false
                e.add_field name: 'Game:', value: game,
                            inline: true
                e.add_field name: 'Channel:',
                            value: channel,
                            inline: true
                e.color = twitch_notifications_config['embed_color']
              end
            end
          end
          sleep twitch_notifications_config['check_interval']
        end
      end
    end
  end
end
