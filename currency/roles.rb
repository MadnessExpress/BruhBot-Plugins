db = SQLite3::Database.new 'db/server.db'

if BruhBot.conf['first_run'] == 1 ||
   BruhBot.db_version < BruhBot.git_db_version
  db.execute('INSERT OR IGNORE INTO perms (command) '\
             'VALUES (?), (?), (?)', 'money', 'money.give', 'money.add')
end

money_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'money'
)[0][0]
money_roles = money_string.split(',').map(&:to_i) unless money_string.nil? # else update_roles = []

money_give_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'money.give'
)[0][0]
money_give_roles = money_give_string.split(',').map(&:to_i) unless money_give_string.nil? # else update_roles = []

money_add_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'money.add'
)[0][0]
money_add_roles = money_add_string.split(',').map(&:to_i) unless money_add_string.nil? # else update_roles = []

db.close if db
