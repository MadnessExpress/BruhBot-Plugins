module BruhBot
  module Plugins
    # Admin commands plugin
    module Admin
      extend Discordrb::Commands::CommandContainer

      # Load config file
      admin_conf = Yajl::Parser.parse(File.new("#{__dir__}/config.json", 'r'))
      ##########################################################################

      command(
        %s(bot.avatar), min_args: 1, max_args: 1,
        description: 'Update the bot\'s avatar.',
        usage: 'bot.avatar <image url>'
      ) do |event, arg|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)
        open(arg) do |f|
          File.open('avatars/bot.png', 'wb') do |file|
            file.puts f.read
          end
        end
        BruhBot.bot.profile.avatar = File.open('avatars/bot.png', 'r')
        File.delete('avatars/bot.png')
        nil
      end

      command(
        :update, min_args: 0, max_args: 0,
        description: 'Update the bot.',
        usage: 'update'
      ) do |event|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        event.respond 'Updating and restarting!'
        exec('update.sh')
      end

      command(
        :restart, min_args: 0, max_args: 0,
        description: 'Restart the bot.',
        usage: 'restart'
      ) do |event|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        event.respond 'Restarting!'
        exec("#{File.expand_path File.dirname(__FILE__)}/update.sh restart")
      end

      command(
        :shutdown,
        help_available: false
      ) do |event|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        event.respond admin_conf['shutdownmessage'].sample
        event.bot.stop
      end

      command(
        %s(nick.user), min_args: 2,
        description: 'Change a user\'s nickname.',
        usage: 'nick <user id> <text>'
      ) do |event, userid, *nick|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        nick = nick.join(' ')
        event.bot.member(event.server.id, userid).nick = nick
        nil
      end

      command(
        :game, min_args: 1,
        description: 'sets bot game'
      ) do |event, *game|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        event.bot.game = game.join(' ')
        nil
      end

      command(
        :clear, min_args: 1, max_args: 1,
        description: 'Prune X messages from channel'
      ) do |event, number|
        break if (BruhBot.conf['server_protection'] == 1) &&
                 (!BruhBot.conf['owners'].include? event.user.id)

        event.message.delete
        break event.respond('Please enter a valid number.') if /\A\d+\z/.match(number).nil?
        event.channel.prune(number.to_i)
        stuff = event.respond("[#{number.to_i}] messages cleared.").id
        sleep 5
        event.channel.load_message(stuff).delete
      end

      command(
        :roles, min_args: 0, max_args: 0,
        description: 'Get info on all the roles on the server.'
      ) do |event|
        roles = event.server.roles
        output = '```'
        roles.each do |role|
          output += "Name:#{role.name}, ID:#{role.id}, "\
                    "Permissions:#{role.permissions.bits}\n"
          next if output.length < 1800
          output += '```'
          event.user.pm(output)
          output = '```'
        end
        output += '```'
        event.user.pm(output)
        nil
      end
    end
  end
end
