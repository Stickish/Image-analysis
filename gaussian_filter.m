function res = gaussian_filter(image, std)
%Compute gaussian filter
gauss_filt = fspecial('gaussian', round(5*std),std);
%Apply filter to image
res = imfilter(image, gauss_filt, 'symmetric');

end