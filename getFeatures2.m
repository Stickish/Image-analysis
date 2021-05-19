function features = getFeatures2(type,idxs,orientationField)
%Features = type, location, direction


features = zeros(size(idxs,1),5);
for idx = 1:size(idxs,1)
    i = idxs(idx,1);
    j = idxs(idx,2);
    theta = orientationField(i,j);
    
    %impose boundary conditions???
        
    if strcmp(type,'endpoint') 
        features(idx,1) = 0;
    elseif strcmp(type,'bifurcation') 
        features(idx,1) = 1;
    end
    
    features(idx,2) = i;
    features(idx,3) = j;
    
    features(idx,4) = cos(theta);
    features(idx,5) = sin(theta);

end

end