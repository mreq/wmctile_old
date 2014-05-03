class Wmctile::Window < Wmctile::Class
	attr_accessor :id, :name, :title

	def initialize win_string, settings
		@default_movement = { :x => 0, :y => 0, :width => '-1', :height => '-1' }
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
			str = "#{ @id } #{ @name } #{ @title }"
			@dmenu_item = Dmenu::Item.new str, self
		end
		@dmenu_item
	end
	def get_name
		if @name == ''
			self.get_name_and_title self.cmd('wmctrl -lx | grep ' + @id)
		end
		@name
	end
	def get_name_length
		@name.length
	end
	def set_name_length name_length
		@name += ' '*(name_length - @name.length)
	end
	def wmctrl wm_cmd = '', summon = false
		self.cmd "wmctrl -i#{ summon ? 'R' : 'r' } #{ @id } #{ wm_cmd }"
		return self # return self so that commands can be chained
	end
	def move how_to_move = {}
		how_to_move = @default_movement.merge! how_to_move
		cmd = "-e 0,#{ how_to_move[:x] },#{ how_to_move[:y] },#{ how_to_move[:width] },#{ how_to_move[:height] } -b remove,shaded"
		self.wmctrl cmd
	end
	def shade
		self.wmctrl '-b add,shaded'
	end
	def unshade
		self.wmctrl '-b remove,shaded'
	end
	def summon
		self.wmctrl '-b remove,shaded', true
	end
end