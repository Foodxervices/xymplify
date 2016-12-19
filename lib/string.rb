class String
  def ellipsisize(type = 'short')
    case type
    when 'short'
      gsub(/(........).{4,}(........)/, '\1...\2')
    when 'long'
      gsub(/(..............................).{4,}(........)/, '\1...\2')
    end
  end
end