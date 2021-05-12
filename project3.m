%% Spatial Statistics and Image Analysis - TMS016
addpath('/Users/hannaskytt/Library/Mobile Documents/com~apple~CloudDocs/Documents/Chalmers/Master/Årskurs_4/Spatial Statistics and Image Analysis/TMS016_Matlab')
tms016path

% LOAD AND PREPROCESS DATA
clc, clear
clf, close all

% Load original image
img_orig = im2double(imread("Data/DB1_B/109_7.tif"));
[m, n] = size(img_orig);

% NORMALIZATION

img_norm = zeros(m,n);
img_mean = mean(img_orig(:));
img_var = var(img_orig(:));
mean0 = 150/255;
var0 = 50/255;

for i = 1:m
    for j = 1:n
        if img_orig(i,j) >= img_mean
            img_norm(i,j) = mean0 + sqrt(var0*(img_orig(i,j)-img_mean)^2/img_var);
        else
            img_norm(i,j) = mean0 - sqrt(var0*(img_orig(i,j)-img_mean)^2/img_var);
        end
    end
end

% SEGMENTATION

% Dividing into blocks
w = 10;
M = floor(m/w);
N = floor(n/w);

rw = w*ones(1, M);
cw = w*ones(1, N);

C = mat2cell(img_norm, rw, cw);  % Divides the image into blocks

block_means = zeros(size(C));
block_variances = zeros(size(block_means));

for i=1:M
    for j=1:N
        block = reshape(C{i, j}, 1, []);
        block_means(i, j) = mean(block(:));
        block_variances(i, j) = var(block(:));
    end
end

% The mean of the means
bmm = mean(block_means(:));

% The mean of the variances
bvm = mean(block_variances(:));

% Calculate the relative mean and variance

% Foreground mean
m_frg = block_means(block_means > bmm);  % vector
M_frg = mean(m_frg(:));

% Foreground variance
v_frg = block_variances(block_variances > bvm);  % vector
V_frg = mean(v_frg(:));

%Background means
m_bkg = block_means(block_means <= bmm); % vector
M_bkg = mean(m_bkg(:));

% Background variance
v_bkg = block_variances(block_variances <= bvm);  % vector
V_bkg = mean(v_bkg(:));

% blocks with greater mean and smaller variance is the background. Set
% those to zero

for i=1:M
    for j=1:N
        if block_means(i, j) >= M_bkg && block_variances(i, j) <= V_bkg
            C{i, j} = zeros(w, w);
        end
    end
end

img_seg = cell2mat(C);

% ORIENTATION FIELD

% Calculate gradient
Gx = zeros(m, n);
Gy = zeros(m, n);

x = img_seg;
for i=2:m-1
    for j=2:n-1
        Gx(i, j) = (x(i + 1, j) -x(i - 1, j))/2;
        Gy(i, j) = (x(i, j + 1) - x(i, j - 1))/2;
    end
end

% Metrics for computing theta
Gsx = zeros(m, n);
Gsy = zeros(m, n);

% For calculating theta
for i=2:m-1
    for j=2:n-1
        Gsx(i, j) = Gx(i,j)^2 - Gy(i,j)^2;
        Gsy(i,j) = 2*Gx(i, j)*Gy(i, j);
    end
end

Gmsx = zeros(M, N);
Gmsy = zeros(M, N);

% block sum
for i=1:M
    for j=1:N
        for xx=1 + (i-1)*w:i*w
            for yy=1 + (j-1)*w:j*w
                Gmsx(i, j) = Gmsx(i, j) + Gsx(xx, yy);
                Gmsy(i, j) = Gmsy(i, j) + Gsy(xx, yy);
            end
        end
    end
end

% Get the orientations
theta = zeros(M, N);
for i=1:M
    for j=1:N
        k = Gmsy(i, j)/Gmsx(i, j);
        
        if Gmsx(i, j)>0
            theta(i,j) = pi/2 + atan(k)/2;
        end
        
        if Gmsx(i, j)<0 && Gmsy(i,j)>=0
            theta(i,j) = pi/2 + (atan(k) + pi)/2;
        end
        
        if Gmsx(i, j)<0 && Gmsy(i, j) <0
            theta(i,j) = pi/2 + (atan(k) - pi)/2;
        end
    end
end

% GAUSSIAN FILTER
%filtering
phix = cos(2*theta);
phiy = sin(2*theta);

gaussian_filter = fspecial('gaussian', 10, 2);
phix_prim = filter2(gaussian_filter, phix);
phiy_prim = filter2(gaussian_filter, phiy);

theta_prim = 1/2*atan2(phiy_prim, phix_prim);

%% PLOTTING

figure(1);
subplot(2,2,1)
imshow(img_orig)
title('Original image')

subplot(2,2,2)
imshow(img_seg)
title('Segmented image')

subplot(2,2,3)
imshow(img_seg);
title('Orientation field')
hold on
for i=1:M
    for j=1:N
        if mean(C{i,j}(:)) == 0
        else
            T = theta(i, j);
            x_s = round(w/2) + (i - 1)*w;
            y_s = round(w/2) + (j - 1)*w;
            len = 10;
            x_e = x_s + len*cos(T);
            y_e = y_s + len*sin(T);
            plot([y_s, y_e], [x_s, x_e], '-r')
        end
    end
end
hold off

subplot(2,2,4);
imshow(img_seg)
title('Orientation field with Gaussian filter')
hold on;
for i=1:M
    for j=1:N
        if mean(C{i,j}(:)) == 0
        else
            T = theta_prim(i, j);
            x_s = round(w/2) + (i - 1)*w;
            y_s = round(w/2) + (j - 1)*w;
            len = 10;
            x_e = x_s + len*cos(T);
            y_e = y_s + len*sin(T);
            plot([y_s, y_e], [x_s, x_e], '-r')
        end
    end
end
hold off;

sgtitle('Image enhancement') 