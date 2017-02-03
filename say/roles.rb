module Roles
  class << self
    attr_accessor :say_roles
    attr_accessor :say_channel_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version['version']
    db.execute('INSERT OR IGNORE INTO perms (command) '\
               'VALUES (?), (?)', 'say', 'say.channel')
  end

  say_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'say'
  )[0][0]
  self.say_roles = say_string.split(',').map(&:to_i) unless say_string.nil? # else update_roles = []

  say_channel_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'say.channel'
  )[0][0]
  self.say_channel_roles = say_channel_string.split(',').map(&:to_i) unless say_channel_string.nil? # else update_roles = []

  db.close if db
end
