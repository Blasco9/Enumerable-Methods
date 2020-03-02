# rubocop: disable Style/CaseEquality, Style/For
# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
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
    arr = to_a
    while i < arr.size
      yield(arr[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = []
    my_each do |el|
      arr << el if yield(el)
    end
    arr = arr.to_h if Hash === self
    arr
  end

  def my_all?(*parameter)
    return true if length.zero?

    if !parameter[0].nil?
      my_each { |el| return false unless parameter[0] === el }
    elsif block_given?
      my_each { |el| return false unless yield(el) }
    else
      my_each { |el| return false unless el }
    end
    true
  end

  def my_any?(*parameter)
    return false if length.zero?

    if !parameter[0].nil?
      my_each { |el| return true if parameter[0] === el }
    elsif block_given?
      my_each { |el| return true if yield(el) }
    else
      my_each { |el| return true if el }
    end
    false
  end

  def my_none?(*parameter)
    return true if length.zero?

    if !parameter[0].nil?
      my_each { |el| return false if parameter[0] === el }
    elsif block_given?
      my_each { |el| return false if yield(el) }
    else
      my_each { |el| return false if el }
    end
    true
  end

  def my_count(parameter = nil, &block)
    return length unless block_given? || !parameter.nil?

    if !parameter.nil?
      elements = my_select { |el| parameter === el }
      elements.size
    elsif block_given?
      my_select(&block).size
    else
      elements = my_select { |el| parameter === el }
      elements.size
    end
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    arr = []
    my_each do |el|
      arr << yield(el)
    end
    arr
  end

  def my_inject(init = nil, sym = nil)
    return nil if !block_given? && init.nil?

    init, sym = sym, init if init.is_a?(String) || init.is_a?(Symbol) && sym.nil?
    result = init || result = first
    if (sym.is_a? Symbol) || (sym.is_a? String)
      sym = sym.id2name unless sym.is_a? String
      my_each_with_index do |el, i|
        next if init.nil? && i.zero?

        result = result.send(sym, el)
      end
    else
      my_each_with_index do |el, i|
        next if init.nil? && i.zero?

        result = yield(result, el)
      end
    end
    result
  end
end

def multiply_els(arr)
  arr.my_inject { |acc, el| acc * el }
end

# rubocop: enable Style/CaseEquality, Style/For
# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
