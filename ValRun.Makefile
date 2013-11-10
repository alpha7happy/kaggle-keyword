$(ValRunDir)/NB.predict:\
$(ExecutableDir)/cxz/NB \
$(ValFeatureDir)/P.ti $(ValFeatureDir)/P.wi $(ValFeatureDir)/P.tiwj \
$(ValFeatureDir)/Test.Title.BOW $(ValFeatureDir)/Test.Body.BOW $(ValFeatureDir)/Test.candTags
	$^ $@

$(ValRunDir)/NB.predict.text:

ValRun.all: ValData.all ValFeature.all

ValRun.clean:
	rm -f $(ValRunDir)/*
