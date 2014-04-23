class Wmctile::Router

	def initialize
		@settings = Wmctile::Settings.new
	end

	def dispatch args
		if args[0] and args[0] != 'dispatch' and self.respond_to? args[0]
			self.send args[0], *args.drop(1)
		else
			self.help
		end
	end

	def help args = nil
		puts 'help'
	end
	def snap where = 'left', window = nil
		if window.nil?
			window = self.wm.ask_for_window
		else
			window = self.wm.find_window window
		end
		self.wt.snap window, where
	end


	def wm
		@wm || @wm = Wmctile::WindowManager.new(@settings)
	end
	def wt
		@wt || @wt = Wmctile::WindowTiler.new(@settings)
	end

end