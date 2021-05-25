function [img_bin, img_skel, empty_blocks] = PreprocessImage(img)
% LOAD AND PREPROCESS DATA
% Load original image
file = strcat(img, '.tif');
img_orig = im2double(imread(file));

fig_orig = figure;
imshow(img_orig);
name = char(img);
loc = 'Data/DB1_B/Images/';
str = strcat(loc, name(12:end), '_orig.png');
saveas(fig_orig, str);

% Normalize image
img_norm = NormalizeImage(img_orig);

fig_norm = figure;
imshow(img_norm);
str = strcat(loc, name(12:end), '_norm.png');
saveas(fig_norm, str);

% Segment image
w = 10;
[img_seg, full_blocks, empty_blocks] = SegmentImage(img_norm, w);

fig_seg = figure;
imshow(img_seg);
str = strcat(loc, name(12:end), '_seg.png');
saveas(fig_seg, str);

% Orientation field
theta = OrientationField(img_seg, w);

fig_orient = figure;
PlotOrientation(img_seg, theta, w);
str = strcat(loc, name(12:end), '_orient.png');
saveas(fig_orient, str);


% Gaussian LP filter
theta_prim = GaussianLP(theta);

fig_gauss = figure;
PlotOrientation(img_seg, theta_prim, w);
str = strcat(loc, name(12:end), '_gauss.png');
saveas(fig_gauss, str);


% Binarize image
img_bin = BinarizeImage(img_norm);

fig_bin = figure;
imshow(imcomplement(img_bin));
str = strcat(loc, name(12:end), '_bin.png');
saveas(fig_bin, str);


% Skeletonize image
img_skel = SkeletonizeImage(img_bin);

fig_skel = figure;
imshow(imcomplement(img_skel));
str = strcat(loc, name(12:end), '_skel.png');
saveas(fig_skel, str);

close all
end