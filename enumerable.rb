module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
    for el in self do
      yield(el)
    end
  end
end

arr = [1,2,3]

puts arr.my_each

