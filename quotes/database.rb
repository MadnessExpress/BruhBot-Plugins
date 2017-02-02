db = SQLite3::Database.new 'db/server.db'

if BruhBot.conf['first_run'] == 1
  db.execute <<-SQL
    create table if not exists quotes (
      quote text,
      UNIQUE(quote)
    );
  SQL
end

query = [
  'ALTER TABLE quotes ADD COLUMN quote text, UNIQUE(quote)'
]
query.each do |q|
  begin
    db.execute(q)
  rescue SQLite3::Exception
    next
  end
end

db.close if db
