
sqlite3 -csv access_log.db 'select request,count(request) from access_log group by request order by count(request)' > total_requests.csv
sqlite3 -csv access_log.db 'select count(request_time), substr(request_time, 2, 11) from access_log group by substr(request_time, 2, 11) order by request_unixtime' > requests_per_day.csv
sqlite3 -csv access_log.db 'select count(*), substr(request_time, 14, 2) from access_log group by substr(request_time, 14, 2)' > requests_per_hour.csv
sqlite3 -csv access_log.db 'select request_time, request_unixtime, count(request_unixtime) from access_log group by request_unixtime order by count(request_unixtime)' > maximum_burst_per_second.csv
