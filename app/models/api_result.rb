class ApiResult < ActiveRecord::Base
  serialize :result_json, JSON

  belongs_to :getaway_search
end