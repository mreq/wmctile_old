require 'yaml'

class Wmctile::Settings < Wmctile::Class
	def method_missing sym, *args, &block
		return false
	end

	def initialize
		path = File.expand_path '~/.config/wmctile/wmctile.yml'
		if not File.exist? path
			raw_settings = self.create_new_settings path
		end
		raw_settings = File.read path
		settings = YAML.load(raw_settings)
		if settings
			settings.each { |name, value|
				instance_variable_set("@#{name}", value)
				self.class.class_eval { attr_reader name.intern }
			}
		end
	end

	def create_new_settings path
		dir_path = path[/(.*)\/wmctile.yml/, 1]
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
			:hostname => self.cmd('hostname')
		}
	end
end