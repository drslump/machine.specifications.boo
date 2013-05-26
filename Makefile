BOOC = booc
MSPEC = mspec
MSPEC_LIB = build/Machine.Specifications.dll

all:
	$(BOOC) @Machine.Specifications.Boo.rsp

debug:
	$(BOOC) -debug -d:TRACE @Machine.Specifications.Boo.rsp

test: debug
	cp lib/*.dll build/.
	$(BOOC) -debug -r:$(MSPEC_LIB) @Machine.Specifications.Boo.Specs.rsp
	$(MSPEC) build/Machine.Specifications.Boo.Specs.dll

clean:
	$(RM) build/*.dll build/*.mdb build/*.pdb
