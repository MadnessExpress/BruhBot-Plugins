module Roles
  class << self
    attr_accessor :wiki_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version['version']
    db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'wiki')
  end

  wiki_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'wiki'
  )[0][0]
  self.wiki_roles = wiki_string.split(',').map(&:to_i) unless wiki_string.nil? # else update_roles = []

  db.close if db
end
