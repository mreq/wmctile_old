class Wmctile::WindowTiler < Wmctile::Class
	def initialize settings, wm = nil
		@settings = settings
		@wm = wm
	end

	def wm
		@wm || @wm = Wmctile::WindowManager.new(@settings)
	end
end