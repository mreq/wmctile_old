Gem::Specification.new do |s|
	s.name        = 'wmctile'
	s.version     = '0.0.1'
	s.date        = '2014-04-23'
	s.summary     = 'wmctile'
	s.description = 'A tiling window manager in a gem.'
	s.authors     = ['mreq']
	s.email       = 'contact@petrmarek.eu'
	s.files       = ['lib/wmctile.rb']
	s.homepage    = ''
	s.license     = 'GPL-2'
	# dependencies
	{
		:dmenu => '~> 0.0.2'
	}.each do |dep, version|
		s.add_runtime_dependency dep, version
	end
end