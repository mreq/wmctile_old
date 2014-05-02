class Wmctile::WindowManager < Wmctile::Class
	attr_accessor :w, :h, :windows

	def initialize settings
		@settings = settings
		self.init_dimensions
	end

	def init_dimensions
		dimensions = cmd("wmctrl -d | awk '{ print $9 }' | head -n1").split('x')
		@w = dimensions[0].to_i - 2*@settings.window_border
		@h = dimensions[1].to_i - 2*@settings.window_border
		@workspace = cmd("wmctrl -d | grep '\*' | cut -d' ' -f 1").to_i
	end
	def width portion
		@w * portion
	end
	def height portion
		@h * portion
	end

	def find_window window_string, current_workspace_only = true
		puts "Finding window #{ window_string }."
	end
	def ask_for_window
		a = dmenu self.windows.map(&:dmenu_item)
		puts a
		a
	end

	def build_win_list current_workspace_only = true
		if current_workspace_only
			variable_name = '@windows_on_workspace'
		else
			variable_name = '@windows_all'
		end
		unless instance_variable_get(variable_name)
			if current_workspace_only
				cmd = "wmctrl -lx | grep \" #{ @workspace } \""
			else
				cmd = "wmctrl -lx"
			end
			arr = cmd(cmd).split("\n")

			new_list = arr.map { |w| Wmctile::Window.new(w, @settings) }
			name_length = new_list.map(&:get_name_length).max
			new_list.each { |w| w.set_name_length(name_length) }

			instance_variable_set(variable_name, new_list)
		end
		instance_variable_get(variable_name)
	end
	def windows current_workspace_only = true
		if current_workspace_only
			variable_name = '@windows_on_workspace'
		else
			variable_name = '@windows_all'
		end
		unless instance_variable_get(variable_name)
			self.build_win_list current_workspace_only
		else
			instance_variable_get(variable_name)
		end
	end
end