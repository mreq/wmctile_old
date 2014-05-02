class Wmctile::Window < Wmctile::Class
	attr_accessor :id, :name, :title

	def initialize win_string, settings
		@settings = settings
		@id = win_string[/0x[\d\w]{8}/]
		self.get_name_and_title win_string
	end
	def get_name_and_title win_string
		if win_string == @id
			@name = ''
			@title = ''
		else
			after_id_and_workspace = win_string[14..-1].split(/\s+#{ @settings.hostname }\s+/, 2)
			@name = after_id_and_workspace[0]
			@title = after_id_and_workspace[1]
		end
	end
	def dmenu_item
		unless @dmenu_item
			str = "#{ @id }   #{ @name }#{ @title }"
			@dmenu_item = Dmenu::Item.new str, self
		end
		@dmenu_item
	end
	def name_length
		@name.length
	end
	def set_name_length name_length
		@name += ' '*(name_length - @name.length + 3)
	end
	def wmctrl wm_cmd, summon
		self.cmd "wmctrl -i#{ summon ? 'R' : 'r' } #{ @id } #{ wm_cmd }"
	end
	def move how_to_move
		a = $default_movement
		a.merge! how_to_move
		# a = self.add_win_borders(a)
		cmd = "-e 0,#{ a[:x] },#{ a[:y] },#{ a[:width] },#{ a[:height] }"
		self.unshade().wmctrl(cmd)
		return self
	end
	def shade
		self.wmctrl('-b add,shaded')
		return self
	end
	def unshade
		self.wmctrl('-b remove,shaded')
		return self
	end
end