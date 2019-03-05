
I = imread('c1.jpg');
readPositions;
[P, K, R, C] = calibrate(XYZ, xy1);

xy = xy1;
numPositions = length(XYZ);

% Q2.A -- K vs R
    %Mr is the matrix that modifies R
    theta = 0.05;
    Mr = [cos(theta), 0, sin(theta); 0 1 0; -sin(theta), 0, cos(theta)];
    P1_r = K*Mr*R*[1 0 0 -C(1); 0 1 0 -C(2); 0 0 1 -C(3)];
    %Mk_r is the matrix that modifies K based on Mr
    %the way I approximate a Mk_r is by Mk_r = K*Mr*inv(K);
    Mk_r = [1 0 300; -0.005 1 0.7; 0 0 1];
    P1_k = Mk_r*K*R*[1 0 0 -C(1); 0 1 0 -C(2); 0 0 1 -C(3)];
    
    figure(1)
    imshow(I);
    title('Shift: K vs. R - Modify R');
    hold on
    %  Draw in green the keypoints locations that were hand selected.
    for j = 1:numPositions
     plot(xy(j,1),xy(j,2),'g*');
    end
    %draw shift points
    for j = 1:numPositions
    p = P1_r*[ XYZ(j,1) XYZ(j,2) XYZ(j,3) 1]';
    x = p(1)/p(3);
    y = p(2)/p(3);
    plot(round(x),round(y),'ws');
    end
    hold off

    figure(2)
    imshow(I);
    title('Shift: K vs. R - Modify K');
    hold on
    %  Draw in green the keypoints locations that were hand selected.
    for j = 1:numPositions
     plot(xy(j,1),xy(j,2),'g*');
    end 
    %draw shift points
    for j = 1:numPositions
    p = P1_k*[ XYZ(j,1) XYZ(j,2) XYZ(j,3) 1]';
    x = p(1)/p(3);
    y = p(2)/p(3);
    plot(round(x),round(y),'ys');
    end
    hold off

%Q2.A -- K vs C

    %Mc is the matrix that modifies C
    Mc = [1.1 0 0; 0 1 0; 0 0 1.2];
    C1 = Mc * C;
    RC1 = [R -R*C1; 0 0 0 1];
    P2_c = [K [0 0 0]' ; 0 0 0 1]*RC1;
    %Mk_c is the matrix that modifies K based on Mc
    RC = [R -R*C; 0 0 0 1];
    %the way I approximate a Mk_c is by Mk_c = [K [0 0 0]' ; 0 0 0 1] * RC1 * inv(RC) * inv([K [0 0 0]' ; 0 0 0 1]);
    Mk_c = [1 0 0 -0.332; 0 1 0 0.173; 0 0 1 -0.0001; 0 0 0 1];
    P2_k = Mk_c*[K [0 0 0]' ; 0 0 0 1]*RC;
    
    figure(3)
    imshow(I);
    title('Shift: K vs. C - Modify C');
    hold on
    %  Draw in green the keypoints locations that were hand selected.
    for j = 1:numPositions
     plot(xy(j,1),xy(j,2),'g*');
    end
    %draw shift points
    for j = 1:numPositions
    p = P2_c*[ XYZ(j,1) XYZ(j,2) XYZ(j,3) 1]';
    x = p(1)/p(3);
    y = p(2)/p(3);
    %  Draw in white square the projected point positions according to the fit model.
    plot(round(x),round(y),'ws');
    end
    hold off
    
    figure(4)
    imshow(I);
    title('Shift: K vs. C - Modify K');
    hold on   
    %  Draw in green the keypoints locations that were hand selected.
    for j = 1:numPositions
     plot(xy(j,1),xy(j,2),'g*');
    end   
    %draw shift points
    for j = 1:numPositions
    p = P2_k*[ XYZ(j,1) XYZ(j,2) XYZ(j,3) 1]';
    x = p(1)/p(3);
    y = p(2)/p(3);
    %  Draw in white square the projected point positions according to the fit model.
    plot(round(x),round(y),'ys');
    end
    hold off

%Q2.B -- K vs C

    %Mc_s is the matrix that modifies C
    Mc_s = [0.7 0 0; 0 0.7 0; 0 0 0.7];
    C1 = Mc_s * C;
    RC1 = [R -R*C1; 0 0 0 1];
    P3_c_s = [K [0 0 0]' ; 0 0 0 1]*RC1;
    %Mk_c_s is the matrix that modifies K based on Mc_s
    %the way I approximate a Mk_c_s is by Mk_c_s = [K [0 0 0]' ; 0 0 0 1] * RC1 * inv(RC) * inv([K [0 0 0]' ; 0 0 0 1]);
    RC = [R -R*C; 0 0 0 1];
    Mk_c_s = [1 0 0 0.2961; 0 1 0 0.48; 0 0 1 0.002; 0 0 0 1];
    P3_k_s = Mk_c_s*[K [0 0 0]' ; 0 0 0 1]*RC;

    figure(5)
    imshow(I);
    title('Scaling: K vs. C - Modify C');
    hold on
    %  Draw in green the keypoints locations that were hand selected.
    for j = 1:numPositions
     plot(xy(j,1),xy(j,2),'g*');
    end   
    %draw shift points
    for j = 1:numPositions
    p = P3_c_s*[ XYZ(j,1) XYZ(j,2) XYZ(j,3) 1]';
    x = p(1)/p(3);
    y = p(2)/p(3);
    %  Draw in white square the projected point positions according to the fit model.
    plot(round(x),round(y),'ws');
    end
    hold off
    
    figure(6)
    imshow(I);
    title('Scaling: K vs. C - Modify K');
    hold on       
    %  Draw in green the keypoints locations that were hand selected.
    for j = 1:numPositions
     plot(xy(j,1),xy(j,2),'g*');
    end    
    %draw shift points
    for j = 1:numPositions
    p = P3_k_s*[ XYZ(j,1) XYZ(j,2) XYZ(j,3) 1]';
    x = p(1)/p(3);
    y = p(2)/p(3);
    %  Draw in white square the projected point positions according to the fit model.
    plot(round(x),round(y),'ys');
    end
    hold off
 
 
 

