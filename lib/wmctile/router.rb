class Wmctile::Router < Wmctile::Class

	def initialize
		@settings = Wmctile::Settings.new
	end

	def dispatch args = []
		if args[0] and args[0] != 'dispatch' and self.respond_to? args[0]
			self.send args[0], *args.drop(1)
		else
			self.help
		end
	end

	def help args = nil
		puts 'help'
		'help'
	end
	def snap where = 'left', window_str = nil
		if window_str == ':ACTIVE:'
			window = self.get_active_window
		else
			window = self.get_window window_str
		end
		if window
			how_to_move = self.wm.calculate_snap where
			window.move how_to_move  if how_to_move
		end
	end
	def summon window_str
		window = self.get_window window_str, false
		if window
			window.summon
			return true
		end
		return false
	end
	def summon_in_workspace window_str
		window = self.get_window window_str, true
		if window
			window.summon
			return true
		end
		return false
	end
	def summon_or_run window_str, cmd_to_run
		unless self.summon window_str
			self.cmd "#{ cmd_to_run } > /dev/null &"
		end
	end
	def summon_in_workspace_or_run window_str, cmd_to_run
		unless self.summon_in_workspace window_str
			self.cmd "#{ cmd_to_run } > /dev/null &"
		end
	end

	def get_window window_str = nil, current_workspace_only = true
		if window_str.nil?
			window = self.wm.ask_for_window current_workspace_only
		else
			window = self.wm.find_window window_str, current_workspace_only
		end
		window
	end
	def get_active_window
		win_id = self.cmd('wmctrl -a :ACTIVE: -v 2>&1').split('Using window: ').last
		Wmctile::Window.new win_id, @settings
	end

	def wm
		@wm || @wm = Wmctile::WindowManager.new(@settings)
	end
	def wt
		@wt || @wt = Wmctile::WindowTiler.new(@settings)
	end

end