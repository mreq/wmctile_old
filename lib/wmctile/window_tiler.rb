class Wmctile::WindowTiler
	def initialize settings, wm = nil
		@settings = settings
		@wm = (wm.nil?) ? Wmctile::WindowManager.new(@settings) : wm
	end

	def snap window, where
		puts "Snapping window #{ window } to #{ where }."
	end
end