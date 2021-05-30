function [img_norm, img_bin, img_skel, empty_blocks, w] = PreprocessImage(img, w, print)
% LOAD AND PREPROCESS DATA
% Load original image
file = strcat(img, '.tif');
img = char(img);
db = img(1:10);

img_orig = double(imread(file));
img_orig = 255 - img_orig;

if print
    fig_orig = figure;
    imshow(uint8(img_orig));
    name = char(img);
    loc = strcat(db, '/Images/');
    str = strcat(loc, name(12:end), '_orig.png');
    saveas(fig_orig, str);
end

% Padding image
database = img(8);
img_padd = PaddingImage(img_orig, database);

[m, n] = size(img_padd);

if print
    fig_padd = figure;
    imshow(uint8(img_padd));
    name = char(img);
    loc = strcat(db, '/Images/');
    str = strcat(loc, name(12:end), '_padd.png');
    saveas(fig_padd, str);
end


% Normalize image
img_norm = NormalizeImage(img_padd);

if print
    fig_norm = figure;
    imshow(uint8(img_norm));
    str = strcat(loc, name(12:end), '_norm.png');
    saveas(fig_norm, str);
end

% Segment image

% Constants
M = floor(m/w);
N = floor(n/w);

rw = w*ones(1, M);
cw = w*ones(1, N);

[img_seg, full_blocks, empty_blocks] = SegmentImage(img_norm, w, M, N, rw, cw);

if print
    fig_seg = figure;
    imshow(uint8(img_seg));
    str = strcat(loc, name(12:end), '_seg.png');
    saveas(fig_seg, str);
end

%% Orientation field
theta = OrientationField(img_seg, m, n, w, M, N);

if print
    fig_orient = figure;
    PlotOrientation(img_seg,theta, w, M, N, rw, cw);
    str = strcat(loc, name(12:end), '_orient.png');
    saveas(fig_orient, str);
end

% Gaussian LP filter
theta_prim = GaussianLP(theta);

if print
    fig_gauss = figure;
    PlotOrientation(img_seg,theta_prim, w, M, N, rw, cw);
    str = strcat(loc, name(12:end), '_gauss.png');
    saveas(fig_gauss, str);
end

% Frequency estimation

[new_freq, img_freq, img_freq_f] = FrequencyImage(img_seg, theta_prim, w, rw, cw, M, N, full_blocks);

if print
    fig_freq = figure;
    imshow(img_freq)
    str = strcat(loc, name(12:end), '_freq.png');
    saveas(fig_freq, str);
    
    fig_freq_f = figure;
    imshow(img_freq_f)
    str = strcat(loc, name(12:end), '_freq_f.png');
    saveas(fig_freq_f, str);
end

% Gabor filtering
[img_magn, img_phase] = FilterImage(img_seg, new_freq, theta_prim, rw, cw, full_blocks);

if print
    fig_magn = figure;
    imshow(uint8(img_magn))
    str = strcat(loc, name(12:end), '_magn.png');
    saveas(fig_magn, str);
    
    fig_phase = figure;
    imshow(img_phase)
    str = strcat(loc, name(12:end), '_phase.png');
    saveas(fig_phase, str);
end

%img_magn = img_magn/255;
%img_magn(img_magn>1) = 1;



% Binarize image
img_bin = BinarizeImage(img_magn, rw, cw, M, N);

if print
    fig_bin = figure;
    imshow(img_bin);
    str = strcat(loc, name(12:end), '_bin.png');
    saveas(fig_bin, str);
end

% Skeletonize image
img_skel = SkeletonizeImage(img_bin);

if print
    fig_skel = figure;
    imshow(img_skel);
    str = strcat(loc, name(12:end), '_skel.png');
    saveas(fig_skel, str);
end

close all
end