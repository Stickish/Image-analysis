function [validation_bif, validation_end] = Verify(img_1, img_2, w, print)

% Preprocessing
[img_norm_1, img_bin_1, img_skel_1, empty_blocks_1] = PreprocessImage(img_1, w, print);
[img_norm_2, img_bin_2, img_skel_2, empty_blocks_2] = PreprocessImage(img_2, w, print);

[validation_bif, validation_end] = MatchImages(img_1, img_norm_1, img_bin_1, img_skel_1, empty_blocks_1,...
                                               img_2, img_norm_2, img_bin_2, img_skel_2, empty_blocks_2, w, print);
end