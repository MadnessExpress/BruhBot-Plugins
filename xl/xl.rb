module BruhBot
  module Plugins
    # IGNO xL plugin
    module WhoIsXl
      extend Discordrb::Commands::CommandContainer

      if File.exists?("#{__dir__}/xlnames.json")
        xlnames = Yajl::Parser.parse(
          File.new("#{__dir__}/xlnames.json", 'r')
        )
      end

      xl_config = Yajl::Parser.parse(
        File.new("#{__dir__}/config.json", 'r')
      )

      command(
        :xl, min_args: 0,
        desc: 'What is xL\'s nickname today.',
        usage: 'xl'
      ) do |event|
        names = {}
        names = Hash[xlnames.sort_by { |k, _v| -k.to_i }[0..3]] unless File.exist?('plugins/xl/xlnames.json') == false
        names.shift
        names.store(:filler1, 'N/A')
        names.store(:filler2, 'N/A')
        names.store(:filler3, 'N/A')

        event.channel.send_embed do |e|
          e.thumbnail = { url: xl_config['embed_image'] }
          e.description = 'Below are xL\'s nicknames:'
          e.add_field name: 'Current Nickname:',\
                      value: event.bot.user(124_708_842_335_502_338).on(event.server.id).display_name,\
                      inline: false
          e.add_field name: 'Previous Nickname 1:', value: names.values[0],\
                      inline: false
          e.add_field name: 'Previous Nickname 2:', value: names.values[1],\
                      inline: false
          e.add_field name: 'Previous Nickname 3:', value: names.values[2],\
                      inline: false
          e.color = xl_config['embed_color']
        end
      end

      command(
        %s(xl.nick), min_args: 1,
      ) do |event, *xlnick|
        break event.respond 'Nice try xL' if event.user.id == 124_708_842_335_502_338
        nickname = xlnick.join(' ')
        event.bot.member(event.server.id, 124_708_842_335_502_338).nick = nickname
        time = Time.new
        nicktime = time.strftime('%Y%m%d%H%M%S')

        xlnames[nicktime] = nickname unless File.exist?('plugins/xl/xlnames.json') == false
        xlnames = { nicktime: nickname } unless File.exist?('plugins/xl/xlnames.json')

        Yajl::Encoder.encode(
          xlnames, [File.new("#{__dir__}/xlnames.json", 'w'), {
            pretty: true, indent: '\t'
          }]
        )
        nil
      end
    end
  end
end
