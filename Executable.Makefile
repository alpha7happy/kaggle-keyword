#$(ExecutableDir)/rawDataSpliter: $(CodeDir)/cxz/rawDataSpliter.cpp
#	g++ $(CodeDir)/cxz/rawDataSpliter.cpp -o $(ExecutableDir)/rawDataSpliter -O2

$(ExecutableDir)/%: $(CodeDir)/%.cpp
	g++ $< -o $@ -O2

$(CodeDir)/cxz/rawDataParser.cpp: $(CodeDir)/cxz/parseDoc.h
	touch $@

Executable.all:

Executable.clean:
	rm -f $(ExecutableDir)/cxz/*
	