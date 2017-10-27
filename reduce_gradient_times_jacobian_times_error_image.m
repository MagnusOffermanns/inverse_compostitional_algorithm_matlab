function [ reduced ] = reduce_gradient_times_jacobian_times_error_image( hessian,size_errorimage )
%UNTITLED14 Summary of this function goes here
%   Detailed explanation goes here
height=size(hessian,1)/size_errorimage;
width=size(hessian,2)/size_errorimage;
reduced=zeros(size(hessian,1)/size_errorimage,size(hessian,2)/size_errorimage);

for jj=0:height-1
   for ii=0:width-1
    reduced(jj+1,ii+1)=sum(sum(hessian(jj*size_errorimage+1:(jj+1)*size_errorimage,ii*size_errorimage+1:(ii+1)*size_errorimage)))/(size_errorimage*size_errorimage);
   end
end

end

