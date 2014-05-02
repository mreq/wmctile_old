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

	describe 'snap method' do
		# snap
		it 'has a snap method' do
			r.should respond_to :snap		
		end

	end
end