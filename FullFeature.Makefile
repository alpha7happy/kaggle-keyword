$(FullFeatureDir)/%.tagBOW:\
$(ExecutableDir)/cxz/bowGenerator $(GlobalDataDir)/TopTags.dict $(FullDataDir)/%
	$^ $@

$(FullFeatureDir)/%.BOW:\
$(ExecutableDir)/cxz/bowGenerator $(FullDataDir)/Dictionary.refined $(FullDataDir)/%
	$^ $@

$(FullFeatureDir)/P.wi:\
$(ExecutableDir)/cxz/calcPwi $(FullDataDir)/Dictionary.refined
	$^ $@

$(FullFeatureDir)/P.ti:\
$(ExecutableDir)/cxz/calcPwi $(GlobalDataDir)/TopTags.dict
	$^ $@

$(FullFeatureDir)/P.tiwj:\
$(ExecutableDir)/cxz/calcPtiwj \
$(FullDataDir)/Dictionary.refined $(GlobalDataDir)/TopTags.dict \
$(FullFeatureDir)/Train.Title.BOW $(FullFeatureDir)/Train.Body.BOW $(FullFeatureDir)/Train.Tags.tagBOW
	$^ $@


FullFeature.all:\
$(FullFeatureDir)/Train.Id.BOW $(FullFeatureDir)/Train.Title.BOW\
$(FullFeatureDir)/Train.Body.BOW $(FullFeatureDir)/Train.Tags.tagBOW\
$(FullFeatureDir)/Test.Id.BOW $(FullFeatureDir)/Test.Title.BOW\
$(FullFeatureDir)/Test.Body.BOW $(FullFeatureDir)/Test.Tags.tagBOW\

FullFeature.clean:
	rm -f $(FullFeatureDir)/*