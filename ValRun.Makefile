ValRun.naiveTM:\
$(ExecutableDir)/cxz/naiveTM \
$(ValDataDir)/Test.Id $(ValDataDir)/Test.Title $(ValDataDir)/Test.Body $(ValFeatureDir)/Test.candTags \
$(ValFeatureDir)/P.tiwj $(ValFeatureDir)/P.ti $(ValFeatureDir)/P.wi
	$^ ValRun.naiveTM.predict

ValRun.all: ValData.all ValFeature.all

ValRun.clean:
	rm -f $(ValRunDir)/*
