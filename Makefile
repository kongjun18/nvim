.PHONY: format
format:
	@stylua lua -g '!lua/packer_compiled.lua' -g '!lua/**/*.vim'
