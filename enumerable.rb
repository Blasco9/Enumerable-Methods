module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
    for el in self do
      yield(el)
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    i = 0
    arr = self.to_a
    while i < arr.size
      yield(arr[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?
    arr = []
    self.my_each do |el|
      arr << el if yield(el)
    end
    arr = arr.to_h if Hash === self
    arr
  end

  def my_all?(parameter = nil)
    return true if (parameter.nil? && self.length == 0)
    self.my_each do |el|
      if parameter.is_a? Regexp
        return false unless el.match(parameter)
      elsif parameter.is_a? String
        return false unless el === parameter
      elsif parameter.is_a? Numeric
        return false unless el === parameter
      elsif block_given?
        return false unless yield(el)
      else
        return false unless el
      end
    end
    true
  end

  def my_any?(parameter = nil)
    return false if (parameter.nil? && self.length == 0)
    self.my_each do |el|
      if parameter.is_a? Regexp
        return true if el.match(parameter)
      elsif parameter.is_a? String
        return true if el === parameter
      elsif parameter.is_a? Numeric
        return true if el === parameter
      elsif block_given?
        return true if yield(el)
      else
        return true if el
      end
    end
    false
  end

  def my_none?(parameter = nil)
    return true if (parameter.nil? && self.length == 0)
    self.my_each do |el|
      if parameter.is_a? Regexp
        return false if el.match(parameter)
      elsif parameter.is_a? String
        return false if el === parameter
      elsif parameter.is_a? Numeric
        return false if el === parameter
      elsif block_given?
        return false if yield(el)
      else
        return false if el
      end
    end
    true
  end

  def my_count(parameter = nil, &block)
    return self.size unless block_given? || !parameter.nil?
    unless parameter.nil?
      elements = self.my_select { |el| parameter === el }
      elements.size
    else
      self.my_select(&block).size
    end
  end
end
