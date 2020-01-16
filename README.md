# 6845 tests

Some quick tests for the BBC Micro's 6845 CRTC chip.

This repo has submodules; clone with with `git clone --recursive`.

# how to build

## Windows

Prerequisites: Python 2.x on PATH

Run `snmake` from command prompt.

To manually provide path to Python, supply `PYTHON=xxx` on the make
command line.

## POSIX

Prerequisites: Python 2.x on PATH,
[64tass](https://sourceforge.net/projects/tass64/) on PATH

Run `make` from terminal.

To manually provide path to Python and/or 64tass, supply `PYTHON=xxx`
and/or TASS=xxx` on the make command line.

# how to run tests

Using BeebLink, add `beeb` in the working copy to the search path. The
volume name is `6845-tests`. Press Shift+BREAK to boot, and select
test of interest from the menu. `*KEY10` is set to re-run the test on
BREAK, for quick iteration.

To run from SSD, use an SSD from `ssds` folder, and boot with
Shift+BREAK. There's an ssd created for each individual test.

Undocumented tests are undocumented - I probably haven't decided what
conclusion to draw.

# test

Simply change the background palette a couple of times.

# r4-2

Show discrepancy between VL6845 and HD6845: VL6845 only reads the
value of R4 during CRTC row 0.

# r4-3

Show discrepancy between VL6845 and HD6845: when changing R4 on the
last CRTC row, the VL6845 starts a new frame immediately.

# r6

Setting R6 to the current row number will stop the display
immediately, even mid-scanline.

# r6-2

Check the vertical displayed counter is compared using ==.

# scr-screen (`SCR-SCR` on Beeb)

Testbed for VL6845-friendly screen layout for
[Stunt Car Racer](https://github.com/kieranhj/scr-beeb).

# cursor_flash (`CUFLASH` on Beeb)

Show discrepancy between VL6845 and HD6845: VL6845 updates the cursor
flash timer when the vertical total (R4) is reached, rather than the
vertical displayed (R6).
