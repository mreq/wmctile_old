require_relative '../lib/wmctile'

describe 'Window' do
	w = nil
	before(:each) do
		settings = Wmctile::Settings.new
		w = Wmctile::Window.new "0x06000004  1 terminator.Terminator  #{ settings.hostname } petr@sova: ~/work/wmctile", settings
	end

	it 'should extract id from string' do
		w.instance_variable_get(:@id).should eq '0x06000004'
		w.instance_variable_get(:@name).should eq 'terminator.Terminator'
		w.instance_variable_get(:@title).should eq 'petr@sova: ~/work/wmctile'
	end
	it 'should handle being passed an id only' do
		ww = Wmctile::Window.new '0x06000004', Wmctile::Settings.new
		ww.instance_variable_get(:@id).should eq '0x06000004'
		ww.instance_variable_get(:@name).should eq ''
		ww.instance_variable_get(:@title).should eq ''
	end	

end