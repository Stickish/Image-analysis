function [total_end, matches] = MatchEndpoints(img_1, img_norm_1, img_bin_1, img_skel_1, empty_blocks_1,...
    img_2, img_norm_2, img_bin_2, img_skel_2, empty_blocks_2, w, print)

[i_1, j_1] = FindEndpoints(img_1, img_skel_1, empty_blocks_1, w, print);
[i_2, j_2] = FindEndpoints(img_2, img_skel_2, empty_blocks_2, w, print);

features_1 = GetFeatures(img_norm_1, [i_1, j_1], w);
features_2 = GetFeatures(img_norm_2, [i_2, j_2], w);

total_end = length(i_1) + length(i_2);
matches = matchFeatures(features_1, features_2, 'MaxRatio', 1, 'Unique', true);

match_idx1 = matches(:,1);
match_idx2 = matches(:,2);

matches_1 = [j_1(match_idx1,:),i_1(match_idx1,:)];
matches_2 = [j_2(match_idx2,:),i_2(match_idx2,:)];

if print
    fig_endmatch = figure('visible', 'off');
    name_1 = char(img_1);
    name_2 = char(img_2);
    img_1 = char(img_1);
    db = img_1(1:10);
    loc = strcat(db, '/Images/');
    str = strcat(loc, name_1(12:end), ' ', name_2(12:end), '_endmatch.png');
    showMatchedFeatures(img_norm_1, img_norm_2, matches_1, matches_2, 'montage');
    saveas(fig_endmatch, str);
end

close all
end