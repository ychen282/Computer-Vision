%Q3

%Read image
im = im2double(imread('james.jpg'));
im = im(:,:,2); 

%Code from Assignment1 Q2 for generating edge map
filtered = imgaussfilt(im, 1);
%kernel for taking local differences with central
f_diffx = [1 0 -1];
f_diffy = [-1 0 1]';
%take local differences in the x and y directions
gx = conv2(filtered, f_diffx,'same');
gy = conv2(filtered, f_diffy,'same');

g_mag = sqrt((gx .* gx) + (gy .* gy));  
g_rad = atan(gy./ gx);

%mark pixels that exceed some large threshold
[m,n] = size(g_mag);
g_mag_sh = zeros(m,n);
%sh is shreshold
sh = 0.12;
for i=1:m
    for j=1:n
        if g_mag(i, j)>sh
            g_mag_sh(i,j) = 0;
        else
            g_mag_sh(i,j) = 1;
        end
    end
end
imwrite(g_mag_sh, 'edge_map.jpg');

img = im2double(imread('edge_map.jpg'));
[x,y]=find(g_mag>0.12);

s = size(x);

array_x = [];
array_y = [];
array_theta = [];

for i=1:s(1)
    array_x(i) = x(i,1);
    array_y(i) = y(i,1);
    array_theta(i) = g_rad(x(i,1),y(i,1));
end

%N is repeat times
N = 100;
%threshold1 is the distance creteria of the consensus
%threshold2 is the angle creteria of the consensus
threshold1 = 15;
threshold2 = 0.1;

max = [0,0];

for i=1:N
    %generate two random index
    r1=randi(s(1));
    %define the line model
    x0=array_x(r1);
    y0=array_y(r1);
    theta = array_theta(r1);
    %compute r value for line in direction theta and through point (xi,yi)
    r=y0*cos(theta)+x0*sin(theta);
    %temp is for computing number of pixels in the consensus
    temp=0;
    for j=1:s(1)
        if j ~= r1
            xi = array_x(j);
            yi = array_y(j);
            thetai = array_theta(j);
            ri = yi*cos(thetai)+xi*sin(thetai);
            if abs(r-ri) < threshold1
            temp = temp + 1;
            end
        end
    end
    if temp > max(2)
        max(1) = r1;
        max(2) = temp;
    end
end

%plot 
i = max(1);
d = array_y(i)*cos(array_theta(i))+array_x(i)*sin(array_theta(i));
angle = array_theta(i);

%I created a blank image and then plot inliers and outliers on it
[sz1,sz2]=size(img);
blank = ones(sz1, sz2);

figure(1),
imshow(blank)

for k = 1:s(1)
    xi = array_x(k);
    yi = array_y(k);
    thetai = array_theta(k);
    ri = yi*cos(thetai)+xi*sin(thetai);
    %check if the point satisfies the two criterias
    if abs(d-ri) < threshold1 && abs(abs(thetai)-abs(angle))<threshold2
        rectangle('Position', [yi xi 0.7 0.7], 'EdgeColor', 'r')
    else 
        rectangle('Position', [yi xi 0.7 0.7], 'EdgeColor', 'k')
    end
end










