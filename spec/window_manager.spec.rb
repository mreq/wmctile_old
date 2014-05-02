require_relative '../lib/wmctile'

describe 'WindowManager' do
	wm = nil
	before(:each) do
		wm = Wmctile::WindowManager.new Wmctile::Settings.new
		# override dmenu for specs
		def dmenu items
			return items[0]			
		end
	end

	it 'should get dimensions on init' do
		wm.instance_variable_get(:@w).should be > 100
		wm.instance_variable_get(:@h).should be > 100
	end
	it 'should get the workspace number on init' do
		wm.instance_variable_get(:@workspace).should be_kind_of Integer
	end

	it 'should have width/height getters' do
		wm.width(1).should eq wm.instance_variable_get(:@w)
		wm.width(0.5).should eq wm.instance_variable_get(:@w).to_f/2
		wm.height(1).should eq wm.instance_variable_get(:@h)
		wm.height(0.5).should eq wm.instance_variable_get(:@h).to_f/2
	end
end