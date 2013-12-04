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

$(ValRunDir)/RF.testonly.model:\
$(ValFeatureDir)/Train.Body.BOW $(ValFeatureDir)/Train.Tags.tagBOW
	python $(CodeDir)/zyb/random_forest.py train RandomForest $^ $@ 5000

$(ValRunDir)/RF.testonly.predict:\
$(ValRunDir)/RF.testonly.model $(ValFeatureDir)/Test.Body.BOW
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
	python $(CodeDir)/zyb/random_forest.py split_train RandomForest $^ 6 0.4 5 1 normalize_off $@

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
	$^ 3 $@

$(ValRunDir)/SVM/0.model:\
$(ExecutableDir)/cxz/SVM_learn\
$(ValFeatureDir)/Train.Merge.feature $(ValFeatureDir)/Train.Tags.tagBOW
	$^ $(ValRunDir)/SVM/ $(NTopTags)

$(ValRunDir)/SVM.predict:\
$(ExecutableDir)/cxz/SVM_predict\
$(ValFeatureDir)/Test.Merge.feature
	$^ $(ValRunDir)/SVM/ $(NTopTags) $@

$(ValRunDir)/libSVM.model:\
Tools/libSVM/svm-train $(ValFeatureDir)/Train.libFeature.scaled
	Tools/libSVM/svm-train -b 1 $(ValFeatureDir)/Train.libFeature.scaled $@ > $(ValRunDir)/libSVM.log

$(ValRunDir)/libSVM.trainerror:\
Tools/libSVM/svm-predict $(ValFeatureDir)/Train.libFeature.scaled $(ValRunDir)/libSVM.model
	Tools/libSVM/svm-predict -b 1 $(ValFeatureDir)/Train.libFeature.scaled $(ValRunDir)/libSVM.model $@

$(ValRunDir)/libSVM.predict:\
Tools/libSVM/svm-predict $(ValFeatureDir)/Test.svmFeature.scaled $(ValRunDir)/libSVM.model
	Tools/libSVM/svm-predict -b 1 $(ValFeatureDir)/Test.svmFeature.scaled $(ValRunDir)/libSVM.model $@


Val.SVM.clean:
	rm -f $(ValRunDir)/SVM.*
	rm -f -r $(ValRunDir)/SVM

ValRun.all: ValData.all ValFeature.all

ValRun.clean:
	rm -f $(ValRunDir)/*
