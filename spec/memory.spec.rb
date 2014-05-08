require_relative '../lib/wmctile'

describe 'Memory' do
	m = nil
	before(:each) do
		m = Wmctile::Memory.new
	end

	it 'has @memory after init' do
		m.instance_variable_get(:@memory).should be_kind_of Hash
	end
	it 'is able to write to file' do
		# file time change
		path = m.instance_variable_get(:@path)
		orig = m.cmd("stat -c%Y #{ path }")
		m.write_memory
		wrote = m.cmd("stat -c%Y #{ path }")
		wrote.should > orig
		# remember value
		m.set 15, 'lorem', 'ipsum'
		m.write_memory
		mm = Wmctile::Memory.new
		mm.get(15, 'lorem').should eq 'ipsum'
	end
	it 'is able to set and get' do
		m.set 0, 'lorem', { 'ipsum' => 'dolor' }
		m.get(0, 'lorem', 'ipsum').should eq 'dolor'
	end
end