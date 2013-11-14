$(ValRunDir)/NB.predict:\
$(ExecutableDir)/cxz/NB \
$(ValFeatureDir)/P.ti $(ValFeatureDir)/P.wi $(ValFeatureDir)/P.tiwj \
$(ValFeatureDir)/Test.Title.BOW $(ValFeatureDir)/Test.Body.BOW
	$^ NULL $@

$(ValRunDir)/NB.evaluate:\
$(ExecutableDir)/cxz/f1score $(ValRunDir)/NB.final $(ValFeatureDir)/Test.Tags.tagBOW
	$^

$(ValRunDir)/%.submit:\
$(ExecutableDir)/cxz/genSubmit $(GlobalDataDir)/TopTags.dict $(ValDataDir)/Test.Id $(ValRunDir)/%.final
	$^ $@

$(ValRunDir)/%.final:\
$(ExecutableDir)/cxz/finalbyTop $(ValRunDir)/%.predict
	$^ 2 $@

ValRun.all: ValData.all ValFeature.all

ValRun.clean:
	rm -f $(ValRunDir)/*
