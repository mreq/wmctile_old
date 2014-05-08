require 'yaml'

class Wmctile::Memory < Wmctile::Class
	##################################
	## init ##########################
	##################################
	def initialize
		@path = File.expand_path '~/.config/wmctile/wmctile-memory.yml'
		if not File.exist? @path
			raw_memory = self.create_new_memory
		end
		raw_memory ||= File.read @path
		@memory = YAML.load(raw_memory)
	end
	def create_new_memory
		dir_path = @path[/(.*)\/wmctile-memory.yml/, 1]
		if not Dir.exists? dir_path
			Dir.mkdir dir_path
		end
		out_file = File.new @path, 'w'
		# 20 workspaces should suffice
		20.times do |i|
			out_file.puts "#{i}:"
		end
		out_file.close
	end
	def write_memory
		out_file = File.new @path, 'w+'
		out_file.puts @memory.to_yaml
		out_file.close
	end
	##################################
	## getters/setters ###############
	##################################
	def get workspace = 0, key = nil, key_sub = nil
		begin
			a = @memory[workspace]
			if key.nil?
				return nil
			else
				a = a[key]
				if key_sub.nil?
					return a
				else
					return a[key_sub]
				end
			end
		rescue Exception => e
			return nil			
		end
	end
	def set workspace = 0, key, hash
		if @memory[workspace].nil?
			@memory[workspace] = {}
		end
		if @memory[workspace][key]
			@memory[workspace][key] = hash
		else
			@memory[workspace].merge! key => hash
		end
	end
end