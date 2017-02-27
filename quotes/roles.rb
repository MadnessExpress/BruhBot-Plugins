module Roles
  class << self
    attr_accessor :quote_roles
    attr_accessor :quote_add_roles
    attr_accessor :quote_remove_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version
     db.execute('INSERT OR IGNORE INTO perms (command) '\
                'VALUES (?), (?), (?)', 'quote', 'quote.add', 'quote.remove')
  end

  quote_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'quote'
  )[0][0]
  self.quote_roles = quote_string.split(',').map(&:to_i) unless quote_string.nil?

  quote_add_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'quote.add'
  )[0][0]
  self.quote_add_roles = quote_add_string.split(',').map(&:to_i) unless quote_add_string.nil?

  quote_remove_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'quote.remove'
  )[0][0]
  self.quote_remove_roles = quote_remove_string.split(',').map(&:to_i) unless quote_remove_string.nil?

  db.close if db
end
