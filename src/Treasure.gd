extends MovableObject

# Desptide the bait namee, all this thing does is that it can't be moved by the players.
func canBePushed(_dir):
	return false
