function [Vx,Vy] = compute_LK_optical_flow(frame_1,frame_2,type_LK)

% You have to implement the Lucas Kanade algorithm to compute the
% frame to frame motion field estimates. 
% frame_1 and frame_2 are two gray frames where you are given as inputs to 
% this function and you are required to compute the motion field (Vx,Vy)
% based upon them.
% -----------------------------------------------------------------------%
% YOU MUST SUBMIT ORIGINAL WORK! Any suspected cases of plagiarism or 
% cheating will be reported to the office of the Dean.  
% You CAN NOT use packages that are publicly available on the WEB.
% -----------------------------------------------------------------------%

% There are three variations of LK that you have to implement,
% select the desired alogrithm by passing in the argument as follows:
% "LK_naive", "LK_iterative" or "LK_pyramid"

switch type_LK

    case "LK_naive"
        % YOUR IMPLEMENTATION GOES HERE
        im1 = im2double(frame_1);
        im2 = im2double(frame_2);
        %A for check dimension use
        if size(im1,3)==3
        im1 = rgb2gray(im1);
        im2 = rgb2gray(im2);
        %blur images
        im1 = imgaussfilt(im1, 2);
        im2 = imgaussfilt(im2, 2);
        end
        %get size of image
        [sx,sy] = size(im1);
        %m is the size of window I assumed
        m=29;
        W = fspecial('gaussian', m, 5);
        %pad im1 and im2
        im1 = [zeros(sx+m-1, (m-1)/2) [zeros((m-1)/2, sy); im1; zeros((m-1)/2, sy)] zeros(sx+m-1, (m-1)/2)];
        im2 = [zeros(sx+m-1, (m-1)/2) [zeros((m-1)/2, sy); im2; zeros((m-1)/2, sy)] zeros(sx+m-1, (m-1)/2)];
        %compute gradient
        [gr_x1, gr_y1] = gradient(im1);
        %matrix_vx and matrix_vy are holding vx and vy for all entries
        matrix_vx = zeros(sx, sy);
        matrix_vy = zeros(sx, sy);
         for i= 1 : sx
             for j= 1 : sy
                 %second moment matrix
                 matrix = zeros(2,2);
                 %sum1 and sum2 are sum of (im1-im2)*gr_x1 and (im1-im2)*gr_y1
                 %within the window respectively
                 sum1 = 0;
                 sum2 = 0;
                 for k=1:m
                     for t=1:m
                         gr_x = gr_x1(i-1+k,j-1+t);
                         gr_y = gr_y1(i-1+k,j-1+t);
                         matrix(1,1) = matrix(1,1) + gr_x*gr_x*W(k,t);
                         matrix(1,2) = matrix(1,2) + gr_x*gr_y*W(k,t);
                         matrix(2,1) = matrix(2,1) + gr_x*gr_y*W(k,t);
                         matrix(2,2) = matrix(2,2) + gr_y*gr_y*W(k,t);
                         sum1 = sum1 + (im1(i-1+k,j-1+t)-im2(i-1+k,j-1+t))*gr_x*W(k,t);
                         sum2 = sum2 + (im1(i-1+k,j-1+t)-im2(i-1+k,j-1+t))*gr_y*W(k,t);
                     end
                 end
                 %I changed (-1) to 1, otherwise the arrow directions are
                 %opposite
                 result = (inv(matrix))*[sum1; sum2];
                 matrix_vx(i, j) = result(1,1);
                 matrix_vy(i, j) = result(2,1);
             end
         end
        Vx = matrix_vx;
        Vy = matrix_vy;

    case "LK_iterative"
        % YOUR IMPLEMENTATION GOES HERE
        %Hx and Hy are the overall vectors
        Hx=0;
        Hy=0;
        %iterate for N times
        N=5;
        im1=frame_1;
        for i=1:N
            [hx, hy] = compute_LK_optical_flow(im1,frame_2,"LK_naive");
            [sx, sy] = size(hx);
            for k = 1:sx
                for t = 1:sy
                    k1 = k+round(hx(k,t));
                    t1 = t+round(hy(k,t));
                    if k1<1
                        k1=1;
                    end
                    if k1>sx
                        k1=sx;
                    end
                    if t1<1
                        t1=1;
                    end
                    if t1>sy
                        t1=sy;
                    end  
                    im1(k, t) = frame_1(k1, t1);
                end
            end       
            Hx = Hx + hx;
            Hy = Hy + hy;
            %check if all entries in hx and hy are below a threshold
            if max(max(abs(hx)))<2 && max(max(abs(hy)))<2
                break
            end
        end
        Vx = Hx;
        Vy = Hy;

    case "LK_pyramid"
        % YOUR IMPLEMENTATION GOES HERE
        
        %generate pyramid 1
        im1_0 = frame_1;
        im1_1 = imresize(imgaussfilt(im1_0, 2), 0.5);
        im1_2 = imresize(imgaussfilt(im1_0, 4), 0.5^2);
        im1_3 = imresize(imgaussfilt(im1_0, 8), 0.5^3);
        pyramid1 = {im1_0, im1_1, im1_2, im1_3};

        %generate pyramid2
        im2_0 = frame_2;
        im2_1 = imresize(imgaussfilt(im2_0, 2), 0.5);
        im2_2 = imresize(imgaussfilt(im2_0, 4), 0.5^2);
        im2_3 = imresize(imgaussfilt(im2_0, 8), 0.5^3);
        pyramid2 = {im2_0, im2_1, im2_2, im2_3};
        
        %Hx and Hy are holding the overal displacement vectors
        Hx=zeros(size(im1_3,1),size(im1_3,2));
        Hy=zeros(size(im1_3,1),size(im1_3,2));
        
        %im1_temp is the temporary updating coarse to fine image
        im1_temp = pyramid1{1,4};
        for i = 1:4
            [vx, vy] = compute_LK_optical_flow(im1_temp,pyramid2{1,5-i},"LK_iterative");
            if i == 4
                Hx = Hx+vx;
                Hy = Hy+vy;
            else
                im_next = pyramid1{1,5-i-1};
                sx = size(im_next,1);
                sy = size(im_next,2);
                %interpolation process
                Mx = zeros(sx, sy);
                My = zeros(sx, sy);
                for p = 1:sx
                    for q = 1:sy
                        if mod(p,2)==0 && mod(q,2)==0
                            Mx(p,q) = 2*Hx(p/2, q/2);
                            My(p,q) = 2*Hy(p/2, q/2);
                        end
                    end
                end     
                Hx = Mx;
                Hy = My;

                for k=1:sx
                    for t=1:sy
                        k1 = k+round(Hx(k,t));
                        t1 = t+round(Hy(k,t));
                        if k1<1
                            k1=1;
                        end
                        if k1>sx
                            k1=sx;
                        end
                        if t1<1
                            t1=1;
                        end
                        if t1>sy
                            t1=sy;
                        end  
                        im_next(k, t) = im_next(k1, t1);
                    end
                end
                im1_temp = im_next;
             end
        end
        Vx = Hx;
        Vy = Hy;
end
