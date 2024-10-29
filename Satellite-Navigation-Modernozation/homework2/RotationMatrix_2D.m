function [Matrix] = RotationMatrix_2D(theta)

Matrix = [cosd(theta) sind(theta); -sind(theta), cosd(theta)];

end