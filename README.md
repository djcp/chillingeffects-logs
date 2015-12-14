# Chillingeffects access log parsing

## Usage

* `bundle install`
* `rm -f access_log.db && zcat access_log.*.gz | bundle exec ruby parse.rb # time passes`
* `./report.sh # less time passes, reports are created`

And then view the reports in your spreadsheet of choice.

## License

Chilling Effects is licensed under GPLv2. See LICENSE.txt for more information.

## Copyright

Copyright (c) 2013 President and Fellows of Harvard College
