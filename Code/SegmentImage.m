function [img_seg, full_blocks, empty_blocks] = SegmentImage(img_norm, w, M, N, rw, cw)
%Takes in a normalized image

% Dividing into blocks

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

% Blocks with smaller mean and smaller variance is the background.
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

img_seg = cell2mat(C);

end