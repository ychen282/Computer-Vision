%Q2

% read and resize
im = im2double(imread('street.jpg'));
imR = imresize(im,0.3);

%take green channel
imGreen = imR(:,:,2);
%imwrite(imGreen,"Q2_green_channel.jpg");

%filter with built-in gaussian filter
f_gaussian = fspecial('gaussian',9, 2);
filtered = conv2(imGreen,f_gaussian,'same');

%kernel for taking local differences with central
f_diffx = [1/2 0 -1/2];
f_diffy = [-1/2 0 1/2]';

%take local differences in the x and y directions
gx = conv2(filtered, f_diffx,'same');
gy = conv2(filtered, f_diffy,'same');
%imwrite(gx, "Q2_gradientx.jpg");
%imwrite(gy, "Q2_gradienty.jpg");

%computing gradient magnitude
[sx,sy] = size(filtered);
g_mag = zeros(sx,sy);
for i=1:sx
  for j = 1:sy
    g_mag(i,j) = sqrt((gx(i,j))^2+(gy(i,j))^2);
  end
end
%imwrite(g_mag, "Q2_gr_magnitude.jpg");

%computing gradient orientation
g_rad = zeros(sx,sy);
for i=1:sx
    for j = 1:sy
       g_rad(i,j) = atan(gy(i,j)/gx(i,j));
    end
end
%imwrite(g_rad, "Q2_gr_angle.jpg");

%mark pixels that exceed some large threshold
[m,n] = size(g_mag);
g_mag_sh = zeros(m,n);
%sh is shreshold
sh = 0.1;
for i=1:m
    for j=1:n
        if g_mag(i, j)>sh
            g_mag_sh(i,j) = 1;
        end
    end
end

imwrite(g_mag_sh, "Q2_exceed_sh.jpg");


