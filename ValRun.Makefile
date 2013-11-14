$(ValRunDir)/NB.predict:\
$(ExecutableDir)/cxz/NB \
$(ValFeatureDir)/P.ti $(ValFeatureDir)/P.wi $(ValFeatureDir)/P.tiwj \
$(ValFeatureDir)/Test.Title.BOW $(ValFeatureDir)/Test.Body.BOW $(ValFeatureDir)/Test.candTags
	$^ $@

$(ValRunDir)/%.tagView:\
$(ExecutableDir)/cxz/tagView $(GlobalDataDir)/Tags.dict $(ValRunDir)/%.predict
	$^ $@

$(ValRunDir)/%.final:\
$(ExecutableDir)/cxz/finalbyTop $(ValRunDir)/%.predict
	$^ 2 $@

$(ValRunDir)/NB.evaluate:\
$(ExecutableDir)/cxz/f1score $(ValRunDir)/NB.final $(ValFeatureDir)/Test.Tags.tagBOW
	$^

ValRun.all: ValData.all ValFeature.all

ValRun.clean:
	rm -f $(ValRunDir)/*
