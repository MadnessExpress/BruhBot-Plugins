db = SQLite3::Database.new 'db/server.db'
db.execute <<-SQL
  create table if not exists bandnames (
    name text,
    genre text,
    addedby int,
    UNIQUE(name)
  );
SQL

query = [
  'ALTER TABLE bandnames ADD COLUMN name text, UNIQUE(name)',
  'ALTER TABLE bandnames ADD COLUMN genre text',
  'ALTER TABLE bandnames ADD COLUMN addedby int'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

db.execute(
  'INSERT OR IGNORE INTO perms (command) '\
  'VALUES (?), (?), (?)', 'band', 'band.add', 'band.remove'
)
db.close if db
