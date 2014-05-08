class Wmctile::WindowManager < Wmctile::ClassWithDmenu
	attr_accessor :w, :h, :workspace, :windows
	##################################
	## init ##########################
	##################################
	def initialize settings
		@settings = settings
		self.init_dimensions
	end
	def init_dimensions
		# legacy (but fast) method via wmctrl
		# dimensions = cmd("wmctrl -d | awk '{ print $9 }' | head -n1").split('x')
		# xrandr is slower, but offers more information
		dimensions = cmd("xrandr | grep -E '\sconnected\s[0-9]+x[0-9]+\+0' | awk '{print $3}' | awk -F'+' '{print $1}'").split('x')
		@w = dimensions[0].to_i - 2*@settings.window_border
		@h = dimensions[1].to_i - 2*@settings.window_border - @settings.panel_height
		@workspace = cmd("wmctrl -d | grep '\*' | awk '{ print $1 }'").to_i
	end
	##################################
	## dimension getters #############
	##################################
	def width portion = 1
		@w * portion
	end
	def height portion = 1
		@h * portion
	end
	##################################
	## window getters ################
	##################################
	def get_window window_str = nil, current_workspace_only = true
		if window_str.nil?
			window = self.ask_for_window current_workspace_only
		else
			if window_str == ':ACTIVE:'
				window = self.get_active_window
			else
				window = self.find_window window_str, current_workspace_only
				unless window
					# does window_str have an icon bundle in it? (aka evince.Evince)
					if window_str =~ /[a-z0-9]+\.[a-z0-9]+/i
						icon = window_str.split('.').first
					else
						icon = nil
					end
					self.notify 'No window found', "#{ window_str }", icon
				end
			end
		end
		window
	end
	def get_active_window
		win_id = self.cmd('wmctrl -a :ACTIVE: -v 2>&1').split('Using window: ').last
		Wmctile::Window.new win_id, @settings
	end
	def find_window window_string, current_workspace_only = true
		cmd = "wmctrl -lx | grep -F #{ window_string }"
		cmd += ' | grep -E \'0x\w+\s+' + @workspace.to_s + '\s+\''  if current_workspace_only
		window_string = self.cmd cmd
		window_string = window_string.split("\n").first
		if window_string.nil?
			return nil
		else
			return Wmctile::Window.new window_string, @settings
		end
	end
	def ask_for_window current_workspace_only = true
		self.dmenu self.windows.map(&:dmenu_item)
	end
	##################################
	## window lists ##################
	##################################
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
	##################################
	## window size calculators #######
	##################################
	def calculate_snap where, portion = 0.5
		return case where
		when 'left'
			{
				:x => @settings.panel_width, :y => @settings.panel_height,
				:height => self.height, :width => self.width(portion)
			}
		when 'right'
			{
				:x => self.width(portion), :y => @settings.panel_height,
				:height => self.height, :width => self.width(1-portion)
			}
		when 'top'
			{
				:x => @settings.panel_width, :y => @settings.panel_height,
				:height => self.height(portion), :width => self.width
			}
		when 'bottom'
			{
				:x => @settings.panel_width, :y => @settings.panel_height + self.height(1-portion),
				:height => self.height(portion), :width => self.width
			}
		else
			nil
		end
	end
end