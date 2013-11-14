#FullData
$(FullDataDir)/Train.Id $(FullDataDir)/Train.Title\
$(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv\
$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/TopTags.dict
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv \
	$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/TopTags.dict \
	1 1 $(FullDataDir)/Train

$(FullDataDir)/Test.Id $(FullDataDir)/Test.Title\
$(FullDataDir)/Test.Body $(FullDataDir)/Test.Tags:\
$(ExecutableDir)/cxz/rawDataParserTest $(RawDataDir)/Test.csv\
$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/TopTags.dict
	$(ExecutableDir)/cxz/rawDataParserTest $(RawDataDir)/Test.csv \
	$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/TopTags.dict \
	1 1 $(FullDataDir)/Test

$(FullDataDir)/Dictionary:\
$(FullDataDir)/Train.Title $(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags\
$(ExecutableDir)/cxz/dictGenerator
	$(ExecutableDir)/cxz/dictGenerator $@ $(FullDataDir)/Train.Title $(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags

$(FullDataDir)/Dictionary.refined:\
$(FullDataDir)/Dictionary $(ExecutableDir)/cxz/dictRefine
	$(ExecutableDir)/cxz/dictRefine $(FullDataDir)/Dictionary $@ $(DictionarySize)

#ValData
$(ValDataDir)/Train.Id $(ValDataDir)/Train.Title\
$(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ValDataDir)/Test.Id $(ValDataDir)/Test.Title\
$(ValDataDir)/Test.Body $(ValDataDir)/Test.Tags:\
$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv\
$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/TopTags.dict
	$(ExecutableDir)/cxz/rawDataParser $(RawDataDir)/Train.csv \
	$(GlobalDataDir)/HTMLTags $(GlobalDataDir)/TopTags.dict \
	2 $(ValTrainRatio) $(ValDataDir)/Train $(ValTestRatio) $(ValDataDir)/Test

$(ValDataDir)/Dictionary:\
$(ValDataDir)/Train.Title $(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ExecutableDir)/cxz/dictGenerator
	$(ExecutableDir)/cxz/dictGenerator $@ $(ValDataDir)/Train.Title $(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags

$(ValDataDir)/Dictionary.refined:\
$(ValDataDir)/Dictionary $(ExecutableDir)/cxz/dictRefine
	$(ExecutableDir)/cxz/dictRefine $(ValDataDir)/Dictionary $@ $(DictionarySize)

$(ValDataDir)/Dictionary.Tags:\
$(ValDataDir)/Train.Tags $(ExecutableDir)/cxz/dictGenerator
	$(ExecutableDir)/cxz/dictGenerator $@ $(ValDataDir)/Train.Tags

$(ValDataDir)/Dictionary.Tags.refined:\
$(ValDataDir)/Dictionary.Tags $(ExecutableDir)/cxz/dictRefine
	$(ExecutableDir)/cxz/dictRefine $(ValDataDir)/Dictionary.Tags $@ $(TagDictionarySize)

#GlobalData
$(GlobalDataDir)/HTMLTags: $(ExecutableDir)/cxz/identifyHTMLTags $(RawDataDir)/Train.csv
	$(ExecutableDir)/cxz/identifyHTMLTags $(RawDataDir)/Train.csv $(GlobalDataDir)/HTMLTags
$(GlobalDataDir)/Tags.dict: $(ExecutableDir)/cxz/tagDictExtractor $(RawDataDir)/Train.csv
	$(ExecutableDir)/cxz/tagDictExtractor $(RawDataDir)/Train.csv $@
$(GlobalDataDir)/TopTags.dict: $(ExecutableDir)/cxz/topTags $(GlobalDataDir)/Tags.dict
	$^ $(NTopTags) $@

FullData.all: GlobalData.all\
$(FullDataDir)/Train.Id $(FullDataDir)/Train.Title\
$(FullDataDir)/Train.Body $(FullDataDir)/Train.Tags\
$(FullDataDir)/Test.Id $(FullDataDir)/Test.Title\
$(FullDataDir)/Test.Body $(FullDataDir)/Test.Tags\
$(FullDataDir)/Dictionary\
$(FullDataDir)/Dictionary.refined\

ValData.all: GlobalData.all\
$(ValDataDir)/Train.Id $(ValDataDir)/Train.Title\
$(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags\
$(ValDataDir)/Test.Id $(ValDataDir)/Test.Title\
$(ValDataDir)/Test.Body $(ValDataDir)/Test.Tags\
$(ValDataDir)/Dictionary\
$(ValDataDir)/Dictionary.refined\

GlobalData.all:\
$(GlobalDataDir)/HTMLTags\
$(GlobalDataDir)/TopTags.dict

FullData.clean:
	rm -f $(FullDataDir)/*

ValData.clean:
	rm -f $(ValDataDir)/*

GlobalData.clean:
	rm -f $(GlobalDataDir)/*

Data.all: ValData.all FullData.all GlobalData.all

Data.clean: ValData.clean FullData.clean GlobalData.clean
