function [new_freq, freq_image, freq_image_f] = FrequencyImage(image, O1, w, rw, cw, M, N, full_blocks)
%UNTITLED6 Summary of this function goes here
%% INPUT:
%   image := segmented image
%   O1 := orientation image
%   w := block size
%   rw := vectors of row sizes for blocks
%   cw := vectors of col sizes for blocks
%   M := number of blocks along axis 0
%   N := number of blocks along axis 1
%   full_blocks := block indices for where relevant information is
%% OUTPUT:
%   new_freq := interpolated and filtered block frequencies
%   freq_image := the first frequency image computed
%   freq_image_f := the interpolated and filtered frequency image
%% START
% Size of the image
[m, n] = size(image);




% Max and min wavelength
minWaveLength = 5;
maxWaveLength = 25;

windsze = w/2;

freq_image = zeros(m,n);
C_f = mat2cell(freq_image, rw, cw);
C_image = mat2cell(image, rw, cw);
block_freq = zeros(M, N);

for i=1:M
    for j=1:N
        im = C_image{i, j};
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
freq_image = cell2mat(C_f);
%% Smoothen  and interpolate the frequencies

% Interpolating frequencies
new_freq = SmoothFrequencies(block_freq, 9, 7, full_blocks);
nfc = mat2cell(zeros(m, n), rw, cw);
for i=1:M
    for j=1:N
        nf = ones(w, w)*new_freq(i, j);
        nfc{i, j} = nf;
    end
end

% filtering the frequecny image using a gaussian filter
f = fspecial('gaussian', 7, 1); % size from litterature, sigma=1 looked ok

% convert from cell to matrix
nfm = cell2mat(nfc);
freq_image_f = filter2(f, nfm);  

end

