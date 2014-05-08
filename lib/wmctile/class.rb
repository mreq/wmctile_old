class Wmctile::Class
	def cmd cmd
		# [0..-2] to strip the last \n
		`#{ cmd }`[0..-2]
	end
	def notify title, string, icon = nil
		if icon
			system "notify-send -i '#{ icon }' '#{title}' '#{string}'"
		else	
			system "notify-send '#{title}' '#{string}'"
		end
	end
end