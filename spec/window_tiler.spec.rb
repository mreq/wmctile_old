require_relative '../lib/wmctile'

describe 'WindowTiler' do
	t = nil
	before(:each) do
		t = Wmctile::WindowTiler.new(Wmctile::Settings.new)
	end

	it 'should use passed wm' do
		a = 'Some sort of an object.'
		tt = Wmctile::WindowTiler.new(Wmctile::Settings.new, a)
		tt.wm.should be a
	end
	
end