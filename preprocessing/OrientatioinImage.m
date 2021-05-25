function [O1] = OrientatioinImage(image, M, N, fig_nr, w)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%% INPUT:

%% OUTPUT:
[m, n] = size(image);
x = image;
% Allocate gradients
Gx = zeros(m, n);
Gy = zeros(m, n);

% Allocate space for Gx^2 -Gy^2 and 2*Gx*Gy
Gsx = zeros(m, n);
Gsy = zeros(m, n);

% Compute gradient using central difference, ignoring first and last row,
% first and last column -> very little happens there
for i=2:m-1
    for j=2:n-1
        Gx(i, j) = (x(i + 1, j) - x(i - 1, j))/2;
        Gy(i, j) = (x(i, j + 1) - x(i, j - 1))/2;
    end
end

% Computing Gsx and Gsy once again ignoring first and last rows and columns
for i=2:m-1
    for j=2:n-1
        Gsx(i, j) = Gx(i,j)^2 - Gy(i,j)^2;
        Gsy(i,j) = 2*Gx(i, j)*Gy(i, j);
    end 
end

% Allocating space for block sums of Gsx and Gsy
Gbx2 = zeros(M, N);
Gby2 = zeros(M, N);

% Summing up the blocks
% Could be done using cells instead to limit use of loops but is still fast
for i=1:M
    for j=1:N
        for xx=1 + (i-1)*w:i*w
            for yy=1 + (j-1)*w:j*w
                Gbx2(i, j) = Gbx2(i, j) + Gsx(xx, yy);
                Gby2(i, j) = Gby2(i, j) + Gsy(xx, yy);
            end
        end
    end
end

% Allocating space for theta
theta2 = zeros(M, N); % Den viktiga

% Computing theta
for i=1:M
    for j=1:N
        k = Gby2(i, j)/Gbx2(i, j);
        
        % Orienting theta along the ridges
        if Gbx2(i, j)>0
            theta2(i,j) = pi/2 + atan(k)/2;
        end
        
        if Gbx2(i, j)<0 && Gby2(i,j)>=0
            theta2(i,j) = pi/2 + (atan(k) + pi)/2;
        end
        
        if Gbx2(i, j)<0 && Gby2(i, j) <0
            theta2(i,j) = pi/2 + (atan(k) - pi)/2;
        end
    end
end

% Creating vector field to compute the orientation and filter it
phix = cos(2*theta2);
phiy = sin(2*theta2);

O_unfiltered = 0.5*atan2(phiy,phix);

% Filter the vector field using a gaussian filter with size 5 and sigma=2
f = fspecial('gaussian', 5, 2);
phix_f = filter2(f, phix);
phiy_f = filter2(f, phiy);

O1 = 0.5*atan2(phiy_f, phix_f);
%% Plotting
figure(fig_nr)
imshow(uint8(255-image))
hold on
for i=1:M
    for j=1:N
        T = O1(i, j);
        x_s = round(w/2) + (i - 1)*w;
        y_s = round(w/2) + (j - 1)*w;
        len = 10;
        x_e = x_s + len*cos(T);
        y_e = y_s + len*sin(T);
        plot([y_s, y_e], [x_s, x_e], 'r-')
    end
end

end

