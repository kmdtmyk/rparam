# Rparam

## Usage

```ruby
class AccessLogsController < ApplicationController
  before_action :apply_rparam

  def index
    @access_logs = AccessLog.where(date: params[:date])
      .where(level: params[:level])
      .order(created_at: params[:order])
  end

end
```

```ruby
class AccessLogsParameter < Rparam::Parameter

  def index
    param :date, type: Date, default: Time.zone.today
    param :level, type: Array ,save: true, default: %w(debug info error)
    param :order, save: true,  inclusion: %w(asc desc), default: 'desc'
  end

end
```

## Installation

```ruby
gem 'rparam', git: 'https://github.com/kmdtmyk/rparam', tag: '<tag_name>'
```

or

```ruby
gem 'rparam', git: 'https://github.com/kmdtmyk/rparam', ref: '<commit_hash>'
```

This saves parameters to cookie or database. Cookie is used as default. If you want to use database, please execute below.

```bash
rails g rparam:install
rails db:migrate
```

```ruby
class User < ApplicationRecord
  acts_as_rparam_user
end
```

## Test

```
docker-compose run --rm app bash
cd test/dummy
rspec
```

## License

MIT
