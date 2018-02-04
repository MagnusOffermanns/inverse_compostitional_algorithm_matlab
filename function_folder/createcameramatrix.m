function [ cameramatrix ] = createcameramatrix( Image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cameramatrix=eye(3);
size_image=size(Image);


cameramatrix(1,3)=-1;
cameramatrix(2,3)=-1;
cameramatrix(1,1)=2/size_image(1);
cameramatrix(2,2)=2/size_image(2);


end

