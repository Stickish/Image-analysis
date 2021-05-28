function features = GetFeatures(img, idxs, w)

features = zeros(size(idxs,1), round(w*w));

s = round(w/2);

for idx = 1:size(idxs,1)
    i = idxs(idx,1);
    j = idxs(idx,2);
     
    feature = img(i-s+1:i+s,j-s+1:j+s);
    
  features(idx,:) = reshape(feature, [1 round(w*w)]);
end

end