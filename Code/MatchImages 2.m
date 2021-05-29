function [validation_bif, validation_end] = MatchImages(img_1, img_bin_1, img_skel_1, empty_blocks_1,...
                                                        img_2, img_bin_2, img_skel_2, empty_blocks_2, w)

[total_bif, matches_bif] = MatchBifurcations(img_1, img_bin_1, img_skel_1, img_2, img_bin_2, img_skel_2);
[total_end, matches_end] = MatchEndpoints(img_1, img_bin_1, img_skel_1, empty_blocks_1,...
                                          img_2, img_bin_2, img_skel_2, empty_blocks_2, w);

validation_bif = 2*length(matches_bif)/total_bif;
validation_end = 2*length(matches_end)/total_end;
end