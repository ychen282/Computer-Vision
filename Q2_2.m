%Q2 

%Q2.1

%Read image
im_origin = im2double(imread('james.jpg'));
im_rotate = imrotate(im_origin, 20);
im_R = imresize(im_origin,[512 512]);
im = im_R(:,:,2); 

%filtered with gaussian kernel
im0 = imgaussfilt(im,1);
im1 = imresize(imgaussfilt(im,2),0.5);
im2 = imresize(imgaussfilt(im,4),0.5^2);
im3 = imresize(imgaussfilt(im,8),0.5^3);
im4 = imresize(imgaussfilt(im,16),0.5^4);
im5 = imresize(imgaussfilt(im,32),0.5^5);

%plot
figure(1),
subplot(2,3,1), imshow(im0);
name0=sprintf('Gaussian pyramid L1, sigma=%d', 1);
title(name0);
subplot(2,3,2), imshow(im1);
name1=sprintf('Gaussian pyramid L2, sigma=%d', 2);
title(name1);
subplot(2,3,3), imshow(im2);
name2=sprintf('Gaussian pyramid L3, sigma=%d', 4);
title(name2);
subplot(2,3,4), imshow(im3);
name3=sprintf('Gaussian pyramid L4, sigma=%d', 8);
title(name3);
subplot(2,3,5), imshow(im4);
name4=sprintf('Gaussian pyramid L5, sigma=%d', 16);
title(name4);
subplot(2,3,6), imshow(im5);
name5=sprintf('Gaussian pyramid L6, sigma=%d', 32);
title(name5);

%Q2.2

%compute DoG
im0_L = imresize(im1, 2) - im0;
im1_L = imresize(im2, 2) - im1;
im2_L = imresize(im3, 2) - im2;
im3_L = imresize(im4, 2) - im3;
im4_L = imresize(im5, 2) - im4;
im5_L = im5;

%plot
figure(2),
subplot(2,3,1), imshow(im0_L,[]);
name0=sprintf('Laplacian pyramid level 1');
title(name0);
subplot(2,3,2), imshow(im1_L,[]);
name1=sprintf('Laplacian pyramid level 2');
title(name1);
subplot(2,3,3), imshow(im2_L,[]);
name2=sprintf('Laplacian pyramid level 3');
title(name2);
subplot(2,3,4), imshow(im3_L,[]);
name3=sprintf('Laplacian pyramid level 4');
title(name3);
subplot(2,3,5), imshow(im4_L,[]);
name4=sprintf('Laplacian pyramid level 5');
title(name4);
subplot(2,3,6), imshow(im5_L,[]);
name5=sprintf('Laplacian pyramid level 6');
title(name5);

%Q2.3
%Use visualization functions
figure(3),
surf(im1_L)
im_log = imresize(conv2(im, fspecial('log',4, 1), 'same'),0.5);
figure(4),
surf(im_log)
figure(5),
surf(im1_L-im_log)

%difference of Dog and Log on image
%DoG
figure(6),
subplot(2,3,1);
imshow(im0_L, []);
title('Laplacian pyramid level 0');
subplot(2,3,2);
imshow(im1_L, []);
title('Laplacian pyramid level 1');
subplot(2,3,3);
imshow(im2_L, []);
title('Laplacian pyramid level 2');


%Q2.4

keypoint = [keypoints(im0_L,im1_L,im2_L,2);
            keypoints(im1_L,im2_L,im3_L,4);
            keypoints(im2_L,im3_L,im4_L,8);
            keypoints(im3_L,im4_L,im5_L,16)];
        size(keypoint)

%find the number of keypoints
n=size(keypoint,1);

%draw keypoints on the image
figure(7),
imshow(im_R)
hold on
for i=1:n
    scale = keypoint(i,3);
    if scale==2
        plot(round(keypoint(i,2)*scale),round(keypoint(i,1)*scale),'ro','MarkerSize',scale*3,'MarkerEdgeColor','b');    
    elseif scale==4
        plot(round(keypoint(i,2)*scale),round(keypoint(i,1)*scale),'ro','MarkerSize',scale*3,'MarkerEdgeColor','r');    
    elseif scale==8
        plot(round(keypoint(i,2)*scale),round(keypoint(i,1)*scale),'ro','MarkerSize',scale*3,'MarkerEdgeColor','w');   
    elseif scale==16
        plot(round(keypoint(i,2)*scale),round(keypoint(i,1)*scale),'ro','MarkerSize',scale*3,'MarkerEdgeColor','g');
    end
end
hold off


%function that finds the extremal value in space and in scale
function y = keypoints (im1, im, im2, sigma)

  keypoint = [];
  
  %downsample im1 and upsample im2
  im_d = imresize(im1, 0.5);
  im_u = imresize(im2, 2);

  s = size(im, 1);
  
  for i=2:s-1
    for j=2:s-1
      A1 = [im_d(i-1,j-1) im_d(i-1,j) im_d(i-1,j+1);...
        im_d(i,j-1) im_d(i,j) im_d(i,j+1);...
        im_d(i+1,j-1) im_d(i+1,j) im_d(i+1,j+1)];
        %for A2 which is the middle layer, I replace pixel (i,j) with 
        %pixel(i, j-1). So that I still only compare im(i,j) with the 
        %other 26 pixels
        A2 = [im(i-1,j-1) im(i-1,j) im(i-1,j+1);...
              im(i,j-1) im(i,j-1) im(i,j+1);...
              im(i+1,j-1) im(i+1,j) im(i+1,j+1)];
        A3 = [im_u(i-1,j-1) im_u(i-1,j) im_u(i-1,j+1);...
              im_u(i,j-1) im_u(i,j) im_u(i,j+1);...
              im_u(i+1,j-1) im_u(i+1,j) im_u(i+1,j+1)];
        
        if im(i,j)>max([max(max(A1(:))), max(max(A2(:))), max(max(A3(:)))]) || ...
             im(i,j)<min([min(A1(:)), min(A2(:)), min(A3(:))])
              %to get more stable keypoints, I set some threshold
              if im(i,j)<-0.04 || im(i,j)>0.9
              keypoint = [keypoint; i j sigma];
              end
        end 
     end
  end
  y=keypoint;
end







