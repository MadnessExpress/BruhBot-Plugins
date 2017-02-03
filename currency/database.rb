db = SQLite3::Database.new 'db/server.db'
if BruhBot.conf['first_run'] == 1
  db.execute <<-SQL
    create table if not exists currency (
      userid int,
      amount int,
      UNIQUE(userid)
    );
  SQL
end

query = [
  'ALTER TABLE currency ADD COLUMN userid int, UNIQUE(userid)',
  'ALTER TABLE currency ADD COLUMN amount int'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

db.close if db
