%% Test
clc
clearvars
addpath('C:\Users\admin\Desktop\Skola\Image Analysis')
addpath('C:\Users\admin\Desktop\Skola\Image Analysis\TMS016_matlab\TMS016_funftions')
addpath('C:\Users\admin\Desktop\Skola\Image Analysis\\')
x = imread('101_2.tif');
%x = imread('testare.png');
%x = rgb2gray(x);
%x = imread('101_2.tif');
x = double(x)/255;

%dumb test code
%x=x(3:322, 6:325);
%size(x)

[m, n, d] = size(x);
figure(1)
imshow(x)
%% Normalizing image
% Flatten image
x_t = reshape(x, 1, []);

% Average
scale = 1/(n*m);
M_image = sum(x_t)*scale;

% Variance
V = scale*(sum((x_t - M_image).^2));

V_0 = 50/255; % from litterature
M_0 = 150/255; % fomr litterature

N_t = zeros(size(x_t));

for i=1:n*m
   if x_t(i) < M_image 
      norm = M_0 - sqrt(V_0*((x_t(i) - M_image)^2)/V);
      N_t(i) = norm;
   else
      N_t(i) = M_0 + sqrt(V_0*((x_t(i) - M_image)^2)/V);
   end
end
%%
figure(2)
imshow(reshape(N_t, m, []))
%% Image segmentation

% Dividing into blocks
w = 20;
M = floor(m/w);
N = floor(n/w);

rw = w*ones(1, M);
cw = w*ones(1, N);

C = mat2cell(reshape(N_t, m, []), rw, cw);  % Divides the image into 20x20 blocks, 24*32 of them
%%
block_means = zeros(size(C));
block_variances = zeros(size(block_means));

for i=1:M
    for j=1:N
       block = reshape(C{i, j}, 1, []);
       mean = sum(block)/(w * w);
       block_means(i, j) = mean;
       block_variances(i, j) = sum((block - mean).^2)/(w * w);
    end 
end

% The mean of the means
bmm = sum(reshape(block_means, 1, []))/(M*N);

% The mean of the variances
bvm = sum(reshape(block_variances, 1, []))/(M*N);

% Calculate the relative mean and variance

% Foreground mean divided by number of elements smaller than the mean of
% means
m_frg = block_means(block_means > bmm);  % vector
M_frg = sum(m_frg)/size(m_frg, 1);

% Foreground variance divided by number of elements greater than the mean
% of variances
v_frg = block_variances(block_variances > bvm);  % vector
V_frg = sum(v_frg)/size(v_frg, 1);

%Background mean divided by number of elements smaller than the mean of
%means
m_bkg = block_means(block_means <= bmm); % vector
M_bkg = sum(m_bkg)/size(m_bkg, 1);

% Background variance
v_bkg = block_variances(block_variances <= bvm);  % vector
V_bkg = sum(v_bkg)/size(v_bkg, 1);

%%
% blocks with mean and variance < background 
empty_blocks = [];
full_blocks = [];
for i=1:M
    for j=1:N
        if block_means(i, j) >= M_bkg && block_variances(i, j) <= V_bkg
            C{i, j} = zeros(w, w);
            empty_blocks = [empty_blocks; i j];
        else
            full_blocks = [full_blocks; i j];
        end
    end
end
%%
disp(size(empty_blocks));
disp(size(full_blocks));
image_out = cell2mat(C);
figure(3)
imshow(image_out);

%% Testing the new gradient computation

% Gradients
Gx = zeros(m, n);
Gy = zeros(m, n);

% Metrics for computing theta
Gsx = zeros(m, n);
Gsy = zeros(m, n);

% Gradient
for i=2:m-1
    for j=2:n-1
        Gx(i, j) = (x(i + 1, j) - x(i - 1, j))/2;
        Gy(i, j) = (x(i, j + 1) - x(i, j - 1))/2;
    end
end

% For calculating theta
for i=2:m-1
    for j=2:n-1
        Gsx(i, j) = Gx(i,j)^2 - Gy(i,j)^2;
        Gsy(i,j) = 2*Gx(i, j)*Gy(i, j);
    end 
end

Gbx2 = zeros(M, N);
Gby2 = zeros(M, N);
% block sum
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

theta2 = zeros(M, N); % Den viktiga
theta3 = zeros(M, N); % ???????????
for i=1:M
    for j=1:N
        k = Gby2(i, j)/Gbx2(i, j);
        
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

% Väldigt oklart vad det här var, borde kunna ta bort
for i=1:M
    for j=1:N
        theta3(i, j) = atan(Gby2(i, j)/Gbx2(i, j))/2; % ????????????
    end
end

%filtering
phix = cos(2*theta2);
phiy = sin(2*theta2);

f = fspecial('gaussian', 10, 2);
phix = filter2(f, phix);
phiy = filter2(f, phiy);

O1 = 0.5*atan2(phiy, phix);
%% Plotting
figure(5)
%imshow(image_out)
hold on
for i=1:M
    for j=1:N
        T = O1(i, j);
        x_s = round(w/2) + (i - 1)*w;
        y_s = round(w/2) + (j - 1)*w;
        len = 10;
        x_e = x_s + len*cos(T);
        y_e = y_s + len*sin(T);
        plot([y_s, y_e], [x_s, x_e])
    end
end

%% Fourier time bby





