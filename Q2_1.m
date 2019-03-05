%Q1

%Read image
im = im2double(imread('james.jpg'));
im = im(:,:,2); 

%plot gaussian filtered images
figure(1),
conv_g(im, 4, 1);
conv_g(im, 8, 2);
conv_g(im, 12, 3);
conv_g(im, 16, 4);

%different time of applying heat equation 
%corresponding to sigma=4,8,12,16 respectively
t1=0.5*4*4;
t2=0.5*8*8;
t3=0.5*12*12;
t4=0.5*16*16;

%delta_t is my chosen time step parameter
delta_t=0.8; 

%plot heat equation applied images
figure(2),
heat(im, t1, delta_t, 1);
heat(im, t2, delta_t, 2);
heat(im, t3, delta_t, 3);
heat(im, t4, delta_t, 4);

%function details:

%Convolve with gaussian filter with different sigma scale
%And plot gaussian filtered images
%i is the position on the plot
function [] = conv_g (im, sigma, i)
    %im_g = conv2(im, fspecial('gaussian', 99, sigma),'same');
    im_g = imgaussfilt(im, sigma);
    subplot(2,2,i), imshow(im_g)
    name=sprintf('Gaussian blur with sigma=%d',sigma);
    title(name);
end

%Heat equation
%t is the total blurring time
%delta_t is step time parameter
%i is the position on the plot
function [] = heat(im, t, delta_t, j)
    for i=0:delta_t:t
        %calculate the partial second derivatives at each iteration
        [x, y] = gradient(im);
        [xx, yx] = gradient(x);
        [xy, yy] = gradient(y);
        im = im + (xx+yy)*delta_t;
    end
    subplot(2,2,j), imshow(im)
    name=sprintf('Heat blur with total t=%d and step t=%d',t, delta_t);
    title(name);
end


