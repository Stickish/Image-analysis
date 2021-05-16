%% Load image

img = im2double(imread("Databaser/DB1_B/101_2.tif"));
[m, n] = size(img);

figure(1)
imshow(img)

%% Binarize image

bw_img = imbinarize(img, 'adaptive', 'ForegroundPolarity','dark');

figure(2)
imshow(imcomplement(bw_img))

%% Do some easy morphological functions
bw_img2 = imcomplement(bw_img);

bw_img2 = bwmorph(bw_img2, 'fill',5);
bw_img2 = bwmorph(bw_img2, 'hbreak',5);
bw_img2 = bwmorph(bw_img2, 'clean',5);
bw_img2 = bwmorph(bw_img2, 'fill',5);
bw_img2 = bwmorph(bw_img2, 'clean',5);
bw_img2 = bwmorph(bw_img2, 'hbreak',5);

figure(3)
imshow(imcomplement(bw_img2))

%% Thining/skeletonize

bw_img3 = bwmorph(bw_img2, 'skel');
bw_img3 = bwmorph(bw_img3, 'clean',10);
bw_img3 = bwmorph(bw_img3, 'diag',10);
bw_img3 = bwmorph(bw_img3, 'spur',10);
bw_img3 = bwmorph(bw_img3, 'skel');
bw_img3 = bwmorph(bw_img3, 'spur');
bw_img3 = bwmorph(bw_img3, 'diag',10);
bw_img3 = bwmorph(bw_img3, 'thin',10);

figure(4)
imshow(imcomplement(bw_img3))

%% Find minutias

[i_bif, j_bif] = findBifurcations(bw_img3);
[i_end, j_end] = findEndpoints(bw_img3);

figure(5)
clf
imshow(imcomplement(bw_img3))
hold on
plot(j_bif,i_bif,'b o')

figure(6)
clf
imshow(imcomplement(bw_img3))
hold on
plot(j_end,i_end,'r o')

%% Match features

end_features = getFeatures(bw_img, [i_end,j_end]);
matches = matchFeatures(end_features, end_features);

match_idx1 = matches(:,1);
match_idx2 = matches(:,2);

matches1 = [i_end(match_idx1,:),j_end(match_idx1,:)];
matches2 = [i_end(match_idx2,:),j_end(match_idx2,:)];

figure(7)
clf
imshow(bw_img)
hold on
scatter(matches1(:,2),matches1(:,1))

figure(8)
clf
imshow(bw_img)
hold on
scatter(matches2(:,2),matches2(:,1))

%%

img2 = im2double(imread("Databaser/DB1_B/109_8.tif"));
img3 = im2double(imread("Databaser/DB1_B/103_3.tif"));

fft_img2 = fft(img2);
fft_img = fft(img);
fft_img3 = fft(img3);

figure(9)
clf
imshow(fft_img)

figure(10)
clf
imshow(fft_img2)

figure(11)
clf
imshow(fft_img3)


