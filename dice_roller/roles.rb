module Roles
  class << self
    attr_accessor :roll_roles
    attr_accessor :roll_mod_roles
    attr_accessor :roll_fudge_roles
    attr_accessor :coin_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version
    db.execute('INSERT OR IGNORE INTO perms (command) '\
               'VALUES (?), (?), (?), (?)', 'roll', 'roll.mod', 'roll.fudge', 'coin')
  end

  roll_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'roll'
  )[0][0]
  self.roll_roles = roll_string.split(',').map(&:to_i) unless roll_string.nil? # else update_roles = []

  roll_mod_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'roll.mod'
  )[0][0]
  self.roll_mod_roles = roll_mod_string.split(',').map(&:to_i) unless roll_mod_string.nil? # else update_roles = []

  roll_fudge_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'roll.fudge'
  )[0][0]
  self.roll_fudge_roles = roll_fudge_string.split(',').map(&:to_i) unless roll_fudge_string.nil? # else update_roles = []

  coin_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'coin'
  )[0][0]
  self.coin_roles = coin_string.split(',').map(&:to_i) unless coin_string.nil? # else update_roles = []

  db.close if db
end
