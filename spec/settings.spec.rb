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
		s.loremipsumdolorsitamet.should be_false
	end
	it 'checks for requirements on first start' do
		s.should_receive :test_requirements
		s.create_new_settings File.expand_path('~/.config/wmctile/wmctile-settings.yml')
	end
end