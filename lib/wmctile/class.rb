class Wmctile::Class
	def cmd cmd
		# [0..-2] to strip the last \n
		`#{ cmd }`[0..-2]
	end
end