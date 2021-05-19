%% Load image

img = im2double(imread("Databaser/DB1_B/101_2.tif"));
img2 = im2double(imread("Databaser/DB1_B/101_3.tif"));

[m, n] = size(img);

figure(1)
imshowpair(img,img2, 'montage')

%% Binarize image

bw_img = imbinarize(img, 'adaptive', 'ForegroundPolarity','dark');
bw_img2 = imbinarize(img2, 'adaptive', 'ForegroundPolarity','dark');

figure(2)
imshowpair(bw_img, bw_img2,'montage')

%% Do some easy morphological functions
bw_img12 = imcomplement(bw_img);
bw_img12 = bwmorph(bw_img12, 'fill',5);
bw_img12 = bwmorph(bw_img12, 'hbreak',5);
bw_img12 = bwmorph(bw_img12, 'clean',5);
bw_img12 = bwmorph(bw_img12, 'fill',5);
bw_img12 = bwmorph(bw_img12, 'clean',5);
bw_img12 = bwmorph(bw_img12, 'hbreak',5);

bw_img22 = imcomplement(bw_img2);
bw_img22 = bwmorph(bw_img22, 'fill',5);
bw_img22 = bwmorph(bw_img22, 'hbreak',5);
bw_img22 = bwmorph(bw_img22, 'clean',5);
bw_img22 = bwmorph(bw_img22, 'fill',5);
bw_img22 = bwmorph(bw_img22, 'clean',5);
bw_img22 = bwmorph(bw_img22, 'hbreak',5);

figure(3)
imshowpair(imcomplement(bw_img12), imcomplement(bw_img22),'montage')

%% Thining/skeletonize

bw_img13 = bwmorph(bw_img12, 'skel');
bw_img13 = bwmorph(bw_img13, 'clean',10);
bw_img13 = bwmorph(bw_img13, 'diag',10);
bw_img13 = bwmorph(bw_img13, 'spur',10);
bw_img13 = bwmorph(bw_img13, 'skel');
bw_img13 = bwmorph(bw_img13, 'spur');
bw_img13 = bwmorph(bw_img13, 'diag',10);
bw_img13 = bwmorph(bw_img13, 'thin',10);

bw_img23 = bwmorph(bw_img22, 'skel');
bw_img23 = bwmorph(bw_img23, 'clean',10);
bw_img23 = bwmorph(bw_img23, 'diag',10);
bw_img23 = bwmorph(bw_img23, 'spur',10);
bw_img23 = bwmorph(bw_img23, 'skel');
bw_img23 = bwmorph(bw_img23, 'spur');
bw_img23 = bwmorph(bw_img23, 'diag',10);
bw_img23 = bwmorph(bw_img23, 'thin',10);

figure(4)
imshowpair(imcomplement(bw_img13), imcomplement(bw_img23),'montage')
%% Find minutias

[i_bif1, j_bif1] = findBifurcations(bw_img13);
[i_end1, j_end1] = findEndpoints(bw_img13);

[i_bif2, j_bif2] = findBifurcations(bw_img23);
[i_end2, j_end2] = findEndpoints(bw_img23);

figure(5)
clf
imshow(imcomplement(bw_img13))
hold on
plot(j_bif1,i_bif1,'b o')

figure(6)
clf
imshow(imcomplement(bw_img23))
hold on
plot(j_end2,i_end2,'r o')

%% Match features

end_features1 = getFeatures(bw_img, [j_end1,i_end1]);
end_features2 = getFeatures(bw_img2, [j_end2,i_end2]);
[matches,valid_points] = matchFeatures(end_features1, end_features2);

match_idx1 = matches(:,1);
match_idx2 = matches(:,2);

matches1 = [j_end1(match_idx1,:),i_end1(match_idx1,:)];
matches2 = [j_end2(match_idx2,:),i_end2(match_idx2,:)];

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

figure(12)
showMatchedFeatures(img, img2,matches1,matches2,'montage');


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


