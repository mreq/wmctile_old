require_relative '../lib/wmctile'

describe 'Helpers' do
	it 'should be able to get STDOUT' do
		cmd('echo TEST').should eq "TEST"
	end
end