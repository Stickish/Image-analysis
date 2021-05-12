%% Test
addpath('C:\Users\admin\Desktop\Skola\Image Analysis')
addpath('C:\Users\admin\Desktop\Skola\Image Analysis\TMS016_matlab\TMS016_funftions')
addpath('C:\Users\admin\Desktop\Skola\Image Analysis\\')

x = imread('test.png');
x = double(x)/255;

%dumb test code
x=x(3:322, 6:325);
size(x)

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
      norm = M_0 + sqrt(V_0*((x_t(i) - M_image)^2)/V);
      N_t(i) = norm;
   else
      N_t(i) = M_0 - sqrt(V_0*((x_t(i) - M_image)^2)/V);
   end
end
%%
figure(2)
imshow(reshape(N_t, m, []))
%% Orientation Image Estimation

% # 1. Divide image into blocks
% # 2. Compute gradients
% # 3. Estimate orientation based on gradients

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

for i=1:M
    for j=1:N
        if block_means(i, j) <= M_bkg && block_variances(i, j) <= V_bkg
            C{i, j} = zeros(w, w);
        end
    end
end
%%
image_out = cell2mat(C);
figure(3)
imshow(image_out);

%% Calculate gradient
% sobel
[Gx, Gy] = imgradientxy(image_out);
%Gx=Gx./8;
%Gy=Gy./8;

Gsx = 2*Gx.*Gy;
Gsy = Gx.^2 .* Gy.^2;

%% Split into blocks and compute for the blocks
% Init empty vectors for the means of Gsx and Gsy
Gmsx = zeros(M,N);
Gmsy = zeros(M,N);

% Split gradients into w x w cells
Cx = mat2cell(Gsx, rw, cw);
Cy = mat2cell(Gsy, rw, cw);

% Doesnt care if things are zero right now
for i=1:M
    for j=1:N
        block_x = reshape(Cx{i, j}, 1, []);
        block_y = reshape(Cy{i, j}, 1, []);
        vx = sum(block_x);
        vy = sum(block_y);
        Gmsx(i, j) = vx;
        Gmsy(i, j) = vy;
    end
end
%% Compute angles

theta = 0.5 * atan(Gmsy ./ Gmsx);
TF = isnan(theta);
theta(TF) = 0;
idx = find(theta==0);
%% Low pass filtering
[xx, yy] = ndgrid(1:w:m, 1:w:n);

[XX, YY] = meshgrid(1:w:m, 1:w:n);

phi_x = cos(2*theta);
phi_y = sin(2*theta);

figure(4)
imshow(image_out)
hold on
quiver(xx, yy, phi_x, phi_y)

%Gaussian filter with mask size 5 std dev 2
gauss_filter = fspecial('gaussian', 5, 2);

phi_xf = imfilter(phi_x, gauss_filter,'conv','replicate');
phi_yf = imfilter(phi_y, gauss_filter,'conv','replicate');

O = 0.5 * atan(phi_yf ./ phi_xf);

figure(5)
hold on
quiver(1:1:m, 1:1:n, Gx, Gy)
%%
figure(5)
imshow(image_out)
hold on
for i=1:M
    for j=1:N
        T = angles(i, j);
        x_s = round(w/2) + (i - 1)*w;
        y_s = round(w/2) + (j - 1)*w;
        len = 10;
        x_e = x_s + len*cos(T);
        y_e = y_s + len*sin(T);
        plot([x_s, x_e], [y_s, y_e])
    end
end


%% Rotate image - let's say it's good enough for now
C = mat2cell(image_out, rw, cw);

rot_block = C{20, 20};

P1 = [0 1; -1 0];
P2 = [0 -1; 1 0];
o = pi/2 - O(20, 20);

R = [cos(o) -sin(o); sin(o) cos(o)];
y = zeros(w,w);
v = [];
disp('start')
for i=1:w
    for j=1:w
        
        v = ceil(P2*R*P1*[i, j]');
        if v(1)<=0
            v(1)=1;
        end
        if v(2)<=0
            v(2)=1;
        end
        y(v(1), v(2)) = x(i, j);
    end
end

%% Testing the new gradient computation

t_C = mat2cell(image_out, rw, cw);
angles = zeros(M,N);

b_sigma = 2;
g_sigma = 5;
o_sigma = 7;

for i=1:M
    for j=1:N
        angles(i,j) = ridgeorient(t_C{i, j}, g_sigma, b_sigma, o_sigma);
    end
end
















