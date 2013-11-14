$(FullRunDir)/NB.predict:\
$(ExecutableDir)/cxz/NB \
$(FullFeatureDir)/P.ti $(FullFeatureDir)/P.wi $(FullFeatureDir)/P.tiwj \
$(FullFeatureDir)/Test.Title.BOW $(FullFeatureDir)/Test.Body.BOW
	$^ NULL $@

$(FullRunDir)/%.final:\
$(ExecutableDir)/cxz/finalbyTop $(FullRunDir)/%.predict
	$^ 3 $@

$(FullRunDir)/%.submit:\
$(ExecutableDir)/cxz/genSubmit $(GlobalDataDir)/TopTags.dict $(FullDataDir)/Test.Id $(FullRunDir)/%.final
	$^ $@

FullRun.all: FullData.all FullFeature.all

FullRun.clean:
	rm -f $(FullRunDir)/*
