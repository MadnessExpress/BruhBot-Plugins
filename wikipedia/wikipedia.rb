module BruhBot
  module Plugins
    # Wikipedia plugin
    module WikipediaPlugin
      require 'wikipedia'
      extend Discordrb::Commands::CommandContainer
      command(
        :wiki, min_args: 1,
        description: 'Look up a page on wikipedia',
        usage: 'wiki <topic>'
      ) do |event, *topic|
        page = Wikipedia.find(topic.join(' '))
        event.respond(page.fullurl)
      end
    end
  end
end
