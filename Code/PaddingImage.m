function [img_padd] = PaddingImage(img, database)

if str2double(database) == 2
    seg = find(img(1,:)~=0);
    img = img(:, seg(1):seg(end));
end

[m,n] = size(img);
meanColor = mean(img(:));

if mod(m, 20) == 0
else
    if mod(n, 20) == 0
    else
        nrExtraCols = 20-mod(n,20);
        zc = ones(m, nrExtraCols)*meanColor;
        img = [img zc];
        [m, n] = size(img);
    end
    nrExtraRows = 20-mod(m,20);
    zr = ones(nrExtraRows, n)*meanColor;
    img = [img; zr];
end

img_padd = img;
end