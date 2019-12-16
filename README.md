[![Test](https://github.com/kmdtmyk/rparam/workflows/Test/badge.svg)](https://github.com/kmdtmyk/rparam/actions)

# Rparam

## Usage

app/parameters/sample_parameter.rb

```ruby
class SampleParameter < Rparam::Parameter

  def index
    param :date, type: Date
    param :per_page, type: Integer, min: 1, max: 100
    param :order, inclusion: %w(asc desc), default: 'asc'
  end

end
```

app/controllers/sample_controller.rb

```ruby
class SampleController < ApplicationController
  before_action :apply_rparam
end
```

```ruby
# GET /sample?date=2019-05-15&per_page=1000&order=foo
params[:date]
# => Wed, 15 May 2019
params[:per_page]
# => 100
params[:order]
# => "asc"
```

### Option

|name|description|example|
|-|-|-|
|type|Declar parameter type.|Integer, Array, Date|
|inclusion|Accept only specified value.|%w(asc desc)|
|exclusion|Reject specified value.|%w(foo bar)|
|min|Set minimum value.|0|
|max|Set maximum value.|100|
|default|Set default value if parameter is nil.|10, Time.zone.today|
|save|Save parameter and restore it if parameter is nil.|true, :relative_date, :relative_month, :relative_year|

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
BUNDLE_GEMFILE=gemfiles/6.0.gemfile bundle exec rspec
BUNDLE_GEMFILE=gemfiles/5.2.gemfile bundle exec rspec
```

## License

MIT
