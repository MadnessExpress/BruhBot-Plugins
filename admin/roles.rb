module Roles
  class << self
    attr_accessor :update_roles
    attr_accessor :restart_roles
    attr_accessor :shutdown_roles
    attr_accessor :nick_roles
    attr_accessor :nick_user_roles
    attr_accessor :game_roles
    attr_accessor :clear_roles
    attr_accessor :roles_roles
  end

  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version['version']
    db.execute(
      'INSERT OR IGNORE INTO perms (command) '\
      'VALUES (?), (?), (?), (?), (?), (?), (?), (?)',
      'update', 'restart', 'shutdown', 'nick',
      'nick.user', 'game', 'clear', 'roles'
    )
  end

  update_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'update'
  )[0][0]
  self.update_roles = update_string.split(',').map(&:to_i) unless update_string.nil? # else update_roles = []

  restart_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'restart'
  )[0][0]
  self.restart_roles = restart_string.split(',').map(&:to_i) unless restart_string.nil? # else shutdown_roles = []

  shutdown_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'shutdown'
  )[0][0]
  self.shutdown_roles = shutdown_string.split(',').map(&:to_i) unless shutdown_string.nil? # else shutdown_roles = []

  nick_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'nick'
  )[0][0]
  self.nick_roles = nick_string.split(',').map(&:to_i) unless nick_string.nil? # else shutdown_roles = []

  nick_user_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'nick.user'
  )[0][0]
  self.nick_user_roles = nick_user_string.split(',').map(&:to_i) unless nick_user_string.nil? # else shutdown_roles = []

  game_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'game'
  )[0][0]
  self.game_roles = game_string.split(',').map(&:to_i) unless game_string.nil? # else shutdown_roles = []

  clear_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'clear'
  )[0][0]
  self.clear_roles = clear_string.split(',').map(&:to_i) unless clear_string.nil? # else shutdown_roles = []

  roles_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'roles'
  )[0][0]
  self.roles_roles = roles_string.split(',').map(&:to_i) unless roles_string.nil? # else shutdown_roles = []

  db.close if db
end
