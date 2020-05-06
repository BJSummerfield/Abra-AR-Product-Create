require './data/vars/atr'
require './data/vars/key'

class Generate
  def self.write(params)
    item = match_type(params)
    return item
  end

  def self.match_type(params)
    if params['type'] = 'all threaded rod'
      return Atr.new(params)
    end
  end
end
