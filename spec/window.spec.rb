require_relative '../lib/wmctile'

describe 'Window' do
	w = nil
	before(:each) do
		settings = Wmctile::Settings.new
		w = Wmctile::Window.new "0x12345678  1 terminator.Terminator  #{ settings.hostname } petr@sova: ~/work/wmctile", settings
	end

	describe 'init' do
		it 'extracts id from string' do
			w.instance_variable_get(:@id).should eq '0x12345678'
			w.instance_variable_get(:@name).should eq 'terminator.Terminator'
			w.instance_variable_get(:@title).should eq 'petr@sova: ~/work/wmctile'
		end
		it 'handles being passed an id only' do
			ww = Wmctile::Window.new '0x12345678', Wmctile::Settings.new
			ww.instance_variable_get(:@id).should eq '0x12345678'
			ww.instance_variable_get(:@name).should eq ''
			ww.instance_variable_get(:@title).should eq ''
		end	
	end

	it 'appends whitespace to the name' do
		name = w.instance_variable_get(:@name)
		w.set_name_length 40
		new_name = w.instance_variable_get(:@name)
		new_name.length.should eq 40
		new_name.should eq (name + ' '*(40 - name.length))
	end

	it 'is able to find it\'s name when initialized from id' do
		router = Wmctile::Router.new
		active_win = router.get_active_window
		active_win.instance_variable_get(:@name).should eq ''
		active_win.get_name.should_not eq ''
	end

	it 'returns itself in manipulation methods' do
		[:move, :shade, :unshade, :wmctrl].each do |m|
			w.send(m).should be w
		end
	end

	describe 'dmenu' do
		it 'creates a dmenu item' do
			w.dmenu_item.should be_kind_of Dmenu::Item
		end
		it 'uses one dmenu item over again' do
			w.dmenu_item.should be w.dmenu_item
		end
		it 'creates a string for dmenu' do
			w.dmenu_item.key.should eq '0x12345678 terminator.Terminator petr@sova: ~/work/wmctile'
		end
	end

	describe 'movement' do
		it 'has defaults defined' do
			w.instance_variable_get(:@default_movement).should_not be_nil
		end
		it 'unmaximizes on movement' do
			w.should receive :unmaximize
			w.move
		end
		it 'uses the passed hash' do
			how_to_move = { :x => 30, :y => 30 }
			# unshade
			w.should_receive :wmctrl
			# unmaximize
			w.should_receive :wmctrl
			# movement
			w.should_receive(:wmctrl) do |arg|
				arg.match('-e 0,30,30').should_not be_nil
			end
			w.move how_to_move
		end
	end

end