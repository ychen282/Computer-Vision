%Q5

% use the same image as in Q2
im = im2double(imread('street.jpg'));
imR = imresize(im,0.3);

%take green channel
imGreen = imR(:,:,2);

%filter with built-in gaussian filter
f_gaussian = fspecial('gaussian',9, 0.5);
filtered = conv2(imGreen,f_gaussian,'same');

%kernel for taking local differences, only do x direction since y direction is simial
f_diffx = [1/2 0 -1/2];

%take local differences in x directions
gx = conv2(filtered, f_diffx,'same');

%find the size of the image and compute total number of pixels
[m,n] = size(filtered);
sum = m*n;

%read the counts by using hist function
[counts, centers] = hist(gx(:),100);

%normalize counts
counts_normal = counts/sum;

%plot histogram
figure(1),bar(centers, counts_normal);

%plot log of histogram
figure(2),bar(centers, log(counts_normal));
