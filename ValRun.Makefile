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
