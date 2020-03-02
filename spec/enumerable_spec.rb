require './enumerable.rb'

RSpec.describe Enumerable do
  let(:arr) { [1, 2, 3] }
  let(:hash) { { a: 1, b: 2, c: 3 } }
  let(:mix_arr) { [1, 'two', nil, true, false] }
  let(:truthy_arr) { [1, 'two', true] }
  let(:falsy_arr) { [false, nil] }

  describe '#my_each' do
    it 'returns an enumerator if no block has been given' do
      expect(arr.my_each).to be_kind_of(Enumerator)
    end

    it 'calls the given block for each element of the collection' do
      counter = 0
      arr.my_each { counter += 1 }
      expect(counter).to eql(arr.length)
    end

    it 'returns the collection that called the method' do
      expect(arr.my_each { |n| n }).to eql(arr)
    end

    it 'should work on hashes' do
      expect(hash.my_each { |k, v| }).to eql(hash)
    end
  end

  describe '#my_each_with_index' do
    it 'returns an enumerator if no block has been given' do
      expect(arr.my_each_with_index).to be_kind_of(Enumerator)
    end

    it 'calls the given block for each element of the collection' do
      counter = 0
      arr.my_each_with_index { counter += 1 }
      expect(counter).to eql(arr.length)
    end

    it 'passes the index of the current element to the block' do
      counter = 0
      arr.my_each_with_index do |_n, i|
        expect(counter).to eql(i)
        counter += 1
      end
    end

    it 'returns the collection that called the method' do
      expect(arr.my_each { |n| n }).to eql(arr)
    end

    it 'should work on hashes' do
      expect(hash.my_each_with_index { |k, v, i| }).to eql(hash)
    end
  end

  describe '#my_select' do
    it 'returns an enumerator if no block has been given' do
      expect(arr.my_select).to be_kind_of(Enumerator)
    end

    it 'should return a collection with the elements that matches the condition in the block' do
      filtered_arr = [2, 3]
      expect(arr.my_select { |n| n > 1 }).to eql(filtered_arr)
    end

    it 'should work on hashes' do
      filtered_hash = {
        b: 2,
        c: 3
      }
      expect(hash.my_select { |_k, v| v > 1 }).to eql(filtered_hash)
    end

    it 'should return the truthy elements if no condition is given in the block' do
      expect(mix_arr.my_select { |el| el }).to eql(truthy_arr)
    end
  end

  describe '#my_all?' do
    it 'returns true if no argument nor block has been given and all the elements in the collection are truthy' do
      expect(truthy_arr.my_all?).to be true
    end

    it 'returns true if called on an empty collection' do
      expect([].my_all?).to be true
    end

    it 'returns true if all the elements in the collection match the condition given in the block' do
      expect(arr.my_all? { |item| item < 4 }).to be true
    end

    it 'returns true when all the elements of the collection match the given regular expression' do
      expect(%w[ant bear cat].my_all?(/a/)).to be true
    end

    it 'returns true if all the elements of the collection are instances of the class passed or inherit from it' do
      expect(arr.my_all?(Numeric)).to be true
    end

    it 'should work the same in hashes as it does in arrays' do
      expect(hash.my_all? { |_k, v| v < 4 }).to be true
    end
  end

  describe '#my_any?' do
    it 'returns true if no argument nor block has been given and any of the elements in the collection is truthy' do
      expect(mix_arr.my_any?).to be true
    end

    it 'returns false if called on an empty collection' do
      expect([].my_any?).to be false
    end

    it 'returns true if any of the elements in the collection matches the condition given in the block' do
      expect(mix_arr.my_any?(&:nil?)).to be true
    end

    it 'returns true when any of the elements in the collection matches the given regular expression' do
      expect(%w[ant bear cat].my_any?(/b/)).to be true
    end

    it 'returns true if any of the elements in the collection is an instance of the class passed or inherits from it' do
      expect(truthy_arr.my_any?(Numeric)).to be true
    end

    it 'should work the same in hashes as it does in arrays' do
      expect(hash.my_any? { |_k, v| v > 2 }).to be true
    end
  end

  describe '#my_none?' do
    it 'returns true if no argument nor block has been given and all the elements in the collection are falsy' do
      expect(falsy_arr.my_none?).to be true
    end

    it 'returns true if called on an empty collection' do
      expect([].my_none?).to be true
    end

    it 'returns true if none of the elements in the collection match the condition given in the block' do
      expect(arr.my_none? { |item| item > 3 }).to be true
    end

    it 'returns true when none of the elements in the collection match the given regular expression' do
      expect(mix_arr.my_none?(/d/)).to be true
    end

    it 'returns true if none of the elements in the collection are instances of the class passed or inherit from it' do
      expect(arr.my_none?(String)).to be true
    end

    it 'should work the same in hashes as it does in arrays' do
      expect(hash.my_none? { |_k, v| v > 4 }).to be true
    end
  end

  describe '#my_count' do
    it 'returns the number of elements in the collection if called without parameters or whithout giving a block' do
      expect(arr.my_count).to eql(arr.length)
    end

    it 'returns the number of elements in the collection that match the parameter' do
      expect(arr.my_count(Numeric)).to eql(arr.length)
    end

    it 'returns the number of elements in the collection that match the condition in the block given' do
      expect(arr.my_count { |el| el > 1 }).to eql(2)
    end
  end

  describe '#my_map' do
    it 'returns an enumerator if no block has been given' do
      expect(arr.my_map).to be_kind_of(Enumerator)
    end

    it 'returns a new array with the results of running block once for every element in the collection' do
      expect(arr.my_map { |n| n * 2 }).to eql([2, 4, 6])
    end

    it 'should work in hashes the same as it does in arrays' do
      expect(hash.my_map { |_k, v| v * 2 }).to eql([2, 4, 6])
    end
  end

  describe '#my_inject' do
    it 'combines all the elements of the collection using the sign given as the operator.' do
      expect(arr.my_inject(:+)).to eql(6)
    end

    it 'uses the first parameter as the initial value and then combines all the elements of the collection.' do
      expect(arr.my_inject(2, :+)).to eql(8)
    end

    it 'combines all the elements of the collection as specified in the block given' do
      expect(arr.my_inject { |acc, el| acc + el }).to eql(6)
    end

    it 'combines all the elements of the collection as specified in the block given.' do
      expect(arr.my_inject(2) { |acc, el| acc + el }).to eql(8)
    end

    it "returns nil if called on an empty collection and doesn't recieve an initial value or a block" do
      expect([].my_inject).to eql(nil)
    end

    it 'returns a hash when called on a bi-dimentional array with the correct instructions in the block' do
      arr = [[:student, 'Terrance Koar'], [:course, 'Web Dev']]
      hash = { student: 'Terrance Koar', course: 'Web Dev' }
      expect(arr.my_inject({}) do |result, element|
        result[element.first] = element.last
        result
      end).to eql(hash)
    end

    it 'returns a filtered array when called on an array with the correct instructions in the block' do
      expect([10, 20, 30, 5, 7, 9, 3].my_inject([]) do |result, element|
        result << element.to_s if element > 9
        result
      end).to eql([10.to_s, 20.to_s, 30.to_s])
    end
  end
end
