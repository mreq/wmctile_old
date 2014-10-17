Gem::Specification.new do |s|
	s.name        = 'wmctile'
	s.version     = '0.1.2'
	s.date        = Time.now.strftime('%Y-%m-%d')
	s.summary     = 'wmctile'
	s.description = 'Window manager\'s best friend in a gem.'
	s.authors     = ['mreq']
	s.email       = 'contact@petrmarek.eu'
	s.files       = Dir['bin/*'] + Dir['lib/*.rb'] + Dir['lib/wmctile/*.rb']
	s.homepage    = 'http://mreq.github.io/wmctile'
	s.license     = 'GPL-2'
	s.executables << 'wmctile'
	# dependencies
	{
		:dmenu => '~> 1.0'
	}.each do |dep, version|
		s.add_runtime_dependency dep, version
	end
	s.post_install_message = <<-eos
Thanks for installing wmctile. Make sure, you have the following dependencies installed on your system:

wmctrl
xrandr
dmenu

On Ubuntu it's as easy as running:

sudo apt-get install wmctrl suckless-tools

If you have that, run:

wmctile help

to show the available commands. Also be sure to check the detailed docs at http://mreq.github.io/wmctile/build/docs.
	eos
end