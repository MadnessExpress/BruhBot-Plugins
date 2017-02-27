module Roles
  class << self
    attr_accessor :rate_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version
    db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'rate')
  end

  rate_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'rate'
  )[0][0]
  self.rate_roles = rate_string.split(',').map(&:to_i) unless rate_string.nil?

  db.close if db
end
