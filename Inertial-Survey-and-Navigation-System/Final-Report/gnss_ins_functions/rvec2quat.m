% Rotation vector to quaternions conversion
%----
% Eun-Hwan Shin, July 2003.
% Ref: Savage, P.G. (2000). Strapdown Analytics: Part 1, p. 3-48
%----
% function q = rvec2quat(rot_vec)

function q = rvec2quat(rot_vec)

mag2 = rot_vec(1)^2 + rot_vec(2)^2 + rot_vec(3)^2;

if mag2 < pi^2
    % == approximate solution ===
    % disp('approximate solution');
	mag2 = 0.25 * mag2;
	
	c = 1.0 - mag2/2.0 * (1.0 - mag2/12.0 * (1.0 - mag2/30.0 ));
	s = 1.0 - mag2/6.0 * (1.0 - mag2/20.0 * (1.0 - mag2/42.0 ));
	
	q = [c; s * 0.5 * rot_vec(1); s * 0.5 * rot_vec(2); s * 0.5 * rot_vec(3) ];
else
	% == Analytical solution ===
    % disp('Analytical solution');
	mag = sqrt(mag2);
	s_mag = sin(mag/2);
	
	q = [ cos(mag/2);
        rot_vec(1)*s_mag/mag;
        rot_vec(2)*s_mag/mag;
        rot_vec(3)*s_mag/mag ];
    
    if q(1) < 0
        q = -q;
    end
end
