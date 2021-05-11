function [i_end,j_end] = findEndpoints(img)

endpoints = bwmorph(img, 'endpoints');
[i_end,j_end] = find(endpoints);

for idx = 1:length(i_end)
    i = i_end(idx);
    j = j_end(idx);
    
    %not close to the edge
    if i == 1 || i == size(img,1) || j == 1 || j == size(img,2)
        nsum = 0;
    else
        nsum = img(i-1,j) + img(i+1,j) + img(i,j+1) + img(i,j-1)+ img(i-1,j-1) + img(i+1,j+1) + img(i-1,j+1) + img(i+1,j-1);
    end
    if nsum > 3 || nsum == 0
        endpoints(i,j) = 0;
    end
end

[i_end,j_end] = find(endpoints);

end