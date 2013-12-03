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

$(FullRunDir)/SVM.predict:\
$(ExecutableDir)/cxz/SVM\
$(FullFeatureDir)/Train.Title.BOW $(FullFeatureDir)/Train.Body.BOW $(FullFeatureDir)/Train.Tags.tagBOW\
$(FullRunDir)/SVM/test.data
	$^ $(FullRunDir)/SVM/ $(NTopTags) $@

$(FullRunDir)/SVM/test.data:\
$(ExecutableDir)/cxz/svmTestDataGen\
$(FullFeatureDir)/Test.Title.BOW $(FullFeatureDir)/Test.Body.BOW
	$^ $(FullRunDir)/SVM/

Full.SVM.clean:
	rm -f $(FullRunDir)/SVM.*
	rm -f -r $(FullRunDir)/SVM


FullRun.all: FullData.all FullFeature.all

FullRun.clean:
	rm -f $(FullRunDir)/*
