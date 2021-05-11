function features = getFeatures(img, idxs)

features = zeros(size(idxs,1),25);



for idx = 1:size(idxs,1)
    i = idxs(idx,1);
    j = idxs(idx,2);
    
    %impose boundary conditions
        
        
    feature = img(i-2:i+2,j-2:j+2);
    
  features(idx,:) = reshape(feature, [1 25]);
end

end