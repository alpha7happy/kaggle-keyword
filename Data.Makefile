#FullData
$(FullDataDir)/Train.Id $(FullDataDir)/Train.Title\
$(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags 1 1 $(FullDataDir)/Train


$(FullDataDir)/Test.Id $(FullDataDir)/Test.Title\
$(FullDataDir)/Test.Body $(FullDataDir)/Test.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Test.csv $(GlobalDataDir)/HTMLTags
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Test.csv $(GlobalDataDir)/HTMLTags 1 1 $(FullDataDir)/Test

$(FullDataDir)/Train.dict:\
$(FullDataDir)/Train.Title $(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags\
$(ExecutableDir)/cxz/dictGenerator
	$(ExecutableDir)/cxz/dictGenerator $@ $(FullDataDir)/Train.Title $(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags

$(FullDataDir)/Train.dict.refined:\
$(FullDataDir)/Train.dict $(ExecutableDir)/cxz/dictRefine
	$(ExecutableDir)/cxz/dictRefine $(FullDataDir)/Train.dict $@ 1000000

#ValData
$(ValDataDir)/Train.Id $(ValDataDir)/Train.Title\
$(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ValDataDir)/Val.Id $(ValDataDir)/Val.Title\
$(ValDataDir)/Val.Body $(ValDataDir)/Val.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags 2 0.7 $(ValDataDir)/Train 0.3 $(ValDataDir)/Val

#GlobalData
$(GlobalDataDir)/HTMLTags: $(ExecutableDir)/cxz/identifyHTMLTags $(RawDataDir)/Train.csv
	$(ExecutableDir)/cxz/identifyHTMLTags $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags

FullData.all:\
$(FullDataDir)/Train.Id $(FullDataDir)/Train.Title\
$(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags\
$(FullDataDir)/Test.Id $(FullDataDir)/Test.Title\
$(FullDataDir)/Test.Body $(FullDataDir)/Test.Tags\
$(FullDataDir)/Train.dict\
$(FullDataDir)/Train.dict.refined\

ValData.all:\
$(ValDataDir)/Train.Id $(ValDataDir)/Train.Title\
$(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ValDataDir)/Val.Id $(ValDataDir)/Val.Title\
$(ValDataDir)/Val.Body $(ValDataDir)/Val.Tags\

GlobalData.all:\
$(GlobalDataDir)/HTMLTags\

FullData.clean:
	rm -f $(FullDataDir)/*

ValData.clean:
	rm -f $(ValDataDir)/*

GlobalData.clean:
	rm -f $(GlobalDataDir)/*

Data.all: ValData.all FullData.all GlobalData.all

Data.clean: ValData.clean FullData.clean GlobalData.clean
