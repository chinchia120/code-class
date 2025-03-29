gmtset FONT_ANNOT_PRIMARY 11p FONT_LABEL 10p MAP_FRAME_WIDTH 0.045i MAP_TICK_LENGTH 0.035i
psbasemap -B.2:."":WeSn -Jm6i -R119.45/120.50/22.45/23.40 -E180/90 -K -V -P -Y1i -X1.2i > shear.ps
psvelo ..\shear_sin.gmt -Jm -R -Sn.008 -W3,0 -K -O -V >> shear.ps
psvelo ..\shear_sin.gmt -Jm -R -Sn.0063 -W2,255 -K -O -V >> shear.ps
psvelo ..\shear_dex.gmt -Jm -R -Sn.008 -W3,0 -K -O -V >> shear.ps
gawk "{print $2,$3}" ..\vel_example.dat > area
psxy area -Jm -R -St.15i -G0 -O -V >> shear.ps

psconvert shear.ps -A -P -Tj

del area gmt*