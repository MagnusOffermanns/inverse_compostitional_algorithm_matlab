function [ cameramatrix ] = createcameramatrix( Image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cameramatrix=eye(3);
size_image=size(Image);

y_mean=-(1+size(Image,1))/2;
x_mean=-(1+size(Image,2))/2;

scale_y=1/-(y_mean);
scale_x=1/-(x_mean);
cameramatrix(1,3)=-1;
cameramatrix(2,3)=-1;
cameramatrix(1,1)=scale_x;
cameramatrix(2,2)=scale_y;


end

