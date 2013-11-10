$(ValFeatureDir)/%.tagBOW:\
$(ExecutableDir)/cxz/bowGenerator $(GlobalDataDir)/Tags.dict $(ValDataDir)/%
	$^ $@

$(ValFeatureDir)/%.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(ValDataDir)/Dictionary.refined $(ValDataDir)/%
	$^ $@

$(ValFeatureDir)/%.Reduced:\
$(ValFeatureDir)/%.BOW $(ValDataDir)/Dictionary.refined
	python $(CodeDir)/zyb/random_projection.py $^ $@ $(RandomProjectionLossRatio)

$(ValFeatureDir)/%.candTags:\
$(ExecutableDir)/cxz/candTagGenerator_Random $(GlobalDataDir)/Tags.dict \
$(ValDataDir)/%.Title $(ValDataDir)/%.Body $(ValDataDir)/%.Tags
	$^ $@ $(candTagSize)

$(ValFeatureDir)/P.wi:\
$(ExecutableDir)/cxz/calcPwi $(ValDataDir)/Dictionary.refined
	$^ $@

$(ValFeatureDir)/P.ti:\
$(ExecutableDir)/cxz/calcPwi $(GlobalDataDir)/Tags.dict
	$^ $@

$(ValFeatureDir)/P.tiwj:\
$(ExecutableDir)/cxz/calcPtiwj \
$(ValDataDir)/Dictionary.refined $(GlobalDataDir)/Tags.dict \
$(ValFeatureDir)/Train.Title.BOW $(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.tagBOW
	$^ $@

ValFeature.all:\
$(ValFeatureDir)/Train.Title.BOW $(ValFeatureDir)/Train.Body.BOW\
$(ValFeatureDir)/Train.Tags.tagBOW $(ValFeatureDir)/Test.Title.BOW\
$(ValFeatureDir)/Test.Body.BOW $(ValFeatureDir)/Test.Tags.tagBOW\
$(ValFeatureDir)/Test.candTags $(ValFeatureDir)/Train.candTags\
$(ValFeatureDir)/P.wi $(ValFeatureDir)/P.ti $(ValFeatureDir)/P.tiwj\
$(ValFeatureDir)/Train.Title.Reduced $(ValFeatureDir)/Train.Body.Reduced\
$(ValFeatureDir)/Test.Title.Reduced $(ValFeatureDir)/Test.Body.Reduced\

ValFeature.BOW:\
$(ValFeatureDir)/Train.Title.BOW $(ValFeatureDir)/Train.Body.BOW\
$(ValFeatureDir)/Test.Title.BOW $(ValFeatureDir)/Test.Body.BOW\
$(ValFeatureDir)/Train.Tags.BOW $(ValFeatureDir)/Test.Tags.BOW\
$(ValFeatureDir)/Test.candTags $(ValFeatureDir)/Train.candTags\

ValFeature.reduced:\
$(ValFeatureDir)/Train.Title.Reduced $(ValFeatureDir)/Train.Body.Reduced\
$(ValFeatureDir)/Test.Title.Reduced $(ValFeatureDir)/Test.Body.Reduced\

ValFeature.clean:
	rm -f $(ValFeatureDir)/*
