# frozen_string_literal: true

class DrugOrder < ActiveRecord::Base
  self.table_name = :drug_order
  self.primary_key = :order_id

  belongs_to :drug, foreign_key: :drug_inventory_id
  belongs_to :order, foreign_key: :order_id, optional: true

  validates_presence_of :drug_inventory_id, :dose, :equivalent_daily_dose,
                        :units, :frequency, :prn

  def as_json(options = {})
    super(options.merge(
      include: { order: {}, drug: {} }
    ))
  end
end
