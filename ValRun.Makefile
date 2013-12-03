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

$(ValRunDir)/RF.Title.model:\
$(ValFeatureDir)/Train.Title.BOW $(ValFeatureDir)/Train.Tags.tagBOW
	python $(CodeDir)/zyb/random_forest.py train RandomForest $^ $@

$(ValRunDir)/RF.Title.predict:\
$(ValRunDir)/RF.Title.model $(ValFeatureDir)/Test.Title.BOW
	python $(CodeDir)/zyb/random_forest.py test $^ $@

$(ValRunDir)/SGD.model:\
$(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.tagBOW
	python $(CodeDir)/zyb/sgd.py train log $^ $@

$(ValRunDir)/SGD.predict:\
$(ValRunDir)/SGD.model $(ValFeatureDir)/Test.Body.BOW
	python $(CodeDir)/zyb/sgd.py test $^ $@

$(ValRunDir)/SGD.SVM.model:\
$(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.tagBOW
	python $(CodeDir)/zyb/sgd.py train modified_huber $^ $@

$(ValRunDir)/SGD.SVM.predict:\
$(ValRunDir)/SGD.SVM.model $(ValFeatureDir)/Test.Body.BOW
	python $(CodeDir)/zyb/sgd.py test $^ $@

$(ValRunDir)/RF_split.model:\
$(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.tagBOW
	python $(CodeDir)/zyb/random_forest.py split_train RandomForest $^ 5 0.4 5 1 normalize_off $@

$(ValRunDir)/RF_split.y:\
$(ValRunDir)/RF_split.model $(ValFeatureDir)/Test.Body.BOW
	python $(CodeDir)/zyb/random_forest.py split_test $^ $(NTopTags) normalize_off $@

$(ValRunDir)/RF_split.predict:\
ValRun/RF_split.model ValRun/RF_split.y
	python $(CodeDir)/zyb/random_forest.py combine $^ 1500 $@

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
	$^ 1 $@

ValRun.all: ValData.all ValFeature.all

ValRun.clean:
	rm -f $(ValRunDir)/*
