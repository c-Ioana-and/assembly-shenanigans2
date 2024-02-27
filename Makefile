all: zip

zip:
	bash -c 'zip assignment3.zip */*.{S,asm} *.md'
