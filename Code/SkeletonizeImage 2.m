function img_skel = SkeletonizeImage(img_bin)
% Skeletonize image
img_skel = bwmorph(img_bin, 'thin',10);
end