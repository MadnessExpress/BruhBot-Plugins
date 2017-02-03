module BruhBot
  module Plugins
    # Rate plugin
    module Rate
      require_relative 'roles.rb' if BruhBot::Plugins.const_defined?(:Permissions)
      extend Discordrb::Commands::CommandContainer

      command(
        :rate, min_args: 1,
        permitted_roles: Roles.rate_roles,
        description: 'Rate things!',
        usage: 'rate <stuff>'
      ) do |event, *text|
        event.respond "I give #{text.join(' ')} a "\
                      "#{rand(0.0..10.0).round(1)}/10.0!"
      end
    end
  end
end
