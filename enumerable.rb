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
end
