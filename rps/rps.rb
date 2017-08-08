module BruhBot
  module Plugins
    # Rock paper scissors plugin
    module Rps
      extend Discordrb::Commands::CommandContainer

      # Load config file
      rps_config = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      command(
        :rps, min_args: 1,
        description: 'Play rock, paper, scissors with the bot.',
        usage: 'rps rock, rps paper, or rps scissors'
      ) do |event|
        # Output a message with a randomly selected message from the config and
        # insert a random option from the config.
        event.respond rps_config['messages'].sample % {
          option: rps_config['options'].sample
        }
      end
    end
  end
end
