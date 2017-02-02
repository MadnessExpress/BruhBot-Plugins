db = SQLite3::Database.new 'db/server.db'

if BruhBot.conf['first_run'] == 1 ||
   BruhBot.db_version < BruhBot.git_db_version
  db.execute('INSERT OR IGNORE INTO perms (command) VALUES (?)', 'react')
end

react_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'react'
)[0][0]
react_roles = react_string.split(',').map(&:to_i) unless react_string.nil? # else update_roles = []

db.close if db
