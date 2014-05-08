require_relative '../lib/wmctile'

describe 'WindowTiler' do
	t = nil
	before(:each) do
		t = Wmctile::WindowTiler.new(Wmctile::Settings.new, Wmctile::Memory.new)
	end

	it 'should use passed memory' do
		a = 'Some sort of an object.'
		tt = Wmctile::WindowTiler.new(Wmctile::Settings.new, a)
		tt.memory.should be a
	end

	describe 'resize method' do
		it 'has a resize method' do
			t.should respond_to :resize
		end
		describe 'resize_snap method' do
			it 'gets the correct direction/sign' do
				# make a snap to resize later
				t.snap 'left', 'terminator.Terminator', 0.5
				p = t.memory.get t.wm.workspace, 'snap', 'portion'
				p.should eq	0.5
				t.resize_snap 'left', 0.01
				np = t.memory.get t.wm.workspace, 'snap', 'portion'
				np.should eq 0.49
				t.resize_snap 'right', 0.1
				nnp = t.memory.get t.wm.workspace, 'snap', 'portion'
				nnp.should eq 0.59
				# restore my poor terminal
				r = Wmctile::Router.new
				r.maximize 'terminator.Terminator'
			end
		end
	end
	
end