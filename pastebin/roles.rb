module Roles
  class << self
    attr_accessor :paste_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version['version']
    db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'paste')
  end

  paste_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'paste'
  )[0][0]
  self.paste_roles = paste_string.split(',').map(&:to_i) unless paste_string.nil? # else update_roles = []

  db.close if db
end
