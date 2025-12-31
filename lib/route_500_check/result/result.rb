# result/result.rb
Result = Struct.new(
  :path, :url, :status, :elapsed_ms, :error,
  keyword_init: true
)
