$(ValRunDir)/ET.model:\
	$(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.tagBOW
	python $(CodeDir)/zyb/random_forest.py train ExtraTree $^ $@

$(ValRunDir)/ET.predict:\
$(ValRunDir)/ET.model $(ValFeatureDir)/Test.Body.BOW
	python $(CodeDir)/zyb/random_forest.py test $^ $@

$(ValRunDir)/RF.model:\
$(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.tagBOW
	python $(CodeDir)/zyb/random_forest.py train RandomForest $^ $@

$(ValRunDir)/RF.predict:\
$(ValRunDir)/RF.model $(ValFeatureDir)/Test.Body.BOW
	python $(CodeDir)/zyb/random_forest.py test $^ $@

$(ValRunDir)/NB.predict:\
$(ExecutableDir)/cxz/NB \
$(ValFeatureDir)/P.ti $(ValFeatureDir)/P.wi $(ValFeatureDir)/P.tiwj \
$(ValFeatureDir)/Test.Title.BOW $(ValFeatureDir)/Test.Body.BOW
	$^ NULL $@

$(ValRunDir)/%.evaluate:\
$(ExecutableDir)/cxz/f1score $(ValRunDir)/%.final $(ValFeatureDir)/Test.Tags.tagBOW
	$^

$(ValRunDir)/%.submit:\
$(ExecutableDir)/cxz/genSubmit $(GlobalDataDir)/TopTags.dict $(ValDataDir)/Test.Id $(ValRunDir)/%.final
	$^ $@

$(ValRunDir)/%.final:\
$(ExecutableDir)/cxz/finalbyTop $(ValRunDir)/%.predict
	$^ 3 $@

ValRun.all: ValData.all ValFeature.all

ValRun.clean:
	rm -f $(ValRunDir)/*
