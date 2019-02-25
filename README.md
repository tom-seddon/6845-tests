# 6845 tests

Load SSD, boot with Shift+BREAK. The menu sets up KEY10 to re-run the
same test on BREAK, for quicker iteration.

Undocumented tests are undocumented - I probably haven't decided what
conclusion to draw.

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
