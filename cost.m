function [cost,grad] = cost(theta,data,eta)
%COST Summary of this function goes here
%   Detailed explanation goes here

s = length(theta)/4;
alpha = repmat(theta(1:s),1,size(data{1},2));
beta = repmat(theta(s+1:2*s),1,size(data{1},2));
gamma = repmat(theta(2*s+1:3*s),1,size(data{1},2));
lambda = repmat(theta(3*s+1:4*s),1,size(data{1},2));
% sigma = repmat(theta(4*s+1:end),1,size(data{1},2));

S = data{1};
G = data{2};
B = repmat(data{3},1,size(data{1},2));
DS = data{4};
DG = data{5};
D = data{6};
DD = data{7};
% G2 = data{8};
% DG2 = data{9};

cost = 1/(2*size(data{1},1))*(sum(sum((alpha.*S + beta.*G + gamma.*B + lambda - D).^2)) ...
    + eta*sum(sum((alpha.*DS + beta.*DG - DD).^2)));
alphaGrad = 1/(2*size(data{1},1))*(sum(2*(alpha.*S + beta.*G + gamma.*B + lambda - D).*S,2) + ...
    eta*sum(2*(alpha.*DS + beta.*DG - DD).*DS,2));
betaGrad = 1/(2*size(data{1},1))*(sum(2*(alpha.*S + beta.*G + gamma.*B + lambda - D).*G,2) + ...
    eta*sum(2*(alpha.*DS + beta.*DG - DD).*DG,2));
% sigmaGrad = 1/(2*size(data{1},1))*(sum(2*(alpha.*S + beta.*G + gamma.*B + lambda - D).*G2,2) + ...
%     eta*sum(2*(alpha.*DS + beta.*DG - DD).*DG2,2));
gammaGrad = 1/(2*size(data{1},1))*(sum(2*(alpha.*S + beta.*G + gamma.*B + lambda - D).*B,2));
lambdaGrad = 1/(2*size(data{1},1))*(sum(2*(alpha.*S + beta.*G + gamma.*B + lambda - D),2));
grad = [alphaGrad;betaGrad;gammaGrad;lambdaGrad];
end

