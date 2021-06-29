default: test
	@make windows
	@make macos
	@make linux

test:
	@v -stats test .

format:
	@v fmt -w *.v **/*.v

format-check:
	@v fmt -c *.v **/*.v

windows:
	@v -prod -os windows -m64 -o ./bin/kpv_win main.v

macos:
	@v -prod -os macos -m64 -o ./bin/kpv_osx main.v

linux:
	@v -prod -os linux -m64 -o ./bin/kpv_linux main.v