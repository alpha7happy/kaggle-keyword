$(FullDataDir)/Train.Id $(FullDataDir)/Train.Title\
$(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags 1 1 $(FullDataDir)/Train


$(FullDataDir)/Test.Id $(FullDataDir)/Test.Title\
$(FullDataDir)/Test.Body $(FullDataDir)/Test.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Test.csv $(GlobalDataDir)/HTMLTags
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Test.csv $(GlobalDataDir)/HTMLTags 1 1 $(FullDataDir)/Test


$(ValDataDir)/Train.Id $(ValDataDir)/Train.Title\
$(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ValDataDir)/Val.Id $(ValDataDir)/Val.Title\
$(ValDataDir)/Val.Body $(ValDataDir)/Val.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags 2 0.7 $(ValDataDir)/Train 0.3 $(ValDataDir)/Val


$(GlobalDataDir)/HTMLTags: $(ExecutableDir)/cxz/identifyHTMLTags $(RawDataDir)/Train.csv
	$(ExecutableDir)/cxz/identifyHTMLTags $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags

FullData.all:\
$(FullDataDir)/Train.Id $(FullDataDir)/Train.Title\
$(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags\
$(FullDataDir)/Test.Id $(FullDataDir)/Test.Title\
$(FullDataDir)/Test.Body $(FullDataDir)/Test.Tags\

ValData.all:\
$(ValDataDir)/Train.Id $(ValDataDir)/Train.Title\
$(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ValDataDir)/Val.Id $(ValDataDir)/Val.Title\
$(ValDataDir)/Val.Body $(ValDataDir)/Val.Tags\

GlobalData.all:\
$(GlobalDataDir)/HTMLTags\

FullData.clean:
	rm $(FullDataDir)/*

ValData.clean:
	rm $(ValDataDir)/*

GlobalData.clean:
	rm $(GlobalDataDir)/*

Data.all: ValData.all FullData.all GlobalData.all

Data.clean: ValData.clean FullData.clean GlobalData.clean
