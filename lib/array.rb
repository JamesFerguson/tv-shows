class Array
  def group_by(method_sym = nil, &block)
    unless block.present?
      block = Proc.new { |item| item.send(method_sym) }
    end

    reduce(Hash.new { |h, k| h[k] = [] }) do |hash, item|
      key = block.call(item)
      hash[key] << item
      hash
    end
  end
end
