module Roles
  class << self
    attr_accessor :choose_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version
    db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'choose')
  end

  choose_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'choose'
  )[0][0]
  self.choose_roles = choose_string.split(',').map(&:to_i) unless choose_string.nil?

  db.close if db
end
