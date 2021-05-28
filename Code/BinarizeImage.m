function img_bin = BinarizeImage(img_pre, rw, cw, M, N)
% Binarize image

C = mat2cell(img_pre, rw,cw);

for i = 1:M
    for j = 1:N
        C{i,j} = imbinarize(C{i,j});
    end
end

img_bin = cell2mat(C);
img_bin = bwmorph(img_bin, 'fill');
end