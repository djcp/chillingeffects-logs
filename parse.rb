require 'rubygems'
require 'apachelogregex'
require 'sqlite3'
require 'time'

# LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined

db = SQLite3::Database.new "access_log.db"
format = '%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"'
parser = ApacheLogRegex.new(format)

mapping = {
  :remote_host => '%h',
  :logname => '%',
  :remote_user => '%u',
  :request_time => '%t',
  :request => '%r',
  :status => '%>s',
  :bytes => '%O',
  :referer => '%{Referer}i',
  :user_agent => '%{User-Agent}i',
  :request_unixtime => 'request_unixtime'
}

insert_rows = mapping.keys.sort.join(',')
insert_placeholders = mapping.keys.map{|foo| '?'}.join(',')

db.execute(%Q|
create table access_log(
  remote_host text,
  logname text,
  remote_user text,
  request_time text,
  request_unixtime integer,
  request text,
  status integer,
  bytes integer,
  referer text,
  user_agent text
);|)


def time_to_unixtime(time)
  Time.parse(time.sub(':',' ')).to_i
end

insert = db.prepare("insert into access_log(#{insert_rows}) values(#{insert_placeholders})")

count = 0
$stdin.each do |line|
  db.transaction if ! db.transaction_active?
  begin
    hash = parser.parse(line)
    hash['request_unixtime'] = time_to_unixtime(hash[mapping[:request_time]])
    insert.execute(mapping.keys.sort.map{|col| hash[mapping[col]]})
    count = count + 1
  rescue Exception => e
    puts "Failed! #{e.inspect}"
    puts line
  end
  if count % 10000 == 0
    puts "#{count} lines imported"
    db.commit
  end
end

if db.transaction_active?
  db.commit
end
