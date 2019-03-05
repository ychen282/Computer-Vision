clear
close all

%data
XYZ = [0 0 0; ...
    0 0 1;
    0 1 0;
    0 1 1;
    1 0 0;
    1 0 1;
    1 1 0;
    1 1 1];

K = [300 0 30; 0 300 -30; 0 0 1];

num_degrees = 10;
theta_y = num_degrees *pi/180;
R_y = [cos(theta_y) 0 sin(theta_y);  0 1 0;  -sin(theta_y) 0  cos(theta_y)];
C = [0.5 0.5 -2]';
numPositions = size(XYZ,1);

% Comparison - Shift: R vs. K
    
    %modify R by an additional rotation matrix Mr
    theta = 0.05;
    Mr = [cos(theta), 0, sin(theta); 0 1 0; -sin(theta), 0, cos(theta)];
    P_r = K*(Mr*R_y)*[1 0 0 -C(1); 0 1 0 -C(2); 0 0 1 -C(3)];
    %modify K an additional rotation matrix Mk
    Mk = [1 0 15; -0.01 1 1; 0 0 1];
    P_k = (Mk*K)*R_y*[1 0 0 -C(1); 0 1 0 -C(2); 0 0 1 -C(3)];
    
    figure(1);
    hold on;

    %plot shifted points
    for j = 1:numPositions
       p = P_r*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
       x = p(1)/p(3);
       y = p(2)/p(3);
       plot(x, y,'r*');
    end
    for j = 1:numPositions
       p = P_k*[ XYZ(j,1) XYZ(j,2) XYZ(j,3) 1]';
       x = p(1)/p(3);
       y = p(2)/p(3);
       plot(x, y,'b*');
    end
    hold off;
    disp("Shift - R-modified P and K-modified P:");
    disp([P_r, P_k]);
    
% Comparison - Shift: C vs. K
  
    %modify C by an additional rotation matrix Mc
    Mc = [1.1 0 0; 0 1 0; 0 0 1.2];
    C1 = Mc * C;
    RC1 = [R_y -R_y*C1; 0 0 0 1];
    P_c = [K [0 0 0]' ; 0 0 0 1]*RC1;

    %modify K an additional rotation matrix Mk_c
    RC = [R_y -R_y*C; 0 0 0 1];
    %Mk_c = [1 0 0 0; 0 1 0 0.19; 0 0 1 0.24; 0 0 0 1];
    Mk_c = [1 0 0 -0.3319; 0 1 0 0.1727; 0 0 1 -0.0001; 0 0 0 1];
    P_k_c = Mk_c*[K [0 0 0]' ; 0 0 0 1]*RC;
    
    figure(2);
    hold on;
    
    %plot shifted points
    for j = 1:numPositions
       p = P_c*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
       x = p(1)/p(3);
       y = p(2)/p(3);
       plot(x, y,'r*');
    end
    for j = 1:numPositions
       p = P_k_c*[ XYZ(j,1) XYZ(j,2) XYZ(j,3) 1]';
       x = p(1)/p(3);
       y = p(2)/p(3);
       plot(x, y,'b*');
    end
    hold off;
    disp("Shift - C-modified P and K-modified P:");
    disp([P_c, P_k_c]);
  

% Comparison - Expansion: C vs. K

    %Mc_s is the matrix that modifies C
    Mc_s = [0.9 0 0; 0 0.9 0; 0 0 0.9];
    C1 = Mc_s * C;
    RC1 = [R_y -R_y*C1; 0 0 0 1];
    P_c_s = [K [0 0 0]' ; 0 0 0 1]*RC1;
    %Mk_c_s is the matrix that modifies K based on Mc_s
    RC = [R_y -R_y*C; 0 0 0 1];
    Mk_c_s = [1 0 0 0.296; 0 1 0 0.0483; 0 0 1 0.002; 0 0 0 1];
    P_k_s = Mk_c_s*[K [0 0 0]' ; 0 0 0 1]*RC;
    
    figure(3);
    hold on;  
    %plot shifted points
    for j = 1:numPositions
       p = P_c_s*[ XYZ(j,1) XYZ(j,2) XYZ(j,3)  1]';
       x = p(1)/p(3);
       y = p(2)/p(3);
       plot(x, y,'r*');
    end
    for j = 1:numPositions
       p = P_k_s*[ XYZ(j,1) XYZ(j,2) XYZ(j,3) 1]';
       x = p(1)/p(3);
       y = p(2)/p(3);
       plot(x, y,'b*');
    end
    hold off;
    disp("Shift - C-modified P and K-modified P:");
    disp([P_c_s, P_k_s]);