function [i_bif, j_bif] = FindBifurcations(name, img)

bifurcations = bwmorph(img, 'branchpoints');
[i_bif,j_bif] = find(bifurcations);

%Check if bifurcations are real, 3 neighbours
for idx = 1:length(i_bif)
    i = i_bif(idx);
    j = j_bif(idx);
    
    %not close to the edge
    if i == 1 || i == size(img,1) || j == 1 || j == size(img,2)
        nsum = 0;
    elseif i == 2 || i == size(img,1)-1 || j == 2 || j == size(img,2)-2
        nsum = 0;
    else
        nsum = img(i-1,j) + img(i+1,j) + img(i,j+1) + img(i,j-1)+ img(i-1,j-1) + img(i+1,j+1) + img(i-1,j+1) + img(i+1,j-1);
    end
    if nsum > 3 || nsum == 0
        bifurcations(i,j) = 0;
    end
end

[i_bif,j_bif] = find(bifurcations);

fig_bif = figure;
imshow(imcomplement(img))
hold on
plot(j_bif, i_bif, 'b o')
name = char(name);
loc = 'Data/DB1_B/Images/';
str = strcat(loc, name(12:end), '_bif.png');
saveas(fig_bif, str);

close all
end