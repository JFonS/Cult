all: love

love:
	love-release -t GJB16 releases .
	love releases/GJB16.love
