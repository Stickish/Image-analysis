function [total_bif, matches] = MatchBifurcations(img_1, img_bin_1, img_skel_1, img_2, img_bin_2, img_skel_2)
[i_1, j_1] = FindBifurcations(img_1, img_skel_1);
[i_2, j_2] = FindBifurcations(img_2, img_skel_2);

features_1 = GetFeatures(img_bin_1, [i_1, j_1]);
features_2 = GetFeatures(img_bin_2, [i_2, j_2]);

total_bif = length(i_1) + length(i_2);
matches = matchFeatures(features_1, features_2, 'MaxRatio', 1);

match_idx1 = matches(:,1);
match_idx2 = matches(:,2);

matches_1 = [j_1(match_idx1,:),i_1(match_idx1,:)];
matches_2 = [j_2(match_idx2,:),i_2(match_idx2,:)];

fig_bifmatch = figure;
name_1 = char(img_1);
name_2 = char(img_2);
str = strcat('Data/DB1_B/Images/', name_1(12:end), ' ', name_2(12:end), '_bifmatch.png');
showMatchedFeatures(imcomplement(img_skel_1), imcomplement(img_skel_2), matches_1, matches_2, 'montage');
saveas(fig_bifmatch, str);

close all
end