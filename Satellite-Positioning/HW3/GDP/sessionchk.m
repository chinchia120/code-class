function  [OBS] = sessionchk(OBS,epochstart, epochend)

if any(find(OBS.TG)) == 1
OBS.TG = OBS.TG(epochstart:epochend,:);
end
if any(find(OBS.TOWSEC)) == 1
OBS.TOWSEC = OBS.TOWSEC(epochstart:epochend);
end
if any(find(OBS.GSVID)) == 1
OBS.GSVID = OBS.GSVID(:,epochstart:epochend);
end
if any(find(OBS.GL1)) == 1
OBS.GL1 = OBS.GL1(:,epochstart:epochend);
end
if any(find(OBS.GL1LLI)) == 1
OBS.GL1LLI = OBS.GL1LLI(:,epochstart:epochend);
end
if any(find(OBS.GL1SS)) == 1
OBS.GL1SS = OBS.GL1SS(:,epochstart:epochend);
end
if any(find(OBS.GL2)) == 1
OBS.GL2 = OBS.GL2(:,epochstart:epochend);
end
if any(find(OBS.GL2LLI)) == 1
OBS.GL2LLI = OBS.GL2LLI(:,epochstart:epochend);
end
if any(find(OBS.GL2SS)) == 1
OBS.GL2SS = OBS.GL2SS(:,epochstart:epochend);
end
if any(find(OBS.GL5)) == 1
OBS.GL5 = OBS.GL5(:,epochstart:epochend);
end
if any(find(OBS.GL5LLI)) == 1
OBS.GL5LLI = OBS.GL5LLI(:,epochstart:epochend);
end
if any(find(OBS.GL5SS)) == 1
OBS.GL5SS = OBS.GL5SS(:,epochstart:epochend);
end
if any(find(OBS.GC1C)) == 1
OBS.GC1C = OBS.GC1C(:,epochstart:epochend);
end
if any(find(OBS.GC1P)) == 1
OBS.GC1P = OBS.GC1P(:,epochstart:epochend);
end
if any(find(OBS.GC2C)) == 1
OBS.GC2C = OBS.GC2C(:,epochstart:epochend);
end
if any(find(OBS.GC2P)) == 1
OBS.GC2P = OBS.GC2P(:,epochstart:epochend);
end
if any(find(OBS.GC5I)) == 1
OBS.GC5I = OBS.GC5I(:,epochstart:epochend);
end
if any(find(OBS.GS1)) == 1
OBS.GS1 = OBS.GS1(:,epochstart:epochend);
end
if any(find(OBS.GS2)) == 1
OBS.GS2 = OBS.GS2(:,epochstart:epochend);
end
if any(find(OBS.GS5)) == 1
OBS.GS5 = OBS.GS5(:,epochstart:epochend);
end

if any(find(OBS.ESVID)) == 1
OBS.ESVID = OBS.ESVID(:,epochstart:epochend);
end
if any(find(OBS.EL1)) == 1
OBS.EL1 = OBS.EL1(:,epochstart:epochend);
end
if any(find(OBS.EL5)) == 1
OBS.EL5 = OBS.EL5(:,epochstart:epochend);
end
if any(find(OBS.EL7)) == 1
OBS.EL7 = OBS.EL7(:,epochstart:epochend);
end
if any(find(OBS.EC1B)) == 1
OBS.EC1B = OBS.EC1B(:,epochstart:epochend);
end
if any(find(OBS.EC5I)) == 1
OBS.EC5I = OBS.EC5I(:,epochstart:epochend);
end
if any(find(OBS.EC7I)) == 1
OBS.EC7I = OBS.EC7I(:,epochstart:epochend);
end
if any(find(OBS.ES1)) == 1
OBS.ES1 = OBS.ES1(:,epochstart:epochend);
end
if any(find(OBS.ES5)) == 1
OBS.ES5 = OBS.ES5(:,epochstart:epochend);
end
if any(find(OBS.ES7)) == 1
OBS.ES7 = OBS.ES7(:,epochstart:epochend);
end