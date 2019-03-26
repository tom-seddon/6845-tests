# -*- mode:makefile-gmake; -*-
##########################################################################
##########################################################################

TASSEXE?=64tass
PYTHON?=python

TASS:=$(TASSEXE) --m65c02 --cbm-prg -Wall -C --line-numbers

VOLUME:=beeb/
DEST:=$(VOLUME)/0
TMP:=.tmp
SSD:=ssds

##########################################################################
##########################################################################

.PHONY:build
build:
	mkdir -p $(VOLUME)/0
	mkdir -p $(TMP)
	mkdir -p $(SSD)
	$(MAKE) assemble SRC=framework_test BBC=TEST
	$(MAKE) assemble SRC=r6 BBC=R6
	$(MAKE) assemble SRC=r6-2 BBC=R6-2
	$(MAKE) assemble SRC=r7-time BBC=R7-TIME
	$(MAKE) assemble SRC=r7-pos BBC=R7-POS
	$(MAKE) assemble SRC=mode7-disen BBC=M7DISEN
	$(MAKE) assemble SRC=r4-1 BBC=R4-1
	$(MAKE) assemble SRC=scr-screen BBC=SCR-SCR
	$(MAKE) assemble SRC=r4-2 BBC=R4-2
	$(MAKE) assemble SRC=r4-3 BBC=R4-3
	$(MAKE) assemble SRC=curs-1 BBC=CURS-1
	$(PYTHON) submodules/beeb/ssd_create.py -4 3 -o $(SSD)/6845-tests.ssd $(DEST)/@.* $(DEST)/$$.!BOOT $(DEST)/$$.SCREEN $(DEST)/$$.SCREEN2 $(DEST)/$$.SCR-HUD $(DEST)/$$.MENU
#	-@$(MAKE) test_b2 NAME=6845-tests

##########################################################################
##########################################################################

.PHONY:assemble
assemble:
	mkdir -p $(DEST) $(TMP)
	$(TASS) $(SRC).s65 -L$(TMP)/$(SRC).lst -l$(TMP)/$(SRC).sym -o$(TMP)/$(SRC).prg
	$(PYTHON) convert_prg.py $(TMP)/$(SRC).prg $(DEST)/@.$(BBC)
	$(PYTHON) submodules/beeb/ssd_create.py -o $(SSD)/6845-test-$(BBC).ssd $(DEST)/@.$(BBC) $(DEST)/$$.SCREEN --build "*/@.$(BBC)"

##########################################################################
##########################################################################

.PHONY:clean
clean:
	rm -Rf $(TMP)
	rm -Rf $(SSDS)

.PHONY:test_b2
test_b2:
	curl -G 'http://localhost:48075/reset/b2' --data-urlencode "config=Master 128 (MOS 3.20)"
	curl -H 'Content-Type:application/binary' --upload-file '$(NAME).ssd' 'http://localhost:48075/run/b2?name=$(NAME).ssd'
