function  [P, K, R, C] =  calibrate(XYZ, xy)

%  Create the data matrix to be used for the least squares.
%  and perform SVD to find matrix P.

%  BEGIN CODE STUB (REPLACE WITH YOUR OWN CODE)
  
%A is the data matrix, the size is 2*N by 12
[sx, sy] = size(XYZ);
A = zeros(2*sx,sy);
for i=1:2*sx
    if mod(i, 2)==0
        A(i, 5) = XYZ(i/2, 1);
        A(i, 6) = XYZ(i/2, 2);
        A(i, 7) = XYZ(i/2, 3);
        A(i, 8) = 1;
        A(i, 9) = (-1)*xy(i/2,2)*XYZ(i/2, 1);
        A(i, 10) = (-1)*xy(i/2,2)*XYZ(i/2, 2);
        A(i, 11) = (-1)*xy(i/2,2)*XYZ(i/2, 3);
        A(i, 12) = (-1)*xy(i/2,2);
    else
        A(i, 1) = XYZ(ceil(i/2), 1);
        A(i, 2) = XYZ(ceil(i/2), 2);
        A(i, 3) = XYZ(ceil(i/2), 3);
        A(i, 4) = 1;
        A(i, 9) = (-1)*xy(ceil(i/2),1)*XYZ(ceil(i/2), 1);
        A(i, 10) = (-1)*xy(ceil(i/2),1)*XYZ(ceil(i/2), 2);
        A(i, 11) = (-1)*xy(ceil(i/2),1)*XYZ(ceil(i/2), 3);
        A(i, 12) = (-1)*xy(ceil(i/2),1);
    end
end

[U, S, V] = svd(A);

%vector is the eigenvector that corresponds to the smallest eigenvalue
v = V(:,12); %since S returns a vector in decreasing order and 
             %columns of V ordered to corresponds to S

P = [v(1:4)'; v(5:8)'; v(9:12)'];

[K, R, C] = decomposeProjectionMatrix(P);

%  END CODE STUB 

%P = K * R * [eye(3), -C];
%[K, R, C] = decomposeProjectionMatrix(P);
