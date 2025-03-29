gmtset FONT_ANNOT_PRIMARY 11p FONT_LABEL 10p MAP_FRAME_WIDTH 0.045i MAP_TICK_LENGTH 0.035i
psbasemap -B.2:."":WeSn -Jm6i -R119.45/120.50/22.45/23.40 -E180/90 -K -V -P -Y1i -X1.2i > strain.ps
gawk "{if($3>0)  print $1,$2,$3,\" 0 \",$5}" ..\strain.gmt >area
psvelo area -Jm -R -Sx.02 -W5,0 -A0.15/0.0/0.0 -K -O -V >> strain.ps
psvelo area -Jm -R -Sx.02 -W5,255 -A0.11/0.0/0.0 -K -O -V >> strain.ps
gawk "{if($3<=0) print $1,$2,$3,\" 0 \",$5}" ..\strain.gmt > area
psvelo area -Jm -R -Sx.02 -W5,0 -A0.11/0.0/0.0 -K -O -V >> strain.ps
gawk "{if($4>0)  print $1,$2,\" 0 \",$4,$5}" ..\strain.gmt > area
psvelo area -Jm -R -Sx.02 -W5,0 -A0.15/0.0/0.0 -K -O -V >> strain.ps
psvelo area -Jm -R -Sx.02 -W5,255 -A0.11/0.0/0.0 -K -O -V >> strain.ps
gawk "{if($4<=0) print $1,$2,\" 0 \",$4,$5}" ..\strain.gmt > area
psvelo area -Jm -R -Sx.02 -W5,0 -A0.11/0.0/0.0 -K -O -V >> strain.ps
gawk "{print $2,$3}" ..\vel_example.dat > area
psxy area -Jm -R -St.15i -G0 -O -V >> strain.ps

psconvert strain.ps -A -P -Tj

del area gmt*