function [i_bif,j_bif] = findBifurcations(img)

bifurcations = bwmorph(img, 'branchpoints');
[i_bif,j_bif] = find(bifurcations);

%Check if bifurcations are real, 3 neighbours
for idx = 1:length(i_bif)
    i = i_bif(idx);
    j = j_bif(idx);
    
    %not close to the edge
    if i == 1 || i == size(img,1) || j == 1 || j == size(img,2)
        nsum = 0;
    else
        nsum = img(i-1,j) + img(i+1,j) + img(i,j+1) + img(i,j-1)+ img(i-1,j-1) + img(i+1,j+1) + img(i-1,j+1) + img(i+1,j-1);
    end
    if nsum > 3 || nsum == 0
        bifurcations(i,j) = 0;
    end
end

[i_bif,j_bif] = find(bifurcations);

end