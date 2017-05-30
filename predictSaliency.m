function saliency = predictSaliency(imgLoc)
%PREDICTSALIENCY Summary of this function goes here
%   Detailed explanation goes here
img = imread(imgLoc);

imgPath = strsplit(imgLoc,'/');
imgName = imgPath{end};

fprintf('Remapping 360 image to normal views...\n');
remap(img,imgName);

fprintf('Getting saliency from SAM model...\n');
mkdir('predictions_sam');
cmd = 'python sam/main.py test tmp/ predictions_sam/';
status = system(cmd);

if status ~= 0
    fprintf('There is something wrong with SAM. Please check and run again.\n');
    exit(-1);
end

fprintf('Getting saliency from SALGAN model...\n');
mkdir('predictions_salgan');
cmd = 'python 03-predict.py tmp predictions_salgan';
status = system(cmd);

if status ~= 0
    fprintf('There is something wrong with SALGAN. Please check and run again.\n');
    exit(-1);
end

mkdir('saliency_sam');
mkdir('saliency_salgan');
integrate('predictions_sam',imgName,'saliency_sam');
integrate('predictions_salgan',imgName,'saliency_salgan');

sal1 = mat2gray(imresize(imread(sprintf('saliency_sam/%s',imgName)),[128 256]));
sal2 = mat2gray(imresize(imread(sprintf('saliency_salgan/%s',imgName)),[128 256]));
sal3 = mat2gray(imresize(imread('behavior.jpg'),[128,256]));

fprintf('Combining saliency cues...\n');
load optParams.mat;
s = length(thetaOpt)/4;
alphaOpt = reshape(thetaOpt(1:s),128,256);
betaOpt = reshape(thetaOpt(s+1:2*s),128,256);
gammaOpt = reshape(thetaOpt(2*s+1:3*s),128,256);
lambdaOpt = reshape(thetaOpt(3*s+1:end),128,256);

saliency = alphaOpt.*sal1 + betaOpt.*sal2 + gammaOpt.*sal3 + lambdaOpt;
saliency = mat2gray(saliency);
imwrite(saliency,sprintf('sal_%s',imgName));
fprintf('Saliency image is saved to sal_%s\n',imgName);
fprintf('Cleaning garbages...\n');
rmdir 'saliency_salgan' s
rmdir 'saliency_sam' s
rmdir 'predictions_salgan' s
rmdir 'predictions_sam' s
rmdir 'tmp' s
fprintf('All done!!!\n');
end

