function [validation_bif, validation_end] = Verify(img_1, img_2)

% Preprocessing
[img_bin_1, img_skel_1, empty_blocks_1, w] = PreprocessImage(img_1);
[img_bin_2, img_skel_2, empty_blocks_2, w] = PreprocessImage(img_2);

[validation_bif, validation_end] = MatchImages(img_1, img_bin_1, img_skel_1, empty_blocks_1,...
                                               img_2, img_bin_2, img_skel_2, empty_blocks_2, w);
end