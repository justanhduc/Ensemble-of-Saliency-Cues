function [out,div] = face2equi(im, x_degree, y_degree, z_degree) %x_degree->clock-wise

    % Rotation matrix - x axis
    % Angle in degrees
    function [mat] = rotx(ang)
        mat = [1 0 0; 
            0 cosd(ang) -sind(ang); 
            0 sind(ang) cosd(ang)];
    end

    % Rotation matrix - y axis
    % Angle in degrees
    function [mat] = roty(ang)
        mat = [cosd(ang) 0 sind(ang); 
            0 1 0; 
            -sind(ang) 0 cosd(ang)];
    end

    % Rotation matrix - z axis
    % Angle in degrees    
    function [mat] = rotz(ang)
        mat = [cosd(ang) -sind(ang) 0; 
            sind(ang) cosd(ang) 0; 
            0 0 1];
    end

% Set up default parameters
% Default output size
n = size(im, 1);

% Error if invalid # of input arguments
if nargin > 0 && nargin < 3, x_degree = 0; y_degree = 0; z_degree = 0; end
if nargin == 3, z_degree = 0; end
if nargin == 0 || nargin > 4, error('Insufficient arguments'); end

% Define top left point of equirectangular in normalized co-ordinates
output_width = 2*n;
output_height = n;
input_width = n;
input_height = n;


% Output face co-ordinates
[X, Y] = meshgrid(0:output_width-1, 0:output_height-1);
X = reshape(X, 1, []);
Y = reshape(Y, 1, []);

% Obtain the spherical co-ordinates
Y = 2*Y/output_height - 1;
X = 2*X/output_width - 1;
sphereTheta = X*pi;
spherePhi = (pi/2)*Y;
clear X; clear Y;
texX = cos(spherePhi).*cos(sphereTheta);
texY = sin(spherePhi);
texZ = cos(spherePhi).*sin(sphereTheta);
clear spherePhi; clear sphereTheta;

% Get yaw, pitch and roll of a particular view
yaw = x_degree;
pitch = y_degree;
roll = z_degree;

% Get transformation matrix
transform = rotx(roll)*rotz(pitch)*roty(yaw);

% Rotate grid co-ordinates for cube face so that we are
% writing to the right face
point = cat(1, texX, texY, texZ);
clear texX; clear texY; clear texZ;
point = transform * point;
comp = [tand(50)*point(1,:); point(2:3,:);];
maxVal = max(abs(comp), [], 1);
out_pix = double(zeros(output_height * output_width,1));
div_pix = out_pix;

x = point(2,:)./abs(point(1,:)) / tand(50) +1;
y = point(3,:)./abs(point(1,:)) / tand(50) +1;
x = round(x * input_width / 2);
y = round(y * input_height / 2);

x(x < 1) = 1;
x(x > input_width) = input_width;
y(y < 1) = 1;
y(y > input_height) = input_height;

for i = 1 : size(maxVal, 2)
    if  (maxVal(1, i) == comp(1,i))  && (point(1,i)>=0)
        out_pix(i) = im(x(1,i),y(1,i));
        div_pix(i) = 1;
    end
end
out = reshape(out_pix, output_height, output_width, []);
div = reshape(div_pix, output_height, output_width, []);
end