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

Load SSD from `ssds` folder, boot with Shift+BREAK. There's an ssd
created for each individual test, and `6845-tests.ssd`, which contains
all of them. The `6845-tests` menu sets up KEY10 to re-run the same
test on BREAK, for quicker iteration.

Undocumented tests are undocumented - I probably haven't decided what
conclusion to draw.

# test

Simply change the background palette a couple of times.

This demonstrates that the vsync sync isn't quite perfect: press BREAK
repeatedly, and the split point can shift by one marker (which
represents 1 usec). This seems to be something to do with switching
the CRTC between 2MHz and 1MHz modes.

# r4-2

Show discrepancy between VL6845 and HD6845: the value of R4 is only
read during CRTC row 0.

# r4-3

Show discrepancy between VL6845 and HD6845: when changing R4 on the
last CRTC row, a new frame starts immediately.

# r6

Setting R6 to the current row number will stop the display
immediately, even mid-scanline.

# r6-2

Check the vertical displayed counter is compared using ==.

# scr-scr (scr-screen on PC)

Testbed for VL6845-friendly screen layout for
[Stunt Car Racer](https://github.com/kieranhj/scr-beeb).
