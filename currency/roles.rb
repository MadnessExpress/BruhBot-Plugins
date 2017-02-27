module Roles
  class << self
    attr_accessor :money_roles
    attr_accessor :money_give_roles
    attr_accessor :money_add_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version
    db.execute('INSERT OR IGNORE INTO perms (command) '\
               'VALUES (?), (?), (?)', 'money', 'money.give', 'money.add')
  end

  money_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'money'
  )[0][0]
  self.money_roles = money_string.split(',').map(&:to_i) unless money_string.nil?

  money_give_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'money.give'
  )[0][0]
  self.money_give_roles = money_give_string.split(',').map(&:to_i) unless money_give_string.nil?

  money_add_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'money.add'
  )[0][0]
  self.money_add_roles = money_add_string.split(',').map(&:to_i) unless money_add_string.nil?

  db.close if db
end
