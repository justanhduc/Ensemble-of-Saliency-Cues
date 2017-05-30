function remap(img,imgName)
%REMAP Summary of this function goes here
%   Detailed explanation goes here
mkdir('tmp');
imgNameExt = strsplit(imgName,'.');
for j = -130:10:130
    imgPatch = equi2face(img,j,0,0);
    imwrite(imgPatch,sprintf('tmp/%s_%d_%d.%s',imgNameExt{1},j,0,imgNameExt{2}));
end
imgPatch = equi2face(img,0,90,0);
imwrite(imgPatch,sprintf('tmp/%s_%d_90.%s',imgNameExt{1},0,imgNameExt{2}));
imgPatch = equi2face(img,0,-90,0);
imwrite(imgPatch,sprintf('tmp/%s_%d_-90.%s',imgNameExt{1},0,imgNameExt{2}));
end

