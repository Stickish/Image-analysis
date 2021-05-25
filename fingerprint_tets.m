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
x = double(x);% /255;

%invert image
x = 255 - x;
x = double(x);
%dumb test code
%x=x(3:322, 6:325);
%size(x)

[m, n, d] = size(x);
figure(1)
imshow(uint8(255-x))
%% Normalizing image
% Flatten image
x_t = reshape(x, 1, []);

% Average
scale = 1/(n*m);
M_image = sum(x_t)*scale;

% Variance
V = scale*(sum((x_t - M_image).^2));

V_0 = 50; %/255; % from litterature
M_0 = 150; %/255; % fomr litterature

N_t = zeros(size(x_t));

for i=1:n*m
   if x_t(i) < M_image 
      norm = M_0 - sqrt(V_0*((x_t(i) - M_image)^2)/V);
      N_t(i) = norm;
   else
      N_t(i) = M_0 + sqrt(V_0*((x_t(i) - M_image)^2)/V);
   end
end

% rescale
idx = find(N_t<0);
N_t(idx) = 0;

%%
figure(2)
imshow(uint8(255 - reshape(N_t, m, [])))
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
       block_mean = sum(block)/(w * w);
       block_means(i, j) = block_mean;
       block_variances(i, j) = sum((block - block_mean).^2)/(w * w);
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
        if block_means(i, j) <= M_bkg && block_variances(i, j) <= V_bkg
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
imshow(uint8(255-image_out));

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

O_unfiltered = 0.5*atan2(phiy,phix);

f = fspecial('gaussian', 5, 2);
phix = filter2(f, phix);
phiy = filter2(f, phiy);

O1 = 0.5*atan2(phiy, phix);
%% Plotting
figure(5)
imshow(uint8(255-image_out))
hold on
for i=1:M
    for j=1:N
        T = O_unfiltered(i, j);
        x_s = round(w/2) + (i - 1)*w;
        y_s = round(w/2) + (j - 1)*w;
        len = 10;
        x_e = x_s + len*cos(T);
        y_e = y_s + len*sin(T);
        plot([y_s, y_e], [x_s, x_e], 'r-')
    end
end

%% Fourier time bby
% Constants
minWaveLength = 5;
maxWaveLength = 25;
windsze = w/2;
frequencies = zeros(m,n);
C_f = mat2cell(frequencies, rw, cw);
block_freq = zeros(M, N);
for i=1:M
    for j=1:N
        im = C{i, j};
        orient = O1(i,j);
        
        % Rotate image
        rotim = imrotate(im,orient/pi*180+90,'nearest', 'crop');
        
        % Crop image
        cropsze = fix(w/sqrt(2)); offset = fix((w-cropsze)/2);
        rotim = rotim(offset:offset+cropsze, offset:offset+cropsze);
        
        % Sum the values of ridges and valleys
        proj = sum(rotim);
        
        % Find peaks in projected grey values by performing a greyscale
        % dilation and then finding where the dilation equals the original
        % values.

        dilation = ordfilt2(proj, windsze, ones(1,windsze));
        maxpts = (dilation == proj) & (proj > mean(proj));
        maxind = find(maxpts);
        
        if length(maxind) >= 2
            num_peaks = length(maxind);
            lambda = (maxind(end)-maxind(1))/(num_peaks-1);
            
            if lambda > minWaveLength && lambda < maxWaveLength
                C_f{i, j} = 1/lambda * ones(size(im));
                block_freq(i, j) = 1/lambda;
            end
        
        end
    end
end
%%
figure(8)
subplot(2,1,1)
freq_image = cell2mat(C_f);
num_full_blocks = size(full_blocks,1);
imshow(freq_image)

temp_mat = zeros(m,n);
temp_cell = mat2cell(temp_mat, rw, cw);

for idx=1:num_full_blocks
    i = full_blocks(idx,1);
    j = full_blocks(idx,2);
    temp_cell{i,j} = ones(w,w);
end

subplot(2,1,2)
imshow(cell2mat(temp_cell))
%% Smoothen the frequencies
clc
new_freq = SmoothFrequencies(block_freq, 9, 7, full_blocks);
nfc = mat2cell(zeros(m, n), rw, cw);
for i=1:M
    for j=1:N
        nf = ones(w, w)*new_freq(i, j);
        nfc{i, j} = nf;
    end
end

f = fspecial('gaussian', 7, 1); % size from litterature, sigma=1 looked ok

nfm = cell2mat(nfc);
nfm = filter2(f, nfm);  
figure(15)
imshow(nfm)

%% Enhancing image with Gabor filter

E = image_out;
C_E = mat2cell(E, rw, cw);
magn = C_E;
phases = C_E;
num_full_blocks = size(full_blocks,1);

for idx=1:num_full_blocks
    i = full_blocks(idx,1);
    j = full_blocks(idx,2);
    if rad2deg(O1(i,j)) < 0
        filter_orient = rad2deg(O1(i,j)) + 180;
    else
        filter_orient = rad2deg(O1(i,j));
    end
    
    
    filter_lambda = 1/new_freq(i,j);
    if filter_lambda <2
        filter_lambda = 2;
    end
    block_to_filter = C_E{i, j};
    
    [mag, phase] =  imgaborfilt(block_to_filter, filter_lambda, filter_orient, ...
                    'SpatialAspectRatio', 4, 'SpatialFrequencyBandwidth', 1.34);
    magn{i,j}=mag;
    phases{i,j}=phase;
end

magn_img = cell2mat(magn);
phase_img = cell2mat(phases);
%%
%magn = cell2mat(magn);
figure(12)
%subplot(1,2,1)
imshow(phase_img)

figure(13)
%subplot(1,2,2)
imshow(uint8(magn_img))
% subplot(2,2,3)
% imshow(freq_image)
% subplot(2,2,4)
% imshow(freq_image_f)
%%

% Convert O to matrix
O_cell = mat2cell(image_out, rw, cw);
for i=1:M
    for j=1:N
        angle = O1(i, j);
        angles = angle * ones(w,w);
        O_cell{i,j}= angles;
    end
end
O_matrix = cell2mat(O_cell);
figure(15)
imshow(O_matrix)













