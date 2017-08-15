module BruhBot
  module Plugins
    # Plugin to make the bot say stuff
    module Music
      extend Discordrb::Commands::CommandContainer

      queue = {}

      command(
        :join,
        description: 'Make the bot join your audio channel',
        usage: 'join'
      ) do |event|
        event.message.delete
        channel = event.user.voice_channel
        event.respond 'I have joined a voice channel'
        # Check if channel is valid.
        if !channel || channel == event.server.afk_channel
          next 'First join a valid voice channel.'
        end

        # Try to join the voice channel.
        begin
          event.bot.voice_connect(channel)
          event.voice.encoder.use_avconv = true
        rescue Discordrb::Errors::NoPermission
          next 'Please make sure I have permission to join this channel.'
        end
        nil
      end

      command(
        :leave,
        description: 'Leave a voice channel.',
        usage: 'leave'
      ) do |event|
        event.message.delete
        event.respond 'Leaving voice.'
        server = event.server.id
        event.bot.voice_destroy(server)
        nil
      end

      command(
        :add, min_args: 2,
        description: 'Add a song to the queue',
        usage: 'add <song name> <url>'
      ) do |event, *name, url|
        break event.respond 'Please give the file a name.' if name.blank?
        event.message.delete
        songname = name.join(' ')
        path = ''

        if url.include? '.mp3'
          path = url
        elsif url.include? 'youtube'
          path = "data/#{event.server.id}/music/#{event.message.id}.mp3"
          addYoutube(event.server.id, event.message.id, url)
        end

        if !queue.has_key? event.server.id
          queue[event.server.id] = {}
        end

        queue[event.server.id].store(songname, path)

        event.respond songname + ' was added to the queue'
        nil
      end

      command(
        :start,
        description: 'Start the music.',
        usage: 'start'
      ) do |event|
        event.message.delete

        while !queue[event.server.id].empty?
          event.respond 'Now playing ' + queue[event.server.id].keys[0]
          event.voice.play_file(queue[event.server.id].values[0])
          if queue[event.server.id].values[0] != nil && File.exists?(queue[event.server.id].values[0])
            File.delete(queue[event.server.id].values[0])
          end
          queue[event.server.id].shift
        end

        event.voice.speaking = false
        nil
      end

      command(
        :stop,
        description: 'Stop the music.',
        usage: 'stop'
      ) do |event|
        event.message.delete
        event.respond 'Music stopping'
        queue[event.server.id] = {}
        event.voice.stop_playing(wait_for_confirmation = false)
        event.voice.speaking = false
        manageMusic(event.server.id)
      end

      command(
        :skip,
        description: 'Skip to the next song',
        usage: 'skip'
      ) do |event|
        event.message.delete
        if event.voice.playing?
          event.voice.stop_playing
          event.respond 'Skipping to the next song.'
        else
          event.respond 'Nothing is playing'
        end
        nil
      end
    end
  end
end
