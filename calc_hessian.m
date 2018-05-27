function [ hessian ] = calc_hessian(gradient_times_jacobian)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
hessian=zeros(size(gradient_times_jacobian,2));

for ii=1:size(gradient_times_jacobian,1)
   hessian=hessian+gradient_times_jacobian(ii,:).'*gradient_times_jacobian(ii,:);
end

end

