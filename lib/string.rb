class String
  def ellipsisize
    gsub(/(........).{4,}(........)/, '\1...\2')
  end
end