include Config.Makefile
include Data.Makefile
include Feature.Makefile
include Executable.Makefile
include Run.Makefile


all: Config.all Data.all Feature.all Executable.all Run.all

Validation: ValRun.all

Full: FullRun.all

clean: Config.clean Data.clean Feature.clean Executable.clean Run.clean