#FullData
$(FullDataDir)/Train.Id $(FullDataDir)/Train.Title\
$(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv\
$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/Tags.dict
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv \
	$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/Tags.dict \
	1 1 $(FullDataDir)/Train

$(FullDataDir)/Test.Id $(FullDataDir)/Test.Title\
$(FullDataDir)/Test.Body $(FullDataDir)/Test.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Test.csv\
$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/Tags.dict
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Test.csv \
	$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/Tags.dict \
	1 1 $(FullDataDir)/Test

$(FullDataDir)/Full.dict:\
$(FullDataDir)/Train.Title $(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags\
$(ExecutableDir)/cxz/dictGenerator
	$(ExecutableDir)/cxz/dictGenerator $@ $(FullDataDir)/Train.Title $(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags

$(FullDataDir)/Full.dict.refined:\
$(FullDataDir)/Full.dict $(ExecutableDir)/cxz/dictRefine
	$(ExecutableDir)/cxz/dictRefine $(FullDataDir)/Full.dict $@ 1000000

#ValData
$(ValDataDir)/Train.Id $(ValDataDir)/Train.Title\
$(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ValDataDir)/Test.Id $(ValDataDir)/Test.Title\
$(ValDataDir)/Test.Body $(ValDataDir)/Test.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv\
$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/Tags.dict
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv \
	$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/Tags.dict \
	2 0.7 $(ValDataDir)/Train 0.3 $(ValDataDir)/Test

$(ValDataDir)/Val.dict:\
$(ValDataDir)/Train.Title $(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ExecutableDir)/cxz/dictGenerator
	$(ExecutableDir)/cxz/dictGenerator $@ $(ValDataDir)/Train.Title $(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags

$(ValDataDir)/Val.dict.refined:\
$(ValDataDir)/Val.dict $(ExecutableDir)/cxz/dictRefine
	$(ExecutableDir)/cxz/dictRefine $(ValDataDir)/Val.dict $@ 1000000

#GlobalData
$(GlobalDataDir)/HTMLTags: $(ExecutableDir)/cxz/identifyHTMLTags $(RawDataDir)/Train.csv
	$(ExecutableDir)/cxz/identifyHTMLTags $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags
$(GlobalDataDir)/Tags.dict: $(ExecutableDir)/cxz/tagDictExtractor $(RawDataDir)/Train.csv
	$(ExecutableDir)/cxz/tagDictExtractor $(RawDataDir)/Train.csv $@

FullData.all:\
$(FullDataDir)/Train.Id $(FullDataDir)/Train.Title\
$(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags\
$(FullDataDir)/Test.Id $(FullDataDir)/Test.Title\
$(FullDataDir)/Test.Body $(FullDataDir)/Test.Tags\
$(FullDataDir)/Full.dict\
$(FullDataDir)/Full.dict.refined\

ValData.all:\
$(ValDataDir)/Train.Id $(ValDataDir)/Train.Title\
$(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ValDataDir)/Test.Id $(ValDataDir)/Test.Title\
$(ValDataDir)/Test.Body $(ValDataDir)/Test.Tags\
$(ValDataDir)/Val.dict\
$(ValDataDir)/Val.dict.refined\

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
