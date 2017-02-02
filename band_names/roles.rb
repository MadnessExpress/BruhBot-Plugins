db = SQLite3::Database.new 'db/server.db'

if BruhBot.conf['first_run'] == 1 ||
   BruhBot.db_version < BruhBot.git_db_version
  db.execute(
    'INSERT OR IGNORE INTO perms (command) '\
    'VALUES (?), (?), (?)', 'band', 'band.add', 'band.remove'
  )
end

band_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'band'
)[0][0]
band_roles = band_string.split(',').map(&:to_i) unless band_string.nil? # else update_roles = []

band_add_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'band.add'
)[0][0]
band_add_roles = band_add_string.split(',').map(&:to_i) unless band_add_string.nil? # else update_roles = []

band_remove_string = db.execute(
  'SELECT roles FROM perms WHERE command = ?', 'band.add'
)[0][0]
band_remove_roles = band_remove_string.split(',').map(&:to_i) unless band_remove_string.nil? # else update_roles = []
