# -*- mode:makefile-gmake; -*-
##########################################################################
##########################################################################

TASS:=64tass --m65c02 --cbm-prg -Wall -C --line-numbers

VOLUME:=beeb/
DEST:=$(VOLUME)/0
TMP:=.tmp

##########################################################################
##########################################################################

.PHONY:build
build:
	mkdir -p $(VOLUME)/0
	mkdir -p $(TMP)
	$(MAKE) assemble SRC=framework_test BBC=TEST
	ssd_create -4 3 -o 6845-tests.ssd $(DEST)/@.* $(DEST)/$$.!BOOT
#	-@$(MAKE) test_b2

##########################################################################
##########################################################################

.PHONY:assemble
assemble:
	mkdir -p $(DEST) $(TMP)
	$(TASS) $(SRC).s65 -L$(TMP)/$(SRC).lst -l$(TMP)/$(SRC).sym -o$(TMP)/$(SRC).prg
	python convert_prg.py $(TMP)/$(SRC).prg $(DEST)/@.$(BBC)

##########################################################################
##########################################################################

.PHONY:test_b2
test_b2:
	curl -G 'http://localhost:48075/reset/b2' --data-urlencode "config=Master 128 (MOS 3.20)"
	curl -H 'Content-Type:application/binary' --upload-file '$(NAME).ssd' 'http://localhost:48075/run/b2?name=$(NAME).ssd'
