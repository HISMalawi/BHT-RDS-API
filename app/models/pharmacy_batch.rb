class PharmacyBatch < VoidableRecord
  has_many :items, inverse_of: :batch
end
