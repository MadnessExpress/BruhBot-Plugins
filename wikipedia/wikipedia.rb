module BruhBot
  module Plugins
    # Wikipedia plugin
    module WikipediaPlugin
      require 'wikipedia'
      require 'roles.rb' if BruhBot::Plugins.const_defined?(:Permissions)
      extend Discordrb::Commands::CommandContainer
      command(
        :wiki, min_args: 1,
        permitted_roles: Roles.wiki_roles,
        description: 'Look up a page on wikipedia',
        usage: 'wiki <topic>'
      ) do |event, *topic|
        page = Wikipedia.find(topic.join(' '))
        event.respond(page.fullurl)
      end
    end
  end
end
