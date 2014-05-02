require_relative '../lib/wmctile'

describe 'Class' do
	c = nil
	before(:each) do
		c = Wmctile::Class.new
	end
	it 'should be able to get STDOUT' do
		c.cmd('echo TEST').should eq "TEST"
	end
end