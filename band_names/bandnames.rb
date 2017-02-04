module BruhBot
  module Plugins
    # Band names plugin
    module BandNames
      extend Discordrb::Commands::CommandContainer

      if BruhBot.conf['first_run'] == 1 ||
         BruhBot.db_version < BruhBot.git_db_version['version']
        require "#{__dir__}/database.rb"
      end
      require_relative 'roles.rb' if BruhBot::Plugins.const_defined?(:Permissions)

      bandnames_config = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      command(
        :band, min_args: 0,
        permitted_roles: Roles.band_roles,
        description: 'Display a random band name.',
        usage: 'band'
      ) do |event|

        # Load database
        db = SQLite3::Database.new 'db/server.db'
        rows = db.execute('SELECT name, genre, addedby FROM bandnames')
        db.close if db

        output = rows.sample unless rows == []
        output = 'There are no bands.' unless rows != []
        user = event.bot.member(event.server.id, event.user.id).display_name
        response = "#{output[0]} is #{user}'s new band name." if output[1].nil? || output.empty?
        response = "#{output[0]} is #{user}'s new #{output[1]} band name." unless output[1].nil? || output.empty?

        if output[2].to_s.numeric?
          creator = event.bot.member(event.server.id, output[2].to_i).display_name
        else
          creator = output[2]
        end

        event.channel.send_embed do |e|
          e.thumbnail = { url: bandnames_config['embed_image'] }
          e.add_field name: 'Band Name:', value: response, inline: false
          e.add_field name: 'Creator:',
                      value: creator,
                      inline: true
          e.color = bandnames_config['embed_color']
        end
      end

      command(
        %s(band.add), min_args: 1,
        permitted_roles: Roles.band_add_roles,
        description: 'Add a band name to the database.',
        usage: 'band add <text> :: optional<genre> :: optional<plaintext added by name>'
      ) do |event, *text|
        event.message.delete

        textarray = text.join(' ').split('::')
        band = textarray[0].strip
        genre = textarray[1].strip unless textarray[1].nil? || textarray[1] == ' '
        genre = nil if textarray[1].nil? || textarray[1] == ' '
        user = textarray[2].strip unless textarray[2].nil?
        user = event.user.id if textarray[2].nil?

        puts band
        puts genre
        puts user
        # Load database
        db = SQLite3::Database.new 'db/server.db'

        begin
          db.execute(
            'INSERT INTO bandnames (name, genre, addedby) '\
            'VALUES (?, ?, ?)', band, genre, user
          )
        rescue SQLite3::Exception
          event.respond 'That band name already exists.'
          break
        end
        db.close if db

        genre = 'N/A' if genre.nil?

        event.channel.send_embed do |e|
          e.thumbnail = { url: bandnames_config['embed_image'] }
          e.description = 'The following band was added to the database:'
          e.add_field name: 'Band:', value: band, inline: false
          e.add_field name: 'Genre:', value: genre, inline: true
          e.add_field name: 'Added By:', value: user,
                      inline: true
          e.color = bandnames_config['embed_color']
        end
      end

      command(
        %s(band.remove), min_args: 1,
        permitted_roles: Roles.band_remove_roles,
        description: 'Remove a band from your quote database.',
        usage: 'band.remove <text>'
      ) do |event, *text|
        event.message.delete

        db = SQLite3::Database.new 'db/server.db'
        check = db.execute('SELECT count(*) FROM bandnames '\
                           'WHERE name = ?', [text.join(' ')])[0][0]
        break event.respond 'That band doesn\'t exist.' unless check == 1

        db.execute('DELETE FROM bandnames WHERE name = ?', [text.join(' ')])
        db.close if db

        event.channel.send_embed do |e|
          e.thumbnail = { url: bandnames_config['embed_image'] }
          e.description = 'The following band name '\
                          'was removed from the database:'
          e.add_field name: 'Band Name:', value: text.join(' '), inline: false
          e.add_field name: 'Removed By:', value: event.user.display_name,
                      inline: false
          e.color = bandnames_config['embed_color']
        end
      end
    end
  end
end
