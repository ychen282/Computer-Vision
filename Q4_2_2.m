%  Q4.m
%
%  Here we will read in an image and produce a new image that would be
%  obtained by rotating the camera.
%  The new image will have the specified size

I1 = imread('c1.jpg');
NX = size(I1,2);
NY = size(I1,1);

%  You should increase the size of newcamera1 enough to make room for 
%  all of the positions visible



%   The units of K are pixels per mm.
%  hardcode K

I1 = imread('c1.jpg');
photodata = imfinfo('c1.jpg');
f_mm = photodata.DigitalCamera.FocalLength;
sensorSizeX = 23.6;  % mm  for Nikon D90 
sensorSizeY = 15.8;  % mm  for Nikon D90

NX = size(I1,2);  % columns
NY = size(I1,1);  % rows

K11 = f_mm* NX / sensorSizeX;  
K22 = f_mm* NY / sensorSizeY;  
K13 = round(NX/2);
K23 = round(NY/2);

%  hard code K based on what is known about the camera

K    =   [K11  0  K13;  0  K22  K23; 0 0  1];

%  make a new projection plane with half the focal length and half as many
%  pixels in each dimention

NXnew = round(NX/2);  % columns
NYnew = round(NY/2);  % rows

K11new = f_mm/2  * NXnew / sensorSizeX;  
K22new = f_mm/2  * NYnew / sensorSizeY;  
K13new = round(NXnew/2);
K23new = round(NYnew/2);

Knew    =   [K11new  0  K13new;  0  K22new  K23new; 0 0  1];

%  HERE WE SET NUMBER OF DEGREES OF ROTATION

num_degrees = 0;


theta_y = num_degrees *pi/180;
R_y = [cos(theta_y) 0 sin(theta_y);  0 1 0;  -sin(theta_y) 0  cos(theta_y)];

H  =  Knew * R_y * inv(K);
invH = inv(H);

newcamera1 = uint8(zeros(NYnew,NXnew,3));

%  Take a pixel coordinate in the new image and find its position in the
%  original image.   Note row is y and column is x.

for r=1:NYnew
    %r
    for c=1:NXnew
        v = invH * [c, r, 1]';
        x = round(v(1)/v(3));
        y = round(v(2)/v(3));
        if (x > 0) && (x <= NX) && (y > 0) && (y <= NY)
            newcamera1(r,c,:) = I1(y,x,:);
        end
    end
end

image(newcamera1)