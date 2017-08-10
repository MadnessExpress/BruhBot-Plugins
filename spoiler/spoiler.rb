module BruhBot
  module Plugins
    # Choose plugin
    module Spoiler
      extend Discordrb::Commands::CommandContainer

      command(
        :spoiler, min_args: 1,
        description: 'Create a spoiler for entered text',
        usage: 'choose <spoiler name> :: <spoiler text>'
      ) do |event, *args|
        # Create an image with text
        textarray = args.join(' ').split('::')
        break event.respond 'Command usage: ``` !spoiler Harry Potter :: Hagrid is a giant ```' if textarray[0] == nil || textarray[1] == nil

        name = textarray[0]
        text = "(Hover to reveal #{name} spoiler)"
        text2 = textarray[1]

        text = reformat_wrapped(text, 60)
        text2 = reformat_wrapped(text2, 60)

        createSpoiler(text, text2, event.message.id)

        event.channel.send_file File.open("images/spoiler/#{event.message.id}.gif")
        File.delete("images/spoiler/#{event.message.id}.gif")
        nil
      end
    end
  end
end
