module BruhBot
  module Plugins
    # Band names plugin
    module Poll
      extend Discordrb::Commands::CommandContainer
      require 'timeout'

      command(
        :poll, min_args: 2,
        description: 'Start a poll.',
        usage: 'poll <time in minutes> <question> :: <option 1> :: <option 2>'
      ) do |event, time, *text|
        break event.respond 'Please enter a valid number' if !time.numeric?
        event.message.delete
        options = text.join(' ').split('::')
        time = time.to_i * 60
        db = SQLite3::Database.new "db/#{event.server.id}.db"
        started = db.execute('SELECT started FROM poll WHERE id=1')
        db.close if db

        if started != 1
          question = options[0]
          options.shift
          break event.respond 'No options.' if options.blank?
          optionslist = ''
          optionslist << 'POLL: ' + question + "\n\n"

          x = 1
          db = SQLite3::Database.new "db/#{event.server.id}.db"
          options.each do |option|
            db.execute(
              'INSERT INTO poll (id, option, votes) '\
              'VALUES (?, ?, ?)', x, option, 0
            )
            optionslist << x.to_s + '. ' + option + "\n"
            x = x + 1
          end

          db.execute(
            'UPDATE poll SET started = 1, poll_time = ?, elapsed_time = 0, channel_id = ? '\
            'WHERE id = 1', time, event.channel.id
          )
          db.close if db
          event.respond optionslist
          pollLoop(event.server.id)
        else
          event.respond 'Poll is already in progress.'
        end
        nil
      end

      command(
        %s(poll.vote), min_args: 1,
        description: 'Vote for a poll option.',
        usage: 'poll.vote <option number>'
      ) do |event, option|
        event.message.delete
        started = ''
        begin
          db = SQLite3::Database.new "db/#{event.server.id}.db"
          started = db.execute('SELECT started FROM poll WHERE id=1')[0][0].to_i
          break event.respond 'There is no poll running.' if started != 1
          db.close if db
        rescue NoMethodError
          db.close if db
          break event.respond 'There is no poll running.'
        end
        db = SQLite3::Database.new "db/#{event.server.id}.db"
        max_option = db.execute('SELECT MAX(id) FROM poll')[0][0].to_i + 1
        voted = db.execute('SELECT voted FROM poll_voters WHERE userid=(?)', event.user.id)
        db.close if db
        break event.respond 'Please enter a valid option.' if option.to_i >= max_option || option.to_i < 0
        break event.respond 'Please enter a valid number' if !option.numeric?

        if started == 1 && voted[0].nil?
          db = SQLite3::Database.new "db/#{event.server.id}.db"
          db.execute('UPDATE poll SET votes = votes + 1 WHERE id = ?', option)
          db.execute(
            'INSERT OR IGNORE INTO poll_voters (userid, voted)'\
            'VALUES (?, ?)', event.user.id, 1
          )
          db.close if db
        elsif voted == 1
          event.respond 'You already voted.'
        end
        nil
      end

      command(
        %s(poll.end),
        description: 'End the poll',
        usage: 'poll.end'
      ) do |event|
        db = SQLite3::Database.new "db/#{event.server.id}.db"
        poll_time = db.execute('SELECT poll_time FROM poll WHERE id = 1')
        db.execute('UPDATE poll SET elapsed_time = ? WHERE id = 1', poll_time)
        db.close if db
        nil
      end

    end
  end
end
