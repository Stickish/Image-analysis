function filtered_freq = SmoothFrequencies(block_freqs, k_sigma, f_size, full_blocks)
% SmoothFrequencies Smooth frequencies so that no block inside the
% relevant zone has f=0

% Input arguments
% ----------------------------------------------------------
%   block_freqs := block frequencies
%   k_sigma     := sigma for the gaussian kernel
%   f_size      := filter size
%   full_blocks := indices for where the relevant blocks are
%   freq_image  := matrix for frequencies
% ----------------------------------------------------------
filtered_freq = zeros(size(block_freqs));
[rows, cols] = size(block_freqs);
U = round(f_size/2);


[block_freqs_p, full_blocks_p, d_top] = PadImage(block_freqs, full_blocks, U);

num_full_blocks = size(full_blocks_p,1);
for idx=1:num_full_blocks
    i = full_blocks_p(idx,1);
    j = full_blocks_p(idx,2);
    
    if block_freqs_p(i, j) > eps
        filtered_freq(i-d_top, j) = block_freqs_p(i, j);
    end
    if j > U+1 && j <= cols-U
        num = 0;
        den = 0;
        for u=-U+1:U
            for v=-U+1:U
                num = num + gauss_kernel(u, v, k_sigma)*block_freqs_p(i-u, j-v);
                den = den + gauss_kernel(u, v, k_sigma)*mu(block_freqs_p(i-u, j-v));
            end
        end
        filtered_freq(i - d_top, j) = num/den;
    end
end
end

function output = mu(f)
if f > 0
    output = 1;
else
    output = 0;
end
end

function [new_img, full_blocks_p, d_top] = PadImage(f_image, full_blocks, U)
% Pad image with zeros enough so that we can use all info in the image
% find min i, max i, min j, max j and then add U zeros

% -----------------------------------------------------
% Currently only pads top and bottom, can fix but most pictures look ok
% -----------------------------------------------------
[M, N] = size(f_image);
i_max = max(full_blocks(:, 1));
j_max = max(full_blocks(:, 2));
i_min = min(full_blocks(:, 1));
j_min = min(full_blocks(:, 2));
new_img = f_image;
d_top = 0;
full_blocks_p = full_blocks;
% i > U+1 && i <= M-U && j > U+1 && j <= N-U

% % Add zeros to the top
% if i_min < U
%     disp('i_min < U')
%     d_top = U;
%     e_top = zeros(d_top, N);
%     p_image = [e_top; f_image];
%     full_blocks_p(:, 1) = full_blocks(:, 1) + d_top;
%     
%     if i_max > M - U
%         disp('i_max > M-U')
%         d = U;
%         e = zeros(d, N);
%         p_image = [p_image; e];
%         full_blocks_p(:, 1) = full_blocks(:, 1);
%     end
% end
% 
% % Add zeros to the bottom
% if i_min >= U
%     disp('i_max >= U')
%     full_blocks_p(:, 1) = full_blocks(:, 1);
%     
%     if i_max > M - U
%         disp('i_max > M-U')
%         d = U;
%         e = zeros(d, N);
%         p_image = [p_image; e];
%         full_blocks_p(:, 1) = full_blocks(:, 1);
%     end
% end

%
% if (i_max > M - U) && (i_min >= U)
%     disp('(i_max > M - U) && (i_min >= U)')
%     % Add zeros to the bottom
%     d = U;
%     e = zeros(d, N);
%     p_image = [f_image; e];
%     full_blocks_p(:, 1) = full_blocks(:, 1) + 1;
% end


d_top = U;
e_top = zeros(d_top, N);
p_image = [e_top; f_image];
full_blocks_p(:, 1) = full_blocks(:, 1) + d_top;

% Add zeros to the bottom

d = U;
e = zeros(d, N);
p_image = [p_image; e];

new_img = p_image;

end

function output = gauss_kernel(x, y, sigma)
% -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-
output = (1/(2*pi*sigma^2))*exp(-(x^2 - y^2)/(2*sigma^2));

end


