class Wmctile::Router < Wmctile::Class
	##################################
	## init ##########################
	##################################
	def initialize
		@settings = Wmctile::Settings.new
		@all_workspaces = false
	end
	##################################
	## main dispatch method ##########
	##################################
	def dispatch args = []
		if args.length
			main_arg = args[0]
			if main_arg == '--all-workspaces'
				@all_workspaces = true
				drop = 2
				main_arg = args[1]
			else
				@all_workspaces = false
				drop = 1
			end
			if main_arg and !['dispatch', 'initialize', 'wm', 'wt', 'memory'].inlcude? main_arg and self.respond_to? main_arg
				self.send main_arg, *args.drop(drop)
			else
				self.help
			end
		else
			self.help
		end
	end
	##################################
	## object getter methods #########
	##################################
	def wm
		@wm || @wm = Wmctile::WindowManager.new(@settings)
	end
	def wt
		# @wm might be nil
		@wt || @wt = Wmctile::WindowTiler.new(@settings, self.memory, @wm)
	end
	def memory
		@memory || @memory = Wmctile::Memory.new
	end
	##################################
	## actual command-line methods ###
	##################################
	def help args = nil
		puts 'help'
	end
	def summon window_str
		window = self.wm.find_in_windows window_str, @all_workspaces
		if window
			window.summon
			return true
		else
			return false
		end
	end
	def summon_or_run window_str, cmd_to_run
		unless self.summon window_str
			self.cmd "#{ cmd_to_run } > /dev/null &"
		end
	end
	def switch_to window_str
		window = self.wm.find_in_windows window_str, @all_workspaces
		if window
			window.switch_to
			return true
		else
			return false
		end
	end
	def switch_to_or_run window_str, cmd_to_run
		unless self.switch_to window_str
			self.cmd "#{ cmd_to_run } > /dev/null &"
		end
	end
	def maximize window_str
		window = self.wm.get_window window_str
		if window
			window.maximize
		end
	end
	def unmaximize window_str
		window = self.wm.get_window window_str
		if window
			window.unmaximize
		end
	end
	def shade window_str
		window = self.wm.get_window window_str
		if window
			window.shade
			self.memory.set self.wm.workspace, 'shade', {
				'window_id' => window.id
			}
		end
	end
	def unshade window_str
		window = self.wm.get_window window_str
		if window
			window.unshade
			self.memory.set self.wm.workspace, 'unshade', {
				'window_id' => window.id
			}
		end
	end
	def unshade_last_shaded
		win_id = self.memory.get self.wm.workspace, 'shade', 'window_id'
		window = Wmctile::Window.new win_id, @settings
		if window
			window.unshade
			self.memory.set self.wm.workspace, 'unshade', {
				'window_id' => window.id
			}
		end
	end
	def snap where = 'left', window_str = nil, portion = 0.5
		self.wt.snap where, window_str, portion
	end
	def resize where = 'left', portion = 0.01
		self.wt.resize where, portion
	end
	def resize_snap where = 'left', portion = 0.01
		self.wt.resize_snap where, portion
	end

end