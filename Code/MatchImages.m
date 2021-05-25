function validation = MatchImages(img_1, img_bin_1, img_skel_1, img_2, img_bin_2, img_skel_2)

[total_bif, matches_bif] = MatchBifurcations(img_1, img_bin_1, img_skel_1, img_2, img_bin_2, img_skel_2);
[total_end, matches_end] = MatchEndpoints(img_1, img_bin_1, img_skel_1, img_2, img_bin_2, img_skel_2);

validation = 2*(length(matches_bif) + length(matches_end))/(total_bif + total_end);
end