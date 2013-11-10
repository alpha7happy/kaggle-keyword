$(FullFeatureDir)/%.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(FullDataDir)/Dictionary.refined $(FullDataDir)/%
	$^ $@

FullFeature.all:\
$(FullFeatureDir)/Train.Id.BOW $(FullFeatureDir)/Train.Title.BOW\
$(FullFeatureDir)/Train.Body.BOW $(FullFeatureDir)/Train.Tags.tagBOW\
$(FullFeatureDir)/Test.Id.BOW $(FullFeatureDir)/Test.Title.BOW\
$(FullFeatureDir)/Test.Body.BOW $(FullFeatureDir)/Test.Tags.tagBOW\

FullFeature.clean:
	rm -f $(FullFeatureDir)/*