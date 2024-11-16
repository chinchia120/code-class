function [] = helperScatter(lat, lon, OutName)

% ===== GeoScatter
geoscatter(lat, lon, 2, 'red');

% ===== Plot Config
geobasemap topographic;
geolimits([-60 60], [-180 180]);
legend('Satellite Trajectory');
title('Ground Track');

% ===== Save Plot
saveas(gcf, [OutName , '.fig']);
saveas(gcf, [OutName , '.png']);

end