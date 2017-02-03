module Roles
  class << self
    attr_accessor :perm_roles
    attr_accessor :perm_list_roles
    attr_accessor :perm_add_roles
    attr_accessor :perm_remove_roles
  end

  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version['version']
    db.execute('INSERT OR IGNORE INTO perms (command) '\
               'VALUES (?), (?), (?), (?)', 'perm',\
               'perm.list', 'perm.add', 'perm.remove')
  end

  perm_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'perm'
  )[0][0]
  self.perm_roles = perm_string.split(',').map(&:to_i) unless perm_string.nil? # else update_roles = []

  perm_list_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'perm.list'
  )[0][0]
  self.perm_list_roles = perm_list_string.split(',').map(&:to_i) unless perm_list_string.nil? # else update_roles = []

  perm_add_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'perm.add'
  )[0][0]
  self.perm_add_roles = perm_add_string.split(',').map(&:to_i) unless perm_add_string.nil? # else update_roles = []

  perm_remove_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'perm.remove'
  )[0][0]
  self.perm_remove_roles = perm_remove_string.split(',').map(&:to_i) unless perm_remove_string.nil? # else update_roles = []

  db.close if db
end
