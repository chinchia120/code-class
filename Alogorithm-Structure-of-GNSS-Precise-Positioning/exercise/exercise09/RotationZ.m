function rot = RotationZ(theta)
rot = cell(size(theta, 1), 1);

for i = 1: length(theta)
    rot{i} = [ cos(theta(i)), sin(theta(i)), 0;
              -sin(theta(i)), cos(theta(i)), 0;
                           0,          0, 1];
end

end