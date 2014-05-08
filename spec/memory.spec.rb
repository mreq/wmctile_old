require_relative '../lib/wmctile'

describe 'Memory' do
	m = nil
	before(:each) do
		m = Wmctile::Memory.new
	end

	it 'has @memory after init' do
		m.instance_variable_get(:@memory).should be_kind_of Hash
	end
	it 'is able to set and get' do
		m.set 0, 'lorem', { 'ipsum' => 'dolor' }
		m.get(0, 'lorem', 'ipsum').should eq 'dolor'
	end
	it 'writes when setting' do
		m.should_receive :write_memory
		m.set 0, 'lorem', { 'ipsum' => 'dolor' }
	end
	it 'is able to write to file' do
		path = m.instance_variable_get(:@path)
		orig = File.mtime path
		m.set 15, 'lorem', { 'ipsum' => 'dolor' }
		sleep 0.05 # just to be sure
		wrote = File.mtime path
		# file time change
		wrote.should > orig
		# remember the value
		mm = Wmctile::Memory.new
		mm.get(15, 'lorem', 'ipsum').should eq 'dolor'
	end
end