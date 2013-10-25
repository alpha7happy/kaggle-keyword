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

$(FullDataDir)/Dictionary:\
$(FullDataDir)/Train.Title $(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags\
$(ExecutableDir)/cxz/dictGenerator
	$(ExecutableDir)/cxz/dictGenerator $@ $(FullDataDir)/Train.Title $(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags

$(FullDataDir)/Dictionary.refined:\
$(FullDataDir)/Dictionary $(ExecutableDir)/cxz/dictRefine
	$(ExecutableDir)/cxz/dictRefine $(FullDataDir)/Dictionary $@ 1000000

$(FullDataDir)/%.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(FullDataDir)/Dictionary.refined $(FullDataDir)/%
	$^ $@

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

$(ValDataDir)/Dictionary:\
$(ValDataDir)/Train.Title $(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ExecutableDir)/cxz/dictGenerator
	$(ExecutableDir)/cxz/dictGenerator $@ $(ValDataDir)/Train.Title $(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags

$(ValDataDir)/Dictionary.refined:\
$(ValDataDir)/Dictionary $(ExecutableDir)/cxz/dictRefine
	$(ExecutableDir)/cxz/dictRefine $(ValDataDir)/Dictionary $@ 1000000

$(ValDataDir)/%.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(ValDataDir)/Dictionary.refined $(ValDataDir)/%
	$^ $@

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
$(FullDataDir)/Train.Id.BOW $(FullDataDir)/Train.Title.BOW\
$(FullDataDir)/Train.Body.BOW $(FullDataDir)/Train.Tags.BOW\
$(FullDataDir)/Test.Id.BOW $(FullDataDir)/Test.Title.BOW\
$(FullDataDir)/Test.Body.BOW $(FullDataDir)/Test.Tags.BOW\
$(FullDataDir)/Dictionary\
$(FullDataDir)/Dictionary.refined\

ValData.all:\
$(ValDataDir)/Train.Id $(ValDataDir)/Train.Title\
$(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ValDataDir)/Test.Id $(ValDataDir)/Test.Title\
$(ValDataDir)/Test.Body $(ValDataDir)/Test.Tags\
$(ValDataDir)/Train.Id.BOW $(ValDataDir)/Train.Title.BOW\
$(ValDataDir)/Train.Body.BOW $(ValDataDir)/Train.Tags.BOW\
$(ValDataDir)/Test.Id.BOW $(ValDataDir)/Test.Title.BOW\
$(ValDataDir)/Test.Body.BOW $(ValDataDir)/Test.Tags.BOW\
$(ValDataDir)/Dictionary\
$(ValDataDir)/Dictionary.refined\

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
