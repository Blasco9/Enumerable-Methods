require './enumerable.rb'

RSpec.describe Enumerable do
  let(:arr) { [1,2,3] }
  let(:hash) { { a: 1, b: 2, c: 3 } }
  let(:mix_arr) { [1, "two", nil, true, false] }
  let(:truthy_arr) { [1, "two", true] }

  describe '#my_each' do
    it 'returns an enumerator if no block has been given' do
      expect(arr.my_each).to be_kind_of(Enumerator)
    end

    it 'calls the given block for each element of the collection' do
      counter = 0
      arr.my_each { |n| counter += 1 }
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
      arr.my_each_with_index { |n| counter += 1 }
      expect(counter).to eql(arr.length)
    end

    it 'passes the index of the current element to the block' do
      counter = 0
      arr.my_each_with_index do |n, i|
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
      expect(hash.my_select { |k, v| v > 1 }).to eql(filtered_hash)
    end

    it 'should return the truthy elements if no condition is given in the block' do
      expect(mix_arr.my_select { |el| el }).to eql(truthy_arr)
    end
  end

  describe '#my_all?' do
    it 'It should return true when none of the elements are false or nil.' do
      expect(truthy_arr.my_all?).to be true
    end

    it 'It should return true whether it founds an element that match a condition given in the block.' do
      expect(arr.my_all? { |item| item < 4 }).to be true
    end
  
    it 'It should works with regex, if the regex passed as an argument match all the elements it should return true.' do
      expect(%w[ant bear cat].my_any?(/a/)).to be true 
    end

    it 'It should work with class names, it should return true if all the elements are an instance or child  of that class.' do
      expect(arr.my_all?(Numeric)).to be true
    end

    it 'It should return if the array that calls the method is empty.' do
      expect([].my_all?).to be true
    end

    it 'It should works with hashes.' do
      expect(hash.my_all? { |k, v| v < 4 }).to be true
    end
  end
  
  describe '#my_any?' do
    it 'It should return true if any of the elements are true.' do
      expect(mix_arr.my_any?).to be true
    end

    it 'It should return false if the array or the hash that calls the method are empty.' do
      expect([].my_any?).to be false
    end

    it 'It should return true if any of the elements match a condition given in the block.' do
      expect(mix_arr.my_any? { |item| item.nil? }).to be true
    end

    it 'It should works with regex, if any of the elements match the condition given in the block should returns true.' do
      expect(%w[ant bear cat].my_any?(/b/)).to be true
    end

    it 'It should work with class names, it should return true if any of the elements are an instance or child of that class.' do
      expect(truthy_arr.my_any?(Numeric)).to be true
    end
  end

  describe '#my_none?' do
    it "It should return true when none of it's elements are true." do
      expect(falsy.my_none?).to be true
    end

    it "It should return true when given a condition that does not match in it's elements." do
      expect(arr.my_none? { |item| item > 3 }).to be true
    end

    it "It should work with regex, when none of it's elements match it should return true." do
      expect(mix_arr.my_none?(/d/)).to be true
    end

    it 'It should work with class names, it should return true if none of the elements are an instance or child of that class.' do
      expect(arr.my_none?(String)).to be true
    end

    it "It should return true if there are none items." do
      expect([].my_none?).to be true
    end
  end
  
end