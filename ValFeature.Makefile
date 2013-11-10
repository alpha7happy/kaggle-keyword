$(ValFeatureDir)/%.Title.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(ValDataDir)/Dictionary.refined $(ValDataDir)/%.Title
	$^ $@

$(ValFeatureDir)/%.Body.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(ValDataDir)/Dictionary.refined $(ValDataDir)/%.Body
	$^ $@

$(ValFeatureDir)/%.Tags.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(ValDataDir)/Dictionary.Tags.refined $(ValDataDir)/%.Tags
	$^ $@

$(ValFeatureDir)/Projector.dat:\
$(ValFeatureDir)/Train.Title.BOW $(ValDataDir)/Dictionary.refined
	python $(CodeDir)/zyb/random_projection.py fit $^ $@ $(RandomProjectionLossRatio)

$(ValFeatureDir)/%.Reduced:\
$(ValFeatureDir)/%.BOW $(ValDataDir)/Dictionary.refined $(ValFeatureDir)/Projector.dat
	python $(CodeDir)/zyb/random_projection.py transform $^ $@

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
$(ValDataDir)/Train.Title $(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags
	$^ $@

ValFeature.all:\
$(ValFeatureDir)/Train.Title.BOW $(ValFeatureDir)/Train.Body.BOW\
$(ValFeatureDir)/Test.Title.BOW $(ValFeatureDir)/Test.Body.BOW\
$(ValFeatureDir)/Train.Tags.BOW $(ValFeatureDir)/Test.Tags.BOW\
$(ValFeatureDir)/Test.candTags $(ValFeatureDir)/Train.candTags\
$(ValFeatureDir)/P.wi $(ValFeatureDir)/P.ti $(ValFeatureDir)/P.tiwj\
$(ValFeatureDir)/Train.Title.Reduced $(ValFeatureDir)/Train.Body.Reduced\
$(ValFeatureDir)/Test.Title.Reduced $(ValFeatureDir)/Test.Body.Reduced\

ValFeature.no_reduced:\
$(ValFeatureDir)/Train.Title.BOW $(ValFeatureDir)/Train.Body.BOW\
$(ValFeatureDir)/Test.Title.BOW $(ValFeatureDir)/Test.Body.BOW\
$(ValFeatureDir)/Train.Tags.BOW $(ValFeatureDir)/Test.Tags.BOW\
$(ValFeatureDir)/Test.candTags $(ValFeatureDir)/Train.candTags\
$(ValFeatureDir)/P.wi $(ValFeatureDir)/P.ti $(ValFeatureDir)/P.tiwj\

ValFeature.reduced:\
$(ValFeatureDir)/Train.Title.Reduced $(ValFeatureDir)/Train.Body.Reduced\
$(ValFeatureDir)/Test.Title.Reduced $(ValFeatureDir)/Test.Body.Reduced\

ValFeature.clean:
	rm -f $(ValFeatureDir)/*
