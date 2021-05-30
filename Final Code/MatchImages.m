function [validation_bif, validation_end] = MatchImages(img_1, img_norm_1, img_bin_1, img_skel_1, empty_blocks_1,...
                                                        img_2, img_norm_2, img_bin_2, img_skel_2, empty_blocks_2, w, print)

[total_bif, matches_bif] = MatchBifurcations(img_1, img_norm_1, img_bin_1, img_skel_1, empty_blocks_1,...
                                             img_2, img_norm_2, img_bin_2, img_skel_2, empty_blocks_2, w, print);
[total_end, matches_end] = MatchEndpoints(img_1, img_norm_1, img_bin_1, img_skel_1, empty_blocks_1,...
                                          img_2, img_norm_2, img_bin_2, img_skel_2, empty_blocks_2, w, print);

validation_bif = 2*size(matches_bif,1)/total_bif;
validation_end = 2*size(matches_end,1)/total_end;
end