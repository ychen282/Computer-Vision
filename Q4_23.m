%  Question 2
%
%  This script reads in one image and performs camera calibration.
%  It then examines what happens when the values of matrices are changed.
%

close all
clear
readPositions  %  reads given positions of XYZ and xy1 and xy2 for two images

numPositions = size(XYZ,1);

%  Display image with keypoints

Iname = 'c1.jpg';

I = imread(Iname);
NX = size(I,2);
NY = size(I,1);
imageInfo = imfinfo(Iname);
figure;
imshow(I);
hold on

%  Draw in green the keypoints locations that were hand selected.

xy = xy1;

%  Draw in green the keypoints locations that were hand selected.

for j = 1:numPositions
    plot(xy(j,1),xy(j,2),'g*');
end

[P, K, R, C] = calibrate(XYZ, xy);

%  Rescale coefficients of K so that K(3,3) is 1

P = P / K(3,3);

K = K/K(3,3);

for j = 1:numPositions
    p = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
    x = p(1)/p(3);
    y = p(2)/p(3);
    
    plot(ceil(x),ceil(y),'gs');
end

%------------------   IMAGE TRANSLATION

if (0)
    
    title('image translation using Y rotation matrix (red) and camera translation using C (cyan)')
    
    num_degrees = 2;
    theta_y = num_degrees *pi/180;
    R_y = [cos(theta_y) 0 sin(theta_y);  0 1 0;  -sin(theta_y) 0  cos(theta_y)];
    
    P =  K * R_y * R*[eye(3), -C];
    
    for j = 1:numPositions
        p = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
        x = p(1)/p(3);
        y = p(2)/p(3);
        
        plot(ceil(x),ceil(y),'r*');
    end
    %  plot the object origin
    p = P*[ 0 0 0  1]';
    x = p(1)/p(3);
    y = p(2)/p(3);
    
    plot(ceil(x),ceil(y),'b*');
    
    
    %  change the C vector so that we shift in the camera x direction
    %  To do this, we need to find out which vector in world coordinates
    %  corresponds to a shift in camera coordinates.   So we take a
    %  camera coordinate shift and write it in world coordinates by
    % multiplying by R'.  We then add this to C.
    
    s = 80;
    P =  K * R*[eye(3), - C - R' * [s 0 0]' ];
    
    for j = 1:numPositions
        p = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
        x = p(1)/p(3);
        y = p(2)/p(3);
        
        plot(ceil(x),ceil(y),'c*');
    end
    %  plot the object origin
    p = P*[ 0 0 0  1]';
    x = p(1)/p(3);
    y = p(2)/p(3);
    
    plot(ceil(x),ceil(y),'b*');
end

%------------------   IMAGE SCALE

if (1)
    
    title('original points are green \newline scale K11 and K22 (red) and change C by moving points (cyan) away from principal point (blue) ');
    
    %  Scale the K(1,1) and K(2,2) coefficients.
    %  Scaling by more than 1 expands away from the principal point
    s =  1.4;
    Knew = K * [s 0 0; 0 s 0; 0 0 1] ;
    P =  Knew*R*[eye(3), -C];
    
    for j = 1:numPositions
        p = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
        x = p(1)/p(3);
        y = p(2)/p(3);
        
        plot(ceil(x),ceil(y),'r*');
    end
    
    % Change C  such that camera moves in the direction of the principal point,
    % which will move image projections away from the principal point.
    % The amount of image expansion will depend on depth and will vary between points.
    
    principalPoint = [K(1,3), K(2,3), K(3,3)]';
    % mark principal point in blue
    plot(ceil(K(1,3)), ceil(K(2,3)),'b*');
    
    % Choose an s (trial and error)   so that cyan and red points are
    % close to each other
    
    %  The idea is to write the principle point in camera coordinates
    %  (first inverse mapping the K matrix which is in pixel coordinate)
    %  and then add some scaled amount of this vector to C.
    %  Choose the scale so that it roughly matches the other expansion
    %  method above.
    
    s = 600;
    P =  K*R*[eye(3), - C + s * R' * (K \ principalPoint)];   %  This is same as inv(K) * principalPoint
    
    for j = 1:numPositions
        p = P*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
        x = p(1)/p(3);
        y = p(2)/p(3);
        
        plot(ceil(x),ceil(y),'c*');
    end
    
    
end

