class Wmctile::WindowTiler < Wmctile::Class
	def initialize settings, memory, wm = nil
		@settings = settings
		@memory = memory
		@wm = wm
	end

	def wm
		@wm || @wm = Wmctile::WindowManager.new(@settings)
	end
	def memory
		@memory || @memory = Wmctile::Memory.new
	end

	def snap where = 'left', window_str = nil, portion = 0.5
		window = self.wm.get_window window_str
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
end