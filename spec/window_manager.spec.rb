require_relative '../lib/wmctile'

describe 'WindowManager' do
	wm = nil
	before(:all) do
		# override dmenu for testing
		class Wmctile::WindowManagerRspec < Wmctile::WindowManager
			def dmenu items
				items.first.value
			end
		end
		wm = Wmctile::WindowManagerRspec.new Wmctile::Settings.new
	end

	it 'gets dimensions and workspace number on init' do
		wm.w.should be_kind_of Integer
		wm.h.should be_kind_of Integer
		wm.workspace.should be_kind_of Integer
	end

	it 'has width/height getters' do
		wm.width(1).should eq wm.w
		wm.width(0.5).should eq wm.w.to_f/2
		wm.height(1).should eq wm.h
		wm.height(0.5).should eq wm.h.to_f/2
	end

	it 'is able to find a window' do
		router = Wmctile::Router.new
		active_win = wm.get_active_window
		found_win = wm.find_window(active_win.get_name)
		
		found_win.id.should eq active_win.id
		found_win.get_name.should eq active_win.get_name
	end

	it 'understands window_str can be a window object' do
		settings = Wmctile::Settings.new
		w = Wmctile::Window.new "0x12345678  1 terminator.Terminator  #{ settings.hostname } petr@sova: ~/work/wmctile", settings
		wm.get_window(w).should be w
	end

	it 'is able to ask for a window' do
		wm.ask_for_window.should be_kind_of Wmctile::Window
	end

	describe 'window list' do
		it 'builds windows list' do
			a = wm.build_win_list
			a.should be_kind_of Array
			a.first.should be_kind_of Wmctile::Window
		end
		it 'uses windows over again' do
			wm.build_win_list.should be wm.build_win_list
		end
		it 'filters workspaces' do
			all_windows = wm.build_win_list(true)
			workspace_windows = wm.build_win_list(false)

			all_windows.length.should be >= workspace_windows.length
		end
	end

	describe 'size calculation' do
		it 'can calculate snap' do
			wm.calculate_snap('left').should be_kind_of Hash
		end
	end

	describe 'notifications' do
		it 'makes a notification when no window is found' do
			wm.should_receive :notify
			wm.get_window 'loremipsum123456'
		end
		it 'uses an app icon when possible' do
			wm.should_receive(:notify).with 'No window found', 'evince.loremipsum123456', 'evince'
			wm.get_window 'evince.loremipsum123456'
		end
	end
end