class Wmctile::WindowManager
	attr_accessor :windows

	def initialize settings
		@settings = settings
		self.init_dimensions
	end

	def init_dimensions
		dimensions = cmd("wmctrl -d | awk '{ print $9 }' | head -n1").split('x')
		@w = dimensions[0].to_i - 2*@settings.window_border
		@h = dimensions[1].to_i - 2*@settings.window_border
		@workspace = cmd("wmctrl -d | grep '\*' | cut -d' ' -f 1")
	end
	def width portion
		@w * portion
	end
	def height portion
		@h * portion
	end

	def find_window window_string
		puts "Finding window #{ window_string }."
	end
	# def get_active_win
	# 	Window.new cmd("wmctrl -lx | grep #{ cmd('wmctrl -a :ACTIVE: -v').split('Using window: ')[1] }")
	# end
	# def build_win_list current_workspace_only = true
	# 	unless @windows
	# 		if current_workspace_only
	# 			cmd = "wmctrl -lx"
	# 		else
	# 			cmd = "wmctrl -lx | grep \" #{ @workspace } \""
	# 		end
	# 		arr = cmd(cmd).split("\n")

	# 		@windows = arr.map { |w| Window.new(w) }
	# 		name_length = @windows.map(&:name_length).max
	# 		@windows.each { |w| w.set_name_length(name_length) }
	# 	end
	# 	@windows
	# end
	# def windows
	# 	unless @windows
	# 		return self.build_win_list
	# 	else
	# 		return @windows
	# 	end
	# end
	# def prompt_for_window
	# 	a = dmenu self.windows.map(&:dmenu_item)
	# 	puts a
	# end
end