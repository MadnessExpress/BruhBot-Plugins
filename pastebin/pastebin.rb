module BruhBot
  module Plugins
    # Pastebin plugin
    module Paste
      require 'pastebin-api'
      require_relative 'roles.rb' if BruhBot::Plugins.const_defined?(:Permissions)
      extend Discordrb::Commands::CommandContainer

      command(
        :paste, min_args: 1,
        permitted_roles: Roles.paste_roles,
        description: 'Creates a Pastebin paste with the specified text.',
        usage: 'paste <text>'
      ) do |event, *text|
        pastebin = Pastebin::Client.new(BruhBot.api['pastebin_api_key'])
        event.respond pastebin.newpaste(text.join(' '))
      end
    end
  end
end
