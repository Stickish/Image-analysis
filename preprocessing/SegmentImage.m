function [segmented_image, M, N, rw, cw, full_blocks, empty_blocks] = SegmentImage(image, w)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% INPUT:
%   image := normalized image to be segmented
%   w := block size
%% OUTPUT:
%   segmented_image := image where background = 0
%   M := number of blocks along rows of image
%   N := number of blocks along index of image
%   rw := used to convert matrices to cells, rows
%   cw := used to convert matrices to cells, columns
%   full_blocks := blocks indices for where we have relevant information
%   empty_blocks := block indices for blocks that we can ignore
%% Image segmentation
% get size
[m, n] = size(image);

% Dividing into blocks
M = floor(m/w); % number of blocks along rows
N = floor(n/w); % number of blocks along columns

% Vectors of size for cells
rw = w*ones(1, M);
cw = w*ones(1, N);

C = mat2cell(reshape(image, m, []), rw, cw);  % Divides the image into 20x20 blocks, 24*32 of them for db 1

% init vectors
block_means = zeros(M, N);
block_variances = zeros(M, N);

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

% Convert cell to matrix
segmented_image = cell2mat(C);

%% Plot
% plot inverted image, i.e black = ridge
imshow(uint8(255-segmented_image));


end

