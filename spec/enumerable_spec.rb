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

  
end