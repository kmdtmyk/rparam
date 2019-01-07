# frozen_string_literal: true

class User < ApplicationRecord
  has_many :controller_parameters, as: :parent
end
