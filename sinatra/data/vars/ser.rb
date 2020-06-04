require './data/vars/key'

class Ser < Hash
  def initialize (params)
    add_params(params)
    # params = {'type' => type ,"grade" => grade, 'finish' => finish,'diameter' => diameter, 'length' => length, "thread_length" => thread_length}
    self['sku'] = create_sku(params)
    self['description'] = create_description(params)
    self['cost'] = create_cost(params)
    self['weight'] = create_weight(params)
  end

  def add_params (params)
    params.each do |k,v|
      self[k] = v
    end
  end

  def create_sku (params)
    string = ""
    string += params['type'].split.map(&:chr).join.upcase
    string += "-"
    string += params['grade'].upcase.gsub(" GRADE ","-")
    string += params['finish'].split.map(&:chr).join.upcase
    string += "-"
    string += params['diameter'].gsub('/','').gsub('"','')
    string += "-"
    string += params['length'].to_s
    string += "-"
    string += params['thread_length'].to_s
    return string
  end

  def create_description (params)
    length = notate(params['length'].to_i)
    thread_length = notate(params['thread_length'].to_i)
    string = ""
    string += 'ASTM ' + params['grade'].upcase.gsub('GRADE', 'Grade') + " - "
    string += params['finish'].capitalize + " "
    string += params['type'].split.map(&:capitalize)*' ' + " "
    string += "- #{params['diameter']}" + " "
    string += "x #{length}"
    string += " - "
    string += "#{thread_length} Thread"
    return string
  end

  def create_weight (params)
    d_weight = DIAMETERS[params['diameter']]['weight']
    mult = params['length'].to_i / 4.0
    weight = ((d_weight * mult) / 10000.00)
    weight += 0.1
    return weight.round(4)
  end

  def create_cost (params)
    c = 0
    mult = 0
    mult += FINISHES[params['finish']]['cost']
    mult += TYPES[params['type']]['cost']
    mult += GRADES[params['grade']]['cost']
    c += DIAMETERS[params['diameter']]['cost']
    c = c * mult
    c = ((c * (params['length'].to_i/4.0)) / 100000.00).round(4)
    return c
  end

  def notate (quarter_inches)
    feet = 0
    inches = 0
    while quarter_inches > 0
      quarter_inches -= 48
      if quarter_inches >= 0
        feet += 1
      end
    end
    while quarter_inches < 0
      quarter_inches += 4
      inches +=1
    end
    inches = (inches-12) * -1 if inches != 0
    return length_message(feet, inches, quarter_inches)
  end

  def length_message (feet, inches, quarter)
    string = ""
    string += "#{feet}"+"'" if feet >= 1
    string += "-" if feet > 0 && inches > 0
    string += "#{inches}" if inches >= 1
    if quarter > 0 && quarter != 2
      string += "-" if feet != 0 || inches != 0
      string += "#{quarter}/4"
    end
    if quarter == 2
      string += "-" if feet != 0 || inches != 0
      string += "1/2"
    end
    string += '"' if inches > 0 || quarter > 0
    return string
  end
end 