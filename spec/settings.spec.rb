require_relative '../lib/wmctile'

describe 'Settings' do
	s = nil
	before(:each) do
		s = Wmctile::Settings.new
	end

	it 'offers default settings' do
		s.default_settings.should_not be_nil
	end
	it 'responds to default settings' do
		s.default_settings.each do |a|
			s.should respond_to a[0]
		end
	end
	it 'responds false to non-existing settings' do
		s.loremipsumdolorsitamet.should be false
	end
	it 'checks for requirements on first start' do
		s.should_receive :test_requirements
		s.create_new_settings File.expand_path('~/.config/wmctile/wmctile-settings.yml')
	end
	it 'should detect window manager' do
		wm = s.cmd('wmctrl -m | head -n2 | tail -n1 | awk \'{print $2}\''
			)
		s.wm_type.should be s.wm_type
		s.wm_type.should eq wm
	end
	# describe 'should detect panel size in' do
	# 	describe 'xfwm4' do
	# 		it 'works with horizontal panel' do
	# 			# output of `xfconf-query -c xfce4-panel -p /panels/panel-0/mode` is 0 for horizontal
	# 		end
	# 	end
	# end
end