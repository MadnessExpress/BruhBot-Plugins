module Roles
  class << self
    attr_accessor :play_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version
    db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'play')
  end

  play_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'play'
  )[0][0]
  self.play_roles = play_string.split(',').map(&:to_i) unless play_string.nil?

  db.close if db
end
