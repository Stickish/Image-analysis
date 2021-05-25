function [norm_image] = NormalizeFingerprint(image, M0, V0)
%% NormalizeFingerprint: Normalizes the fingerprint to reduce variation in the
%%   INPUT
%----------------------
%   image := an double in range 0-255
%   M0 := desired mean
%   V0 := desired variance
%----------------------
%% OUTPUT
%   norm_image := normalized version of input image
%% Normalizing image
[m, n] = size(image);

% Flatten image
x_t = reshape(image, 1, []);

% Average
scale = 1/(n*m);
M_image = sum(x_t)*scale;

% Variance
V_image = scale*(sum((x_t - M_image).^2));

% Flat normalized image
N_t = zeros(size(x_t));

for i=1:n*m
   if x_t(i) < M_image 
      norm = M0 - sqrt(V0*((x_t(i) - M_image)^2)/V_image);
      N_t(i) = norm;
   else
      N_t(i) = M0 + sqrt(V0*((x_t(i) - M_image)^2)/V_image);
   end
end

% Unflattening the normalized image
norm_image = reshape(N_t, m, []);
end

