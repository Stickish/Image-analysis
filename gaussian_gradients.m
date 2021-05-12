function [grad_x,grad_y] = gaussian_gradients(img, std)
%comute gaussian gradients of image

finite_diff = [-0.5 0 0.5]; %finite differentiating filter
gauss_img = gaussian_filter(img,std); %Gaussian of image

grad_x = conv2(gauss_img,finite_diff, 'same'); %Gradient of gaussian of image, x-dir
grad_y = conv2(gauss_img,finite_diff', 'same'); %Gradient of gaussian of image, y-dir

end