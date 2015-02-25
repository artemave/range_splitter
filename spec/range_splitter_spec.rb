require 'spec_helper'

describe 'Range Splitter' do

  it 'adds a split method to instances of Range' do
    (1..10).should respond_to :split
  end

  it 'splits a range into an array of ranges' do
    (1..10).each do |i|
      (1..10).split(:into => i).size.should == i
    end
  end

  it 'splits into 2 by default' do
    (1..10).split.size.should == 2
  end

  it 'raises an ArgumentError if given less than 0' do
    expect {
      (1..10).split(:into => 0)
    }.to raise_error(ArgumentError, /0/)

    expect {
      (1..10).split(:into => -5)
    }.to raise_error(ArgumentError, /-5/)
  end

  it 'returns an array of self if given 1' do
    (1..10).split(:into => 1).should == [1..10]
    (3..8).split(:into => 1).should == [3..8]
  end

  it 'places the larger ranges at the beginning' do
    (1..9).split.should == [1..5, 6..9]
    (1..11).split.should == [1..6, 7..11]
    (5..8).split(:into => 3).should == [5..6, 7..7, 8..8]
  end

  it 'splits as evenly as possible' do
    (1..10).split(:into => 4).should == [1..3, 4..6, 7..8, 9..10]
    (1..13).split(:into => 4).should == [1..4, 5..7, 8..10, 11..13]
  end

  it 'supports negative ranges' do
    (-10..-1).split.should == [-10..-6, -5..-1]
    (-9..-1).split.should == [-9..-5, -4..-1]
    (-3..7).split(:into => 3).should == [-3..0, 1..4, 5..7]
  end

  it 'can return fewer elements than the given argument' do
    (1..4).split(:into => 10).should == [1..1, 2..2, 3..3, 4..4]
    (-3..-2).split(:into => 3).should == [-3..-3, -2..-2]
    (-1..1).split(:into => 7).should == [-1..-1, 0..0, 1..1]
  end

  it 'packs from the end of the array if an optional parameter is given' do
    (1..9).split(:endianness => :little).should == [1..4, 5..9]
    (1..11).split(:endianness => :little).should == [1..5, 6..11]
    (5..8).split(:into => 3, :endianness => :little).should == [5..5, 6..6, 7..8]
  end

  it 'raises an argument error if the endianness is neither :little nor :big' do
    expect { (1..1).split(:endianness => :little) }.to_not raise_error
    expect { (1..1).split(:endianness => :big)    }.to_not raise_error
    expect { (1..1).split                         }.to_not raise_error

    expect { (1..1).split(:endianness => :foo)    }.to raise_error(
      ArgumentError, /endianness/
    )
  end

  it 'supports non numeric ranges' do
    expect(('a'..'g').split).to eq ['a'..'d', 'e'..'g']
  end

  context 'range splits evenly' do
    it 'ignores :endianness option' do
      expect((1..10).split(:endianness => :big)).to eq (1..10).split(:endianness => :little)
    end
  end
end
