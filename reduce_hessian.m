function [ output_hessian ] = reduce_hessian( hessian,size_errorimage )
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
output_hessian=zeros(size(hessian,1)/size_errorimage);
for jj=0:size(hessian,1)/size_errorimage-1
   for ii=0:size(hessian,1)/size_errorimage-1
    output_hessian(ii+1,jj+1)=sum(sum(hessian(jj*size_errorimage+1:(jj+1)*size_errorimage,ii*size_errorimage+1:(ii+1)*size_errorimage)))/(size_errorimage*size_errorimage);
   end
end

end

