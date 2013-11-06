$(ValFeatureDir)/%.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(ValDataDir)/Dictionary.refined $(ValDataDir)/%
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

ValFeature.all:\
$(ValFeatureDir)/Train.Id.BOW $(ValFeatureDir)/Train.Title.BOW\
$(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.BOW\
$(ValFeatureDir)/Test.Id.BOW $(ValFeatureDir)/Test.Title.BOW\
$(ValFeatureDir)/Test.Body.BOW $(ValFeatureDir)/Test.Tags.BOW\
$(ValFeatureDir)/Test.candTags $(ValFeatureDir)/Train.candTags\
$(ValFeatureDir)/Train.Title.Reduced $(ValFeatureDir)/Train.Body.Reduced\
$(ValFeatureDir)/Test.Title.Reduced $(ValFeatureDir)/Test.Body.Reduced\

ValFeature.reduced:\
$(ValFeatureDir)/Train.Title.Reduced $(ValFeatureDir)/Train.Body.Reduced\
$(ValFeatureDir)/Test.Title.Reduced $(ValFeatureDir)/Test.Body.Reduced\

ValFeature.clean:
	rm -f $(ValFeatureDir)/*
