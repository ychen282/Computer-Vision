%Q1

%Q1a

%variables for test
N=5;
sigma=1;

function g = make2DGaussian(N, sigma)
    kernel = zeros(N, N);
    sum = 0;
    for i = 1:N
        for j = 1:N
            d = (i-(N+1)/2)^2 + (j-(N+1)/2)^2;
            kernel(i, j) = (1/(2*pi*sigma*sigma))*exp((-d)/(2*sigma*sigma));
            sum = sum + kernel(i, j);
        end
    end
    %nomalize the kernel
    g = kernel/sum;
end

%Q1b

function im = myConv2(image, filter)
    %size of image
    [sizeIx, sizeIy] = size(image);
    %size of filter
    sizeF = size(filter, 1);
    %pad the image
    withPadding = [zeros(sizeIx+sizeF-1, (sizeF-1)/2) [zeros((sizeF-1)/2, sizeIy); image; zeros((sizeF-1)/2, sizeIy)] zeros(sizeIx+sizeF-1, (sizeF-1)/2)];
    filtered = zeros(sizeIx, sizeIy);
    %flip the kernel 
    filter = flip(filter,1);
    filter = flip(filter,2);
    %flipped filter loops around withPadding matrix
    for p = 1 : sizeIx
        for q = 1 : sizeIy
            result = 0;
          for i = 1 : sizeF
              for j = 1 : sizeF
                  result = result + withPadding(p+i-1, q+j-1)*filter(i,j);
              end
          end
            filtered(p,q) = result;
        end
    end
    im = filtered;
end


