%Q4

%read and resize original image
im = im2double(imread('street.jpg'));
imR = imresize(im,0.3);

%read and resize edge map generated in Q2
im_e = im2double(imread('Q2_exceed_sh.jpg'));

%use a crop_o matrix to store the crop of the original image
crop_o = zeros(20,20);
for i = 551:570 
    for j = 311:330
        crop_o(i-550,j-310) = imR(i,j);
    end
end

imwrite(crop_o, "Q4_crop_origin.jpg");

%use a crop_e matrix to store the crop of the edge map
crop_e = zeros(20,20);
for i = 551:570 
    for j = 311:330
        crop_e(i-550,j-310) = im_e(i,j);
    end
end

imwrite(crop_e, "Q4_crop_edge.jpg");

%kernel for taking local differences, compute gradients of crop_o
f_diffx = [1/2 0 -1/2];
f_diffy = [-1/2 0 1/2]';
gx = conv2(crop_o, f_diffx,'same');
gy = conv2(crop_o, f_diffy,'same');

[x,y] = meshgrid(1:1:20);
%magnify the crop so that it can be seen clearly
figure(1)
imshow(crop_o, 'InitialMagnification', 3000);
hold on
quiver(x, y, gx, gy);
hold off
grid;

%compute gradients of crop_e
f_diffx_e = [1/2 0 -1/2];
f_diffy_e = [-1/2 0 1/2]';
gx_e = conv2(crop_e, f_diffx_e,'same');
gy_e = conv2(crop_e, f_diffy_e,'same');

[x_e,y_e] = meshgrid(1:1:20);

%magnify the crop so that it can be seen clearly
figure(2)
imshow(crop_e, 'InitialMagnification', 3000);
hold on
quiver(x_e, y_e, gx_e, gy_e);
hold off











