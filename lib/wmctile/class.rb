require 'open3'
require 'dmenu'

class Wmctile::Class
	def cmd cmd
		# [0..-2] to strip the last \n
		Open3.popen3(cmd) { |stdin, stdout| stdout.read[0..-2] }
	end
	def dmenu items
		a = Dmenu.new
		# override defaults
		a.case_insensitive = true
		a.font = 'Ubuntu Mono-12'
		a.background = '#242424'
		a.foreground = 'white'
		a.lines = 10
		a.position = :bottom
		a.selected_background = '#2e557e'
		a.items = items
		# run
		b = a.run()
		if b
			return b.value
		else
			return b
		end
	end
end