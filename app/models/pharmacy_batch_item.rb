class PharmacyBatchItem < VoidableRecord
  belongs_to :batch, class_name: 'PharmacyBatch', foreign_key: 'pharmacy_batch_id'
end
