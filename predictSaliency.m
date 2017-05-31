function saliency = predictSaliency(imgLoc,show,saveImg)
%PREDICTSALIENCY Summary of this function goes here
%   Detailed explanation goes here
if nargin == 1
    show = 0;
    saveImg = 0;
elseif nargin == 2
    saveImg = 0;
elseif nargin > 3 || nargin < 1
    error('Unexpected number of input arguments!');
end

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

numFaces = 180;
[x,y,z] = sphere(numFaces);
coordinates = [x(:),y(:),z(:)];
[~,IA,IC] = unique(coordinates,'rows');

sal1 = imresize(mat2gray(imread(sprintf('saliency_sam/%s',imgName))),size(x));
sal2 = imresize(mat2gray(imread(sprintf('saliency_salgan/%s',imgName))),size(x));
sal3 = imresize(mat2gray(imread('behavior1.jpg')),size(x));
sal1 = flipud(sal1);
sal2 = flipud(sal2);
sal3 = flipud(sal3);
sal1 = sal1(:);
sal2 = sal2(:);
sal3 = sal3(:);
sal1 = sal1(IA,:);
sal2 = sal2(IA,:);
sal3 = sal3(IA,:);

fprintf('Combining saliency cues...\n');
load optParams.mat;
s = length(thetaOpt)/4;
alphaOpt = thetaOpt(1:s);
betaOpt = thetaOpt(s+1:2*s);
gammaOpt = thetaOpt(2*s+1:3*s);
lambdaOpt = thetaOpt(3*s+1:end);

saliency = alphaOpt.*sal1 + betaOpt.*sal2 + gammaOpt.*sal3 + lambdaOpt;
saliency = saliency(IC,:);
saliency = reshape(saliency,size(x));
saliency = imresize(saliency,[128,256]);
saliency = mat2gray(flipud(saliency));
if show
    figure; imshow(saliency);
end
if saveImg
    imwrite(saliency,sprintf('sal_%s',imgName));
    fprintf('Saliency image is saved to sal_%s\n',imgName);
end

fprintf('Collecting garbages...\n');
rmdir 'saliency_salgan' s
rmdir 'saliency_sam' s
rmdir 'predictions_salgan' s
rmdir 'predictions_sam' s
rmdir 'tmp' s
fprintf('All done!!!\n');
end

