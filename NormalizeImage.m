function img_norm = NormalizeImage(img)
img = img*255;
[m, n] = size(img);
img_norm = zeros(m,n);
img_mean = mean(img(:));
img_var = var(img(:));

disp(img_var);
mean0 = 150;
var0 = 50;

for i = 1:m
    for j = 1:n
        if img(i,j) >= img_mean
            img_norm(i,j) = mean0 + sqrt(var0*(img(i,j)-img_mean).^2/img_var);
        else
            img_norm(i,j) = mean0 - sqrt(var0*(img(i,j)-img_mean)^2/img_var);
        end
    end
end

img_norm = img_norm/255;

end