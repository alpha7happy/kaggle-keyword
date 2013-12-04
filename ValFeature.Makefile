$(ValFeatureDir)/%.tagBOW:\
$(ExecutableDir)/cxz/bowGenerator $(GlobalDataDir)/TopTags.dict $(ValDataDir)/%
	$^ $@

$(ValFeatureDir)/%.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(ValDataDir)/Dictionary.refined $(ValDataDir)/%
	$^ $@

$(ValFeatureDir)/%.tfidf:\
$(ExecutableDir)/cxz/tfidfGenerator $(ValDataDir)/idfDict $(ValFeatureDir)/%.BOW
	$^ $@

#$(ValFeatureDir)/%.Reduced:\
#$(ValFeatureDir)/%.BOW $(ValDataDir)/Dictionary.refined
#	python $(CodeDir)/zyb/random_projection.py $^ $@ $(RandomProjectionLossRatio)

$(ValFeatureDir)/%.candTags:\
$(ExecutableDir)/cxz/candTagGenerator_Random $(GlobalDataDir)/TopTags.dict \
$(ValFeatureDir)/%.Title.BOW $(ValFeatureDir)/%.Body.BOW $(ValFeatureDir)/%.Tags.tagBOW
	$^ $@ $(candTagSize)

$(ValFeatureDir)/P.wi:\
$(ExecutableDir)/cxz/calcPwi $(ValDataDir)/Dictionary.refined
	$^ $@

$(ValFeatureDir)/P.ti:\
$(ExecutableDir)/cxz/calcPwi $(GlobalDataDir)/TopTags.dict
	$^ $@

$(ValFeatureDir)/P.tiwj:\
$(ExecutableDir)/cxz/calcPtiwj \
$(ValDataDir)/Dictionary.refined $(GlobalDataDir)/TopTags.dict \
$(ValFeatureDir)/Train.Title.BOW $(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.tagBOW
	$^ $@

$(ValFeatureDir)/%.NB.pred:\
$(ExecutableDir)/cxz/NB \
$(ValFeatureDir)/P.ti $(ValFeatureDir)/P.wi $(ValFeatureDir)/P.tiwj \
$(ValFeatureDir)/%.Title.BOW $(ValFeatureDir)/%.Body.BOW
	$^ NULL $@

$(ValFeatureDir)/%.softmax:\
$(ExecutableDir)/cxz/softmax \
$(ValFeatureDir)/%
	$^ $@

$(ValFeatureDir)/Test.Merge.feature:\
$(ExecutableDir)/cxz/mergeFeature\
$(ValFeatureDir)/Test.Body.BOW\
$(ValFeatureDir)/Test.NB.pred.softmax
	$(ExecutableDir)/cxz/mergeFeature 1 \
	$(ValFeatureDir)/Test.NB.pred.softmax $(candTagSize) \
	$@

$(ValFeatureDir)/Train.Merge.feature:\
$(ExecutableDir)/cxz/mergeFeature\
$(ValFeatureDir)/Train.Body.BOW\
$(ValFeatureDir)/Train.NB.pred.softmax
	$(ExecutableDir)/cxz/mergeFeature 1 \
	$(ValFeatureDir)/Train.NB.pred.softmax $(candTagSize) \
	$@

$(ValFeatureDir)/Train.Merge.Scaled.feature:\
Tools/libSVM/svm-scale $(ValFeatureDir)/Train.Merge.feature
	Tools/libSVM/svm-scale -l -1 -u 1 -s range $(ValFeatureDir)/Train.Merge.feature > $@

$(ValFeatureDir)/Test.Merge.Scaled.feature:\
Tools/libSVM/svm-scale $(ValFeatureDir)/Test.Merge.feature
	Tools/libSVM/svm-scale -r range $(ValFeatureDir)/Test.Merge.feature > $@

$(ValFeatureDir)/Train.libFeature:\
$(ExecutableDir)/cxz/libSVMDataGen\
$(ValFeatureDir)/Train.Merge.feature $(ValFeatureDir)/Train.Tags.tagBOW
	$^ $@

$(ValFeatureDir)/Test.svmFeature:\
$(ExecutableDir)/cxz/svmTestDataGen $(ValFeatureDir)/Test.Merge.feature
	$^ $@

$(ValFeatureDir)/Train.libFeature.scaled range:\
Tools/libSVM/svm-scale $(ValFeatureDir)/Train.libFeature
	Tools/libSVM/svm-scale -l -1 -u 1 -s range $(ValFeatureDir)/Train.libFeature > $@

$(ValFeatureDir)/Test.svmFeature.scaled:\
Tools/libSVM/svm-scale $(ValFeatureDir)/Test.svmFeature range
	Tools/libSVM/svm-scale -r range $(ValFeatureDir)/Test.svmFeature > $@

ValFeature.all:\
$(ValFeatureDir)/Train.Title.BOW $(ValFeatureDir)/Train.Body.BOW\
$(ValFeatureDir)/Train.Tags.tagBOW $(ValFeatureDir)/Test.Title.BOW\
$(ValFeatureDir)/Test.Body.BOW $(ValFeatureDir)/Test.Tags.tagBOW\
$(ValFeatureDir)/Test.candTags $(ValFeatureDir)/Train.candTags\
$(ValFeatureDir)/P.wi $(ValFeatureDir)/P.ti $(ValFeatureDir)/P.tiwj\
#$(ValFeatureDir)/Train.Title.Reduced $(ValFeatureDir)/Train.Body.Reduced\
#$(ValFeatureDir)/Test.Title.Reduced $(ValFeatureDir)/Test.Body.Reduced\

ValFeature.BOW:\
$(ValFeatureDir)/Train.Title.BOW $(ValFeatureDir)/Train.Body.BOW\
$(ValFeatureDir)/Test.Title.BOW $(ValFeatureDir)/Test.Body.BOW\
$(ValFeatureDir)/Train.Tags.BOW $(ValFeatureDir)/Test.Tags.BOW\
$(ValFeatureDir)/Test.candTags $(ValFeatureDir)/Train.candTags\

#ValFeature.reduced:\
#$(ValFeatureDir)/Train.Title.Reduced $(ValFeatureDir)/Train.Body.Reduced\
#$(ValFeatureDir)/Test.Title.Reduced $(ValFeatureDir)/Test.Body.Reduced\

ValFeature.clean:
	rm -f $(ValFeatureDir)/*
