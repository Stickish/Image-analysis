function img_seg = segmentImage(img_norm)
%Takes in a normalized image


[m, n] = size(img_norm, block_size);
% Dividing into blocks
w = block_size;
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

end