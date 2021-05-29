%% Fingerprint Verification
clc, clear
clf, close all

img_1 = "Data/DB1_B/101_3";
img_2 = "Data/DB1_B/101_3";

% Kolla storleken och räkna ut w
[validation_bif, validation_end] = Verify(img_1, img_2);