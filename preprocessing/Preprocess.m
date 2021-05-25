%% Preprocessing main
clc, clf
clearvars, close ALL

image = imread('101_2.tif');
image = double(image);% /255;

% invert image
image = 255 - image;

[m, n] = size(image);
figure(1)

% invet back so that black = ridge
imshow(uint8(255-image))

%% Normalize fingerprint
M0 = 50; V0 = 150; % From litterature
norm_image = NormalizeFingerprint(image, M0, V0);

figure(2)
imshow(uint8(255 - norm_image))

%% Segment normalized image
w = 20; % Works well for DB1
[segmented_image, M, N, rw, cw, full_blocks, empty_blocks] = SegmentImage(norm_image, w);

figure(3)
% plot inverted image, i.e black = ridge
imshow(uint8(255-segmented_image));

%% Compute orientation image and plot it

O1 = OrientatioinImage(segmented_image, M, N, 4, w);

%% Compute frequency image

[new_freq, freq_image, freq_image_f] = FrequencyImage(segmented_image, O1, w, rw, cw, M, N, full_blocks);

figure(5)
imshow(freq_image)

figure(6)
imshow(freq_image_f)

%% Enhance image using gabor filters

[magn_image, phase_image] = FilterImage(segmented_image, new_freq, O1, rw, cw, full_blocks);

figure(7)
imshow(uint8(255 - magn_image))

figure(8)
imshow(phase_image)

