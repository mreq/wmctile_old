Gem::Specification.new do |s|
	s.name        = 'wmctile'
	s.version     = '0.0.1'
	s.date        = Time.now.strftime('%Y-%m-%d')
	s.summary     = 'wmctile'
	s.description = 'Window manager\'s best friend in a gem.'
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
	s.post_install_message = <<-eos
Thanks for installing wmctile. Make sure, you have the following dependencies installed on your system:

wmctrl
xrandr
dmenu

On Ubuntu it's as easy as running:

sudo apt-get install wmctrl, xrandr, dmenu

If you have that, run:

wmctile help

to show the available commands. Also be sure to check the detailed docs at http://mreq.github.io/wmctile/build/docs.
	eos
end