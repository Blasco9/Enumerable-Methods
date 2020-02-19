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
    while i < self.size
      yield(self[i], i)
      i += 1
    end
  end
end

