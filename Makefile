# -*- mode:makefile-gmake; -*-
##########################################################################
##########################################################################

ifeq ($(OS),Windows_NT)
TASS?=bin\64tass.exe
else
TASS?=64tass
endif

PYTHON?=python

TASSCMD:=$(TASS) --m65c02 --cbm-prg -Wall -C --line-numbers

VOLUME:=beeb/
DEST:=$(VOLUME)/0
TMP:=build
SSD:=ssds

BEEB_BIN:=submodules/beeb/bin
SHELLCMD:=$(PYTHON) submodules/shellcmd.py/shellcmd.py

##########################################################################
##########################################################################

.PHONY:build
build:
	$(SHELLCMD) mkdir "$(VOLUME)/0"
	$(SHELLCMD) mkdir "$(TMP)"
	$(SHELLCMD) mkdir "$(DEST)"
	$(MAKE) _parts ACTION=_assemble
#	-@$(MAKE) test_b2 NAME=6845-tests

##########################################################################
##########################################################################

.PHONY:_parts
_parts:
	$(MAKE) $(ACTION) SRC=framework_test BBC=TEST
	$(MAKE) $(ACTION) SRC=r6 BBC=R6
	$(MAKE) $(ACTION) SRC=r6-2 BBC=R6-2
	$(MAKE) $(ACTION) SRC=r7-time BBC=R7-TIME
	$(MAKE) $(ACTION) SRC=r7-pos BBC=R7-POS
	$(MAKE) $(ACTION) SRC=mode7-disen BBC=M7DISEN
	$(MAKE) $(ACTION) SRC=r4-1 BBC=R4-1
	$(MAKE) $(ACTION) SRC=scr-screen BBC=SCR-SCR
	$(MAKE) $(ACTION) SRC=r4-2 BBC=R4-2
	$(MAKE) $(ACTION) SRC=r4-3 BBC=R4-3
	$(MAKE) $(ACTION) SRC=cursor_flash BBC=CUFLASH
	$(MAKE) $(ACTION) SRC=r1=0 BBC=R1=0
	$(MAKE) $(ACTION) SRC=r1=255 BBC=R1=255
	$(MAKE) $(ACTION) SRC=r6=0 BBC=R6=0
	$(MAKE) $(ACTION) SRC=cursor_oddity BBC=CUODD
	$(MAKE) $(ACTION) SRC=cursor_r11 BBC=CUR11

##########################################################################
##########################################################################

.PHONY:_assemble
_assemble:
	$(TASSCMD) "$(SRC).s65" "-L$(TMP)/$(SRC).lst" "-l$(TMP)/$(SRC).sym" "-o$(TMP)/$(SRC).prg"
	$(PYTHON) $(BEEB_BIN)/prg2bbc.py "$(TMP)/$(SRC).prg" "$(DEST)/@.$(BBC)"

##########################################################################
##########################################################################

.PHONY:ssds
ssds:
	$(MAKE) clean
	$(MAKE) build
	$(SHELLCMD) rm-tree "$(SSD)"
	$(SHELLCMD) mkdir "$(SSD)"
	$(MAKE) _parts ACTION=_create_ssd

.PHONY:_create_ssd
_create_ssd:
	$(PYTHON) $(BEEB_BIN)/ssd_create.py -o "$(SSD)/6845-test-$(SRC).ssd" "$(DEST)/@.$(BBC)" "$(DEST)/$$.SCREEN" --build "*/@.$(BBC)"

##########################################################################
##########################################################################

.PHONY:clean
clean:
	$(SHELLCMD) rm-tree "$(TMP)"
	$(MAKE) _parts ACTION=_delete_beeb_file

.PHONY:_delete_beeb_file
_delete_beeb_file:
	$(SHELLCMD) rm-file "$(DEST)/@.$(BBC)"

##########################################################################
##########################################################################

.PHONY:test_b2
test_b2:
	curl -G 'http://localhost:48075/reset/b2' --data-urlencode "config=Master 128 (MOS 3.20)"
	curl -H 'Content-Type:application/binary' --upload-file '$(NAME).ssd' 'http://localhost:48075/run/b2?name=$(NAME).ssd'
