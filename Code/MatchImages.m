function [validation_bif, validation_end] = MatchImages(img_1, img_bin_1, img_skel_1, img_2, img_bin_2, img_skel_2)

[total_bif, matches_bif] = MatchBifurcations(img_1, img_bin_1, img_skel_1, img_2, img_bin_2, img_skel_2);
[total_end, matches_end] = MatchEndpoints(img_1, img_bin_1, img_skel_1, img_2, img_bin_2, img_skel_2);
disp(total_bif)
disp(2*length(matches_bif))

validation_bif = 2*length(matches_bif)/total_bif;
validation_end = 2*length(matches_end)/total_end;
end