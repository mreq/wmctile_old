class Wmctile::Router < Wmctile::Class
	##################################
	## init ##########################
	##################################
	def initialize
		@settings = Wmctile::Settings.new
	end
	##################################
	## main dispatch method ##########
	##################################
	def dispatch args = []
		if args[0] and args[0] != 'dispatch' and self.respond_to? args[0]
			self.send args[0], *args.drop(1)
		else
			self.help
		end
	end
	##################################
	## window getters ################
	##################################
	def get_window window_str = nil, current_workspace_only = true
		if window_str.nil?
			window = self.wm.ask_for_window current_workspace_only
		else
			if window_str == ':ACTIVE:'
				window = self.get_active_window
			else
				window = self.wm.find_window window_str, current_workspace_only
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
	##################################
	## objects getter methods ########
	##################################
	def wm
		@wm || @wm = Wmctile::WindowManager.new(@settings)
	end
	def wt
		@wt || @wt = Wmctile::WindowTiler.new(@settings)
	end
	def memory
		@memory || @memory = Wmctile::Memory.new
	end
	##################################
	## various helpers ###############
	##################################
	def notify title, string, icon = nil
		if icon
			system "notify-send -i '#{ icon }' '#{title}' '#{string}'"
		else	
			system "notify-send '#{title}' '#{string}'"
		end
	end
	##################################
	## actual command-line methods ###
	##################################
	def help args = nil
		puts 'help'
	end
	def snap where = 'left', window_str = nil, portion = 0.5
		window = self.get_window window_str
		if window
			how_to_move = self.wm.calculate_snap where, portion.to_f
			if how_to_move
				window.move how_to_move
				self.memory.set self.wm.workspace, 'snap', {
					'where' => where, 'portion' => portion, 'window_id' => window.id
				}
			end
		end
	end
	def summon window_str
		window = self.get_window window_str, false
		if window
			window.summon
			return true
		else
			return false
		end
	end
	def summon_in_workspace window_str
		window = self.get_window window_str, true
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
	def summon_in_workspace_or_run window_str, cmd_to_run
		unless self.summon_in_workspace window_str
			self.cmd "#{ cmd_to_run } > /dev/null &"
		end
	end
	def maximize window_str
		window = self.get_window window_str
		if window
			window.maximize
		end
	end
	def unmaximize window_str
		window = self.get_window window_str
		if window
			window.unmaximize
		end
	end
	def shade window_str
		window = self.get_window window_str
		if window
			window.shade
			self.memory.set self.wm.workspace, 'shade', {
				'window_id' => window.id
			}
		end
	end
	def unshade window_str
		window = self.get_window window_str
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

end