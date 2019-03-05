clear
close all

%hard code K1, K2
%set 1 mm to be 20 pixels
im1 = im2double(imread('c1.jpg'));
[sx, sy, d] = size(im1);

sx2 = round(sx/sqrt(2));
sy2 = round(sy/sqrt(2));
im2 = zeros(sx2,sy2,3);

%K1 = [50*sx/23.6, 0, sx/2; 0, 50*sy/15.8, sy/2; 0, 0, 1];
T1 = [1 0 sx/2; 0 1 sy/2; 0 0 1];
S1 = [sx/23.6 0 0; 0 sy/15.8 0; 0 0 1];
F1 = [50 0 0; 0 50 0; 0 0 1];
K1 = T1*S1*F1;

%K2 = [25*sx/23.6/sqrt(2), 0, sx/2/sqrt(2); 0, 25*sy/15.8/sqrt(2), sy/2/sqrt(2); 0, 0, 1];
T2 = [1 0 sx2/2; 0 1 sy2/2; 0 0 1];
S2 = [sx2/23.6 0 0; 0 sy2/15.8 0; 0 0 1];
F2 = [25 0 0; 0 25 0; 0 0 1];
K2 = T2*S2*F2;
%R_total is R_rect*R1*R2^(-1), where R_rect and R1 are identity matrix, R2
%is a rotation matrix that rotates a theta angle
theta1 = 0/180*pi;
theta2 = 10/180*pi;
theta3 = 20/180*pi;
%Since for matrix, columns are in x axis, rows are in y axis, so I rotate x
%axis here
R_total1  = [1 0 0; 0 cos(theta1) sin(theta1); 0 -sin(theta1) cos(theta1)];
R_total2  = [1 0 0; 0 cos(theta2) sin(theta2); 0 -sin(theta2) cos(theta2)];
R_total3  = [1 0 0; 0 cos(theta3) sin(theta3); 0 -sin(theta3) cos(theta3)];
H1 = K1*inv(R_total1)*inv(K2);
H2 = K1*inv(R_total2)*inv(K2);
H3 = K1*inv(R_total3)*inv(K2);

%0 degrees
im2_0 = zeros(sx2, sy2,3);
%10 degrees
im2_10 = zeros(sx2, sy2,3);
%20 degrees
im2_20 = zeros(sx2, sy2,3);

for i = 1:sx2
    for j = 1:sy2
        v1 = [i;j;1];
        v = H1*v1;        
        v = round(v/v(3));
        x = v(1);
        y = v(2);
        if x<1 || x>sx || y<1 || y>sy
        else
            im2_0(i,j,:) = im1(x,y,:);
        end
    end
end

for i = 1:sx2
    for j = 1:sy2
        v1 = [i;j;1];
        v = H2*v1;        
        v = round(v/v(3));
        x = v(1);
        y = v(2);
        if x<1 || x>sx || y<1 || y>sy
        else
            im2_10(i,j,:) = im1(x,y,:);
        end
    end
end

for i = 1:sx2
    for j = 1:sy2
        v1 = [i;j;1];
        v = H3*v1;        
        v = round(v/v(3));
        x = v(1);
        y = v(2);
        if x<1 || x>sx || y<1 || y>sy
        else
            im2_20(i,j,:) = im1(x,y,:);
        end
    end
end

figure(1)
imshow(im2_0);
figure(2)
imshow(im2_10);
figure(3)
imshow(im2_20);

