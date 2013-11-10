BOOC = booc
BOO_LIB = packages/Boo.0.9.4/lib/Boo.Lang.dll
MSPEC = mspec
MSPEC_LIB = packages/Machine.Specifications.0.5.16/lib/net40/Machine.Specifications.dll
NUNIT = nunit-console
NUNIT_LIB = packages/NUnit.2.6.3/lib/nunit.framework.dll
NUGET = nuget

all:
	$(BOOC) @Machine.Specifications.Boo.rsp

install:
	$(NUGET) install -o packages

debug:
	$(BOOC) -debug @Machine.Specifications.Boo.rsp

test: debug
	cp $(BOO_LIB) $(MSPEC_LIB) $(NUNIT_LIB) build/.

	$(BOOC) -debug @Machine.Specifications.Boo.Specs.rsp

	$(MSPEC) build/Machine.Specifications.Boo.Specs.dll


clean:
	$(RM) build/*
