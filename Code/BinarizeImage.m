function img_bin = BinarizeImage(img_pre)
% Binarize image
img_bin = imbinarize(img_pre, 'adaptive', 'ForegroundPolarity','dark');
img_bin = imcomplement(img_bin);
end