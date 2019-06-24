# -*- mode:makefile-gmake; -*-
##########################################################################
##########################################################################

ifeq ($(OS),Windows_NT)
TASS?=bin\64tass.exe
MKDIR_P:=-cmd /c mkdir
RM_RF:=-cmd /c rd /s /q
else
TASS?=64tass
MKDIR_P:=mkdir -p
RM_RF:=rm -Rf
endif

PYTHON=python

TASSCMD:=$(TASS) --m65c02 --cbm-prg -Wall -C --line-numbers

VOLUME:=beeb/
DEST:=$(VOLUME)/0
TMP:=.tmp
SSD:=ssds

BEEB_BIN:=submodules/beeb/bin

##########################################################################
##########################################################################

.PHONY:build
build:
	$(MKDIR_P) "$(VOLUME)/0"
	$(MKDIR_P) "$(TMP)"
	$(MKDIR_P) "$(SSD)"
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
	$(PYTHON) $(BEEB_BIN)/ssd_create.py -4 3 -o $(SSD)/6845-tests.ssd $(DEST)/@.* $(DEST)/$$.!BOOT $(DEST)/$$.SCREEN $(DEST)/$$.SCREEN2 $(DEST)/$$.SCR-HUD $(DEST)/$$.MENU
#	-@$(MAKE) test_b2 NAME=6845-tests

##########################################################################
##########################################################################

.PHONY:assemble
assemble:
	$(MKDIR_P) "$(DEST)"
	$(MKDIR_P) "$(TMP)"
	$(TASSCMD) $(SRC).s65 -L$(TMP)/$(SRC).lst -l$(TMP)/$(SRC).sym -o$(TMP)/$(SRC).prg
	$(PYTHON) $(BEEB_BIN)/prg2bbc.py $(TMP)/$(SRC).prg $(DEST)/@.$(BBC)
	$(PYTHON) $(BEEB_BIN)/ssd_create.py -o $(SSD)/6845-test-$(BBC).ssd $(DEST)/@.$(BBC) $(DEST)/$$.SCREEN --build "*/@.$(BBC)"

##########################################################################
##########################################################################

.PHONY:clean
clean:
	$(RM_RF) "$(TMP)"
	$(RM_RF) "$(SSD)"

.PHONY:test_b2
test_b2:
	curl -G 'http://localhost:48075/reset/b2' --data-urlencode "config=Master 128 (MOS 3.20)"
	curl -H 'Content-Type:application/binary' --upload-file '$(NAME).ssd' 'http://localhost:48075/run/b2?name=$(NAME).ssd'
