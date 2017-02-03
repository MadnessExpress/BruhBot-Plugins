module Roles
  class << self
    attr_accessor :avatar_roles
    attr_accessor :avatar_server_roles
  end

  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version
    db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'avatar', 'avatar.server')
  end

  avatar_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'avatar'
  )[0][0]
  self.avatar_roles = avatar_string.split(',').map(&:to_i) unless avatar_string.nil? # else update_roles = []

  avatar_server_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'avatar.server'
  )[0][0]
  self.avatar_server_roles = avatar_server_string.split(',').map(&:to_i) unless avatar_server_string.nil? # else update_roles = []
end
