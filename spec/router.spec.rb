require_relative '../lib/wmctile'

describe 'Router' do
	r = nil
	before(:each) do
		r = Wmctile::Router.new
	end

	it 'has a dispatch method' do
		r.should respond_to :dispatch
	end
	it 'has a window manager method' do
		r.should respond_to :wm
	end
	it 'has a window tiler method' do
		r.should respond_to :wt
	end
	it 'calls the help method when no attributes are passed' do
		r.should receive :help
		r.dispatch
	end
	it 'uses a single window manager instance' do
		r.wm.should be r.wm
	end
	it 'uses a single window tiler instance' do
		r.wt.should be r.wt
	end
	it 'is able to get the active window' do
		r.get_active_window.should be_kind_of Wmctile::Window
	end
	describe 'notifications' do
		it 'makes a notification when no window is found' do
			r.should_receive :notify
			r.get_window 'loremipsum123456'
		end
		it 'uses an app icon when possible' do
			r.should_receive(:notify).with 'No window found', 'evince.loremipsum123456', 'evince'
			r.get_window 'evince.loremipsum123456'
		end
	end

	describe 'snap method' do
		# snap
		it 'has a snap method' do
			r.should respond_to :snap
		end
		it 'uses wm to calculate the snap' do
			r.wm.should_receive(:calculate_snap).with 'left', 0.5
			r.snap 'left', r.get_active_window.instance_variable_get(:@id)
		end
		it 'accepts a portion of screen' do
			r.wm.should_receive(:calculate_snap).with 'left', 0.3
			r.snap 'left', r.get_active_window.instance_variable_get(:@id), 0.3
		end
	end
	describe 'summon method' do
		it 'searches for a window' do
			r.should_receive(:get_window).with 'loremipsum123456', false
			r.summon 'loremipsum123456'
		end
	end
	describe 'summon_in_workspace method' do
		it 'searches for a window' do
			r.should_receive(:get_window).with 'loremipsum123456', true
			r.summon_in_workspace 'loremipsum123456'
		end
	end
	describe 'summon_or_run method' do
		it 'uses summon' do
			r.should_receive :summon
			r.summon_or_run 'loremipsum123456', 'echo TEST'
		end
		it 'runs a command when a window is not found' do
			r.should_receive(:cmd).with 'echo TEST > /dev/null &'
			r.summon_or_run 'loremipsum123456', 'echo TEST'
		end
	end
	describe 'summon_in_workspace_or_run method' do
		it 'uses summon_in_workspace' do
			r.should_receive :summon_in_workspace
			r.summon_in_workspace_or_run 'loremipsum123456', 'echo TEST'
		end
		it 'runs a command when a window is not found' do
			r.should_receive(:cmd).with 'echo TEST > /dev/null &'
			r.summon_in_workspace_or_run 'loremipsum123456', 'echo TEST'
		end
	end
	describe 'maximize method' do
		it 'finds a window' do
			r.should_receive :get_window
			r.maximize 'loremipsum123456'
		end
	end
	describe 'unmaximize method' do
		it 'finds a window' do
			r.should_receive :get_window
			r.unmaximize 'loremipsum123456'
		end
	end
	describe 'shade/unshade methods' do
		it 'is able to unshade last shaded window via memory' do
			wsp = r.wm.workspace
			r.shade 'terminator.Terminator'
			id = r.memory.get wsp, 'shade', 'window_id'
			r.unshade_last_shaded
			r.memory.get(wsp, 'unshade', 'window_id').should eq id
		end
	end
	describe 'resize method' do
		it 'has a resize method' do
			r.should respond_to :resize
		end
	end
end