require 'dmenu'

class Wmctile::ClassWithDmenu < Wmctile::Class
	def dmenu items
		a = Dmenu.new
		# override defaults
		a.background = '#242424'
		a.case_insensitive = true
		a.font = 'Ubuntu Mono-12'
		a.foreground = 'white'
		a.lines = 10
		a.position = :bottom
		a.selected_background = '#2e557e'
		# set items
		a.items = items
		# run
		b = a.run()
		if b.is_a? Dmenu::Item
			return b.value
		else
			return b
		end
	end
end