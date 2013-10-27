$(ValFeatureDir)/%.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(ValDataDir)/Dictionary.refined $(ValDataDir)/%
	$^ $@

ValFeature.all:\
$(ValFeatureDir)/Train.Id.BOW $(ValFeatureDir)/Train.Title.BOW\
$(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.BOW\
$(ValFeatureDir)/Test.Id.BOW $(ValFeatureDir)/Test.Title.BOW\
$(ValFeatureDir)/Test.Body.BOW $(ValFeatureDir)/Test.Tags.BOW\

ValFeature.clean:
	rm -f $(ValFeatureDir)/*