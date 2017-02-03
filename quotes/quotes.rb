module BruhBot
  module Plugins
    # Quotes Plugin
    module Quotes
      require_relative 'roles.rb' if BruhBot::Plugins.const_defined?(:Permissions)
      if BruhBot.conf['first_run'] == 1 ||
         BruhBot.db_version < BruhBot.git_db_version['version']
        require "#{__dir__}/database.rb"
      end

      # Load config file
      quotes_config = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      extend Discordrb::Commands::CommandContainer

      command(
        :quote, max_args: 0,
        permitted_roles: Roles.quote_roles,
        description: 'Output a random quote, or manage quotes.',
        usage: 'quote'
      ) do |event|
        # Load database
        db = SQLite3::Database.new 'db/server.db'
        rows = db.execute('SELECT quote FROM quotes')
        db.close if db

        output = rows.sample.sample.to_s unless rows.empty?
        output = 'There are no quotes.' if rows.empty?

        event.channel.send_embed do |e|
          e.thumbnail = { url: quotes_config['embed_image'] }
          e.add_field name: 'Quote:', value: output, inline: true
          e.color = quotes_config['embed_color']
        end
      end

      command(
        %s(quote.add), min_args: 1,
        permitted_roles: Roles.quote_add_roles,
        description: 'Add a quote to your quote database.',
        usage: 'quote.add <text>'
      ) do |event, *text|
        event.message.delete

        begin
          db = SQLite3::Database.new 'db/server.db'
          db.execute('INSERT INTO quotes (quote) VALUES (?)', [text.join(' ')])
          db.close if db
        rescue SQLite3::Exception => e
          event.respond 'That quote already exists.'
          break
        end

        event.channel.send_embed do |embed|
          embed.thumbnail = { url: quotes_config['embed_image'] }
          embed.description = 'The following quote was added to the database:'
          embed.add_field name: 'Quote:', value: text.join(' '), inline: false
          embed.add_field name: 'Added By:', value: event.user.mention,\
                          inline: false
          embed.color = quotes_config['embed_color']
        end
      end

      command(
        %s(quote.remove), min_args: 1,
        permitted_roles: Roles.quote_remove_roles,
        description: 'Remove a quote from your quote database.',
        usage: 'quote.remove <text>'
      ) do |event, *text|
        event.message.delete

        db = SQLite3::Database.new 'db/server.db'
        check = db.execute('SELECT count(*) FROM quotes '\
                           'WHERE quote = ?', text.join(' '))[0][0]
        break event.respond 'That quote doesn\'t exist.' unless check == 1

        db.execute('DELETE FROM quotes WHERE quote = ?', [text.join(' ')])
        db.close if db

        event.channel.send_embed do |e|
          e.thumbnail = { url: quotes_config['embed_image'] }
          e.description = 'The following quote was removed from the database:'
          e.add_field name: 'Quote:', value: text.join(' '), inline: false
          e.add_field name: 'Removed By:', value: event.user.mention,\
                      inline: false
          e.color = quotes_config['embed_color']
        end
      end
    end
  end
end
