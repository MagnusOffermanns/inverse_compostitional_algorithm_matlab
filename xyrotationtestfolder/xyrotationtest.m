clc;
clear variables;
close all;




 Image=zeros(13,13);
 Image(ceil(size(Image,1)/2),ceil(size(Image,2)/2))=255;
 %Image(floor(size(Image,1)/2)+1,floor(size(Image,2)/2))=255;
 %Image(floor(size(Image,1)/2),floor(size(Image,2)/2+1))=255;
 %Image(floor(size(Image,1)/2+1),floor(size(Image,2)/2+1))=255;
Image=rgb2gray(imread('test_pic4.jpg'));
%Image=ones(4)*254
Image=Image(700:1000,500:800);
%Image=[1,0;0,1]
Image=double(Image)/254;
%Image=create_cross(size(Image,1),size(Image,2));
tic
Image=warp_rotxy(Image,5,5);
toc
% warpablepic=pic2warpablepic(Image,cameramatrix);
% %rotation by x degrees
% %warpablepic(4,:)=warpablepic(4,:)+ones(1,length(warpablepic(4,:)));
% warpablepic(1:3,:)=rotx(5)*warpablepic(1:3,:);
% %projection on groundplane
% warpablepic(1,:)=warpablepic(1,:)./warpablepic(3,:);
% warpablepic(2,:)=warpablepic(2,:)./warpablepic(3,:);
% warpablepic(3,:)=warpablepic(3,:)./warpablepic(3,:);
% %elimination of empty entries
% %warpablepic=warpablepic(:,warpablepic(4,:)~=0);
% %warpablepic(4,:)=warpablepic(4,:)-ones(1,length(warpablepic(4,:)));
% %warpablepic(1:2,:)=round(warpablepic(1:2,:))+ones(2,length(warpablepic));
% %conversion back to normal picture
% Image=warpablepic2pic(warpablepic,cameramatrix,100,100); %sama hier
imshow(Image);


