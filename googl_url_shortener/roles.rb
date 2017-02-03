module Roles
  class << self
    attr_accessor :short_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version['version']
    db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'short')
  end

  short_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'short'
  )[0][0]
  self.short_roles = short_string.split(',').map(&:to_i) unless short_string.nil? # else update_roles = []

  db.close if db
end
