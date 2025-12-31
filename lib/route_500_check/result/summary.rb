# result/summary.rb
class Summary
  def initialize(results)
    @results = results
  end

  def has_500?
    @results.any? { |r| r.status.to_i >= 500 }
  end
end
