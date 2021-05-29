function [magn_image, phase_image] = FilterImage(image, new_freq, O1, rw, cw, full_blocks)
%FilterImage Use Gabor filters to reduce noise along the transition between
%ridges and valleys
%% INPUT:
%   image := segmented image
%   new_freq := the interpolated and filtered block frequencies
%   O1 := Filtered block orientations
%   rw := vector containing block size along rows for mat2cell
%   cw := vector containing block size along columns for mat2cell
%   full_blocks := block indices for blocks that are relevant
%% OUTPUT:
%   magn_image := magnitude response of the gabor filtering
%   phase_image := phase response of the gabor filtering
%% Enhancing image with Gabor filter
% Allocating space for responses
C_E = mat2cell(image, rw, cw); % divide the image into blocks
magn = mat2cell(image, rw, cw); % output blocks
phases = mat2cell(image, rw, cw); % output blocks

% number of full blocks
num_full_blocks = size(full_blocks,1);

for idx=1:num_full_blocks
    i = full_blocks(idx,1); % might be a better way to do this
    j = full_blocks(idx,2);
    
    % Compute the orientation of filter(i, j)
    % Change from radians to angles
    if rad2deg(O1(i,j)) < 0
        filter_orient = rad2deg(O1(i,j)) + 180;
    else
        filter_orient = rad2deg(O1(i,j));
    end
    
    % Compute the wavelength of the filter from frequency image 
    
    if isnan(new_freq(i, j))
        new_freq(i, j) = 0.5;
    end
    
    if new_freq(i, j) ~= 0
        filter_lambda = 1/new_freq(i,j);
    else
        filter_lambda = rw(1);
    end
    % Might be unnecessary, but it has given errors before, might be fixed
    % now
    if filter_lambda <2
        filter_lambda = 2;
    end
    
    if isinf(filter_lambda) == 1
        disp('got to if statement')
       filter_lambda = 20; 
    end
    
    block_to_filter = C_E{i, j};
    
    % Filter
    % SpatialAspectRatio chosen to 4 from litterature
    % SpatialFrequency bandwidth chosen to 1.34 from testing
    [mag, phase] =  imgaborfilt(block_to_filter, filter_lambda, filter_orient, ...
                    'SpatialAspectRatio', 4, 'SpatialFrequencyBandwidth', 1.75);
    magn{i,j}=mag;
    phases{i,j}=phase;
end

magn_image = cell2mat(magn);
phase_image = cell2mat(phases);

end

