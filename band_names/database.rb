db = SQLite3::Database.new 'db/server.db'

if BruhBot.conf['first_run'] == 1
  db.execute <<-SQL
    create table if not exists bandnames (
      name text,
      genre text,
      addedby int,
      UNIQUE(name)
    );
  SQL
end

query = [
  'ALTER TABLE bandnames ADD COLUMN name text, UNIQUE(name)',
  'ALTER TABLE bandnames ADD COLUMN genre text',
  'ALTER TABLE bandnames ADD COLUMN addedby text'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

db.close if db
