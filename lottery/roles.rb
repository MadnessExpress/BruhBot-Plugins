module Roles
  class << self
    attr_accessor :lotto_start_roles
    attr_accessor :lotto_enter_roles
    attr_accessor :lotto_end_roles
    attr_accessor :lotto_kill_roles
  end
  db = SQLite3::Database.new 'db/server.db'

  if BruhBot.conf['first_run'] == 1 ||
     BruhBot.db_version < BruhBot.git_db_version
    db.execute('INSERT OR IGNORE INTO perms (command) '\
               'VALUES (?), (?), (?), (?)', 'lotto.start', 'lotto.enter',
               'lotto.end', 'lotto.kill')
  end

  lotto_start_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'lotto.start'
  )[0][0]
  self.lotto_start_roles = lotto_start_string.split(',').map(&:to_i) unless lotto_start_string.nil?

  lotto_enter_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'lotto.enter'
  )[0][0]
  self.lotto_enter_roles = lotto_enter_string.split(',').map(&:to_i) unless lotto_enter_string.nil?

  lotto_end_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'lotto.end'
  )[0][0]
  self.lotto_end_roles = lotto_end_string.split(',').map(&:to_i) unless lotto_end_string.nil?

  lotto_kill_string = db.execute(
    'SELECT roles FROM perms WHERE command = ?', 'lotto.kill'
  )[0][0]
  self.lotto_kill_roles = lotto_kill_string.split(',').map(&:to_i) unless lotto_kill_string.nil?

  db.close if db
end
