clear; clc; close all;

label = csvread('scene_groundtruth.csv');
gtList = dir('training1/360_gt/*.jpg');
gtAll = zeros(128,256,30);
idx = 1;
for i = 1:length(gtList)
%     if label(label(:,1)==str2double(gtList(i).name(4:5)),2) == 1
%         continue;
%     end
    img = rgb2gray(imread(sprintf('training1/360_gt/%s',gtList(i).name)));
    img = imresize(img,[128,256]);
    gtAll(:,:,idx) = img;
    idx = idx + 1;
end
gtAll = mean(mat2gray(double(gtAll)),3);
imwrite(gtAll,'01_1.jpg');
% fun = @(x) makeBehaviorHist(x.data);
% behavior = mat2gray(blockproc(gtAll,[32,32],fun));