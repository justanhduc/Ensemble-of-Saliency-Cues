function [ output_args ] = integrate(inFolder,imageName,outFolder)
%INTEGRATE Summary of this function goes here
%   Detailed explanation goes here
imgNameExt = strsplit(imageName,'.');
saliencyList = dir(sprintf('%s/%s*',inFolder,imgNameExt{1}));
saliency = zeros(1080,2160);
for j = 1:length(saliencyList)
    metadata = strsplit(saliencyList(j).name,'_');
    x = str2double(metadata{2});
    y = str2double(metadata{3}(1:end-4));
    img = double(imread(sprintf('%s/%s',inFolder,saliencyList(j).name)))/255.;
    img = imresize(img, [1080,1080]);
    [out,~] = face2equi(img,x,y,0);
    saliency = saliency + out;
end
saliency = mat2gray(saliency);
f = getGaussianFilter(101,10);
saliency = conv2(saliency,f,'same');
imwrite(mat2gray(saliency),sprintf('%s/%s',outFolder,imageName));
end

