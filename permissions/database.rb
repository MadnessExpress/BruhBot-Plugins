db = SQLite3::Database.new 'db/server.db'

if BruhBot.conf['first_run'] == 1
  db.execute <<-SQL
    create table if not exists perms (
      command text,
      roles text,
      UNIQUE(command)
    );
  SQL
end

query = [
  'ALTER TABLE perms ADD COLUMN command text, UNIQUE(command)',
  'ALTER TABLE perms ADD COLUMN roles text'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

db.close if db
