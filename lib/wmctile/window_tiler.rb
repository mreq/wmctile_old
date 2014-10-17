class Wmctile::WindowTiler < Wmctile::ClassWithDmenu
	attr_accessor :tiling_layouts
	##################################
	## init ##########################
	##################################
	def initialize settings, memory, wm = nil
		@settings = settings
		@memory = memory
		@wm = wm
		@tiling_layouts = ['[ | ]', '[---]', '[-|-]', '[ |-]', '[-| ]']
	end
	##################################
	## object getter methods #########
	##################################
	def wm
		@wm || @wm = Wmctile::WindowManager.new(@settings)
	end
	def memory
		@memory || @memory = Wmctile::Memory.new
	end
	##################################
	## actual snapping methods #######
	##################################
	def snap where = 'left', window_str = nil, portion = 0.5
		window = self.wm.get_window window_str
		if window
			how_to_move = self.wm.calculate_snap where, portion.to_f
			if how_to_move
				window.move how_to_move
				if ['left', 'right'].include? where
					window.maximize_vert
				elsif ['top', 'bottom']
					window.maximize_horiz
				end
				self.memory.set self.wm.workspace, 'snap', {
					'where' => where, 'portion' => portion, 'window_id' => window.id
				}
			end
		end
	end
	def resize where = 'left', portion = 0.01
		portion = portion.to_f
		# what are we moving? the last one used from these:
		methods = ['snap']
		freshest_meth = nil
		freshest_time = 0
		methods.each do |meth|
			time = self.memory.get self.wm.workspace, meth, 'time'
			if time > freshest_time
				freshest_time = time
				freshest_meth = meth
			end
		end
		# ok, got it, it's freshest_meth
		self.send "resize_#{ freshest_meth }", where, portion
	end
	def resize_snap where = 'left', portion = 0.01
		portion = portion.to_f
		info = self.memory.get self.wm.workspace, 'snap'
		if info.nil?
			return nil
		end
		negative = case info['where']
		when 'left'
			if where == 'left'	
				true
			elsif where == 'right'
				false
			else
				nil
			end
		when 'right'
			if where == 'left'	
				false
			elsif where == 'right'
				true
			else
				nil
			end
		when 'top'
			if where == 'bottom'	
				false
			elsif where == 'top'
				true
			else
				nil
			end
		when 'bottom'
			if where == 'top'	
				false
			elsif where == 'bottom'
				true
			else
				nil
			end
		end
		unless negative.nil?
			portion = -portion  if negative
			self.snap info['where'], info['window_id'], info['portion']+portion
		end
	end
	##################################
	## tiling methods ################
	##################################
	def tile layout = 'choose', ratio = 0.5, *args
		if layout == 'choose' or !(@tiling_layouts.include? layout)
			layout = self.dmenu @tiling_layouts
		end
		return  if layout.nil? or !(@tiling_layouts.include? layout)

		# do some work for ruby and convert ratio to a fixnum
		ratio = ratio.to_f
		
		# get the amount of windows needed
		if ['[ | ]', '[---]'].include? layout
			windows_needed = 2
		elsif '[-|-]' == layout
			windows_needed = 4
		else
			windows_needed = 3
		end

		# get windows from args
		windows = args.map { |str| self.wm.get_window str }
		# fill the rest with prompted windows
		(windows_needed - windows.length).times do windows.push self.wm.ask_for_window; end

		# now that we have the windows, apply the layout
		if layout == '[ | ]'
			self.snap 'left', windows[0], ratio
			self.snap 'right', windows[1], 1 - ratio
		elsif layout == '[---]'
			self.snap 'top', windows[0], ratio
			self.snap 'bottom', windows[1], 1 - ratio
		elsif layout == '[-|-]'
			self.snap 'topleft', windows[0], ratio
			self.snap 'bottomleft', windows[1], ratio
			self.snap 'topright', windows[2], 1 - ratio
			self.snap 'bottomright', windows[3], 1 - ratio
		elsif layout == '[ |-]'
			self.snap 'left', windows[0], ratio
			self.snap 'topright', windows[1], 1 - ratio
			self.snap 'bottomright', windows[2], 1 - ratio
		elsif layout == '[-| ]'
			self.snap 'topleft', windows[0], ratio
			self.snap 'bottomleft', windows[1], ratio
			self.snap 'right', windows[2], 1 - ratio
		end
	end
end