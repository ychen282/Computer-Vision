%Q3

%for test
sigma = 1;
N = 11;

%first generate a built-in gaussian filter
f_gaussian = fspecial('gaussian',N,sigma);

%implement a laplacian of gaussian filter
f_log = zeros(N,N);
sum_log = 0;


for i = 1:N
  for j = 1:N
    d = (i-(N+1)/2)^2 + (j-(N+1)/2)^2;
    f_log(i,j) = ((d-2*sigma^2)*f_gaussian(i,j))/((sigma^4));
    sum_log = sum_log+f_log(i,j);
  end
end

% Make the filter sum to zero
filter_log = f_log - sum_log/N^2;

%convolve it with my rectangle and disk image
im = im2double(imread('rec&disk.jpg'));
imR = imresize(im,0.3);
im_grey = imR(:,:,2);
im_filtered = conv2(im_grey, filter_log, 'same');
%imwrite(im_filtered,'Q3_rec&disk_log.jpg');
imshow (im_filtered)

%create a binary image
[m,n]=size(im_filtered);
im_binary = zeros(m,n);
for i=2:m-1
    for j=2:n-1
        if im_filtered(i-1,j)*im_filtered(i+1,j)<0 || ...
           im_filtered(i,j-1)*im_filtered(i,j+1)<0 
            im_binary(i,j) = 1;
        end
    end
end

imwrite(im_binary,'Q3_zerocrossing.jpg');








