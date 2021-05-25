%% Adding the path
%addpath('C:\Users\Sara\Documents\Skola\TMS016\TMS016_Matlab')
tms016path

%% load images

clf
img_titan = imread('titan.jpg');
[m_t,n_t,d_t] = size(img_titan); 
img_titan = double(img_titan)/255; %covert to double [0 1]

img_rosetta = imread('rosetta.jpg');
[m_r,n_r,d_r] = size(img_rosetta); 
img_rosetta = double(img_rosetta)/255; %covert to double [0 1]
img_rosetta = rgb2gray(img_rosetta); %convert to grayscale

figure(1)
imshow(img_titan)
colormap gray

figure(2)
imshow(img_rosetta)
colormap gray

%% remove pixels with prob pc

% img = img_titan;
% m = m_t;
% n = n_t;

img = img_rosetta;
m = m_r;
n = n_r;

p_c = 0.9;

img = img(:);
N = round(length(img) - p_c*length(img)); %Number of observed pixels

ind = randperm(m*n); %random indexing
ind_obs = ind(1:N); %observe first N pixels
ind_mis = ind(N+1:end);
y_obs = img(ind_obs); %observed pixels
y_mis = img(ind_mis); %missing pixels

%% Create locations
xx = linspace(0,1,n);
yy = linspace(0,1,m);
[XX,YY] = meshgrid(xx,yy);

% All locations
loc = [XX(:), YY(:)];
loc_obs = loc(ind_obs,:); % Obseved locations

%Unse only first 10000 observations
if N <= 10000
    loc_est = loc_obs;
else
    loc_est = loc_obs(1:10000,:);
end

%% Variogram
variogram_1 = emp_variogram(loc_est,y_obs,50); %binned variogram

%least squares estimate of covariance params
fixed = struct('nu',1);
theta_ls = cov_ls_est(y_obs,'matern',variogram_1,fixed);

%matern variogram
variogram_2 = matern_variogram(pdist(loc_est),theta_ls.sigma,theta_ls.kappa,theta_ls.nu,theta_ls.sigma_e);


figure(3) %plot in same figure
clf
scatter(variogram_1.h,variogram_1.variogram)
hold on
scatter(pdist(loc_est),variogram_2,'r')
hold off

%% Create percision matrix
kappa = 1; %theta_ls.kappa;
tau = 2*pi/(theta_ls.sigma)^2;

q = kappa^4*[0 0 0 0 0;
             0 0 0 0 0;
             0 0 1 0 0;
             0 0 0 0 0;
             0 0 0 0 0] + 2*kappa^2*[0 0 0 0 0;
                                     0 0 -1 0 0;
                                     0 -1 4 -1 0;
                                     0 0 -1 0 0;
                                     0 0 0 0 0] + [0 0 1 0 0;
                                                   0 2 -8 2 0;
                                                   1 -8 20 -8 1;
                                                   0 2 -8 2 0;
                                                   0 0 1 0 0];

Q = stencil2prec([m,n],q);
Q = Q*tau;

Q_op = Q(ind_obs,ind_mis);
Q_po = Q(ind_mis,ind_obs);
Q_o = Q(ind_obs,ind_obs);
Q_p = Q(ind_mis,ind_mis);

%% Tricky trick for faster computation
reo = amd(Q_p);
R_p = chol(Q_p(reo, reo));

%% Reconstruction

% mu_mis = mu_obs (modellantagande)
B_o = ones(N,1);
mu_obs = (B_o'*Q_o*B_o)\(B_o'*Q_o*y_obs); %mean(y_obs);
mu_mis = mu_obs;

%compute posterior mean
v = (Q_po*(y_obs-mu_obs));
%temp1 = R_p'\v(reo); 
post_mean = mu_mis - Q_p\v; %R_p\temp1;

%% Patch together image from observed values and reconstructed values
y_p = zeros(m*n,1);
y_p(ind_obs) = y_obs;
y_p(ind_mis) = post_mean;

figure(4)
clf
imshow(reshape(y_p, [m n]))
axis off
colormap gray

%% Plot only the "observed" pixels
y_orig = zeros(m*n,1);
y_orig(ind_obs) = y_obs;

figure(5)
clf
imshow(reshape(y_orig, [m n]))
axis off
colormap gray

%% Residuals


