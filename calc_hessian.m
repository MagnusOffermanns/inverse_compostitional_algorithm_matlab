function [ hessian ] = calc_hessian(gradient_times_jacobian)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
hessian=zeros(size(gradient_times_jacobian,2));

for ii=1:size(gradient_times_jacobian,1)
   hessian=hessian+gradient_times_jacobian(ii,:).'*gradient_times_jacobian(ii,:);
end


%hessian=transpose(gradient_times_jacobian)*gradient_times_jacobian;
% lengthwidth_ratio=size(gradient_times_jacobian,2)/size(gradient_times_jacobian,1);
% hessian=zeros(size(gradient_times_jacobian,1));
% for ii=0:lengthwidth_ratio-1
%    hessian=hessian+(gradient_times_jacobian(:,ii*size(gradient_times_jacobian,1)+1:(ii+1)*size(gradient_times_jacobian,1)).'*gradient_times_jacobian(:,ii*size(gradient_times_jacobian,1)+1:(ii+1)*size(gradient_times_jacobian,1)));
% imshow(hessian)
% end


end

%MikadoUno