db = SQLite3::Database.new 'db/server.db'

if BruhBot.conf['first_run'] == 1
  db.execute <<-SQL
      create table if not exists levels (
        userid int,
        level int,
        xp int,
        UNIQUE(userid)
      );
  SQL
end

query = [
  'ALTER TABLE levels ADD COLUMN userid int, UNIQUE(userid)',
  'ALTER TABLE levels ADD COLUMN level int',
  'ALTER TABLE levels ADD COLUMN xp int'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

db.close if db
