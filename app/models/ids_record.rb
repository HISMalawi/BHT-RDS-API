# frozen_string_literal: true

class IdsRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "ids_#{Rails.env}".to_sym
end
