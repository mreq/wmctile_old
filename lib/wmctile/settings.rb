require 'yaml'

class Wmctile::Settings < Wmctile::Class
	attr_accessor :wm_specific

	def method_missing sym, *args, &block
		return false
	end

	def initialize
		self.get_wm_specific_helper
		path = File.expand_path '~/.config/wmctile/wmctile-settings.yml'
		if not File.exist? path
			raw_settings = self.create_new_settings path
		end
		raw_settings ||= File.read path
		settings = YAML.load(raw_settings)
		if settings
			settings.each { |name, value|
				instance_variable_set("@#{name}", value)
				self.class.class_eval { attr_reader name.intern }
			}
		end
	end

	def test_requirements
		req = ['xrandr', 'wmctrl', 'dmenu']
		ret = req.reject { |r| self.cmd("which #{ r }").length > 0 }
		return ret
	end
	def create_new_settings path
		req = self.test_requirements
		unless req.nil? or req.length == 0
			puts <<-eos
You don't have #{ req.join(', ') } installed. Wmctile can't run without that.

To fix this on Ubuntu, run:

sudo apt-get install #{ req.join(' ').gsub('dmenu', 'suckless-tools') }
			eos
			exit
		end
		dir_path = path[/(.*)\/wmctile-settings.yml/, 1]
		if not Dir.exists? dir_path
			Dir.mkdir dir_path
		end
		out_file = File.new path, 'w'
		out_file.puts self.default_settings.to_yaml
		out_file.close
	end
	def default_settings
		{
			:window_border => 1,
			:panel_height => 24,
			:titlebar_height => 24,
			:panel_width => 0,
			:hostname => self.cmd('hostname')
		}
	end
	def wm_type
		@wm_type || @wm_type = self.cmd('wmctrl -m | head -n2 | tail -n1 | awk \'{print $2}\'')
	end
	def get_wm_specific_helper
		require_relative "wm_specific/#{ self.wm_type }"
		@wm_specific = Wmctile::WmSpecific
	end
end