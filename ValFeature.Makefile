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
$(ValDataDir)/Train.Title $(ValDataDir)/Train.Body $(ValDataDir)/Train.Tags
	$^ $@

ValFeature.all:\
$(ValFeatureDir)/Train.Id.BOW $(ValFeatureDir)/Train.Title.BOW\
$(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.BOW\
$(ValFeatureDir)/Test.Id.BOW $(ValFeatureDir)/Test.Title.BOW\
$(ValFeatureDir)/Test.Body.BOW $(ValFeatureDir)/Test.Tags.BOW\
$(ValFeatureDir)/Test.candTags $(ValFeatureDir)/Train.candTags\
<<<<<<< HEAD
$(ValFeatureDir)/P.wi $(ValFeatureDir)/P.ti $(ValFeatureDir)/P.tiwj\

=======
$(ValFeatureDir)/Train.Title.Reduced $(ValFeatureDir)/Train.Body.Reduced\
$(ValFeatureDir)/Test.Title.Reduced $(ValFeatureDir)/Test.Body.Reduced\

ValFeature.reduced:\
$(ValFeatureDir)/Train.Title.Reduced $(ValFeatureDir)/Train.Body.Reduced\
$(ValFeatureDir)/Test.Title.Reduced $(ValFeatureDir)/Test.Body.Reduced\
>>>>>>> 8a1c56c2bcb46a40faab0c6c36b4972c3f92e50b

ValFeature.clean:
	rm -f $(ValFeatureDir)/*
