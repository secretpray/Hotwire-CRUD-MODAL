module RecordsHelper
  def dom_id_for_records(*records, prefix: nil)
    records.map do |record|
      dom_id(record, prefix: prefix)
    end.join("_")
  end
end
