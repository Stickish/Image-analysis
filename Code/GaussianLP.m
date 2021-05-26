function theta_prim = GaussianLP(theta)

phix = cos(2*theta);
phiy = sin(2*theta);

gaussian_filter = fspecial('gaussian', 5, 2);
phix_prim = filter2(gaussian_filter, phix);
phiy_prim = filter2(gaussian_filter, phiy);

theta_prim = 1/2*atan2(phiy_prim, phix_prim);

end