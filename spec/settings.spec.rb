require_relative '../lib/wmctile'

describe 'Settings' do
	s = nil
	before(:each) do
		s = Wmctile::Settings.new
	end

	it 'offers default settings' do
		s.default_settings.should be_true
	end
	it 'responds to default settings' do
		s.default_settings.each do |a|
			s.should respond_to a[0]
			puts a[0]
		end
	end
	it 'responds false to non-existing settings' do
		s.loremipsumdolorsitamet.should be_false
	end
end