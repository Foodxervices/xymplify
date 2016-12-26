module ConfigHelper
  def config_value_option(slug)
    case slug 
    when 'cut-off'
      { collection: ['On', 'Off'] }
    else
      nil
    end
  end
end