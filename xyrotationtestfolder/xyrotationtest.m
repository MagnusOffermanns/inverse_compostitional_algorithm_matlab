clc;
clear variables;
close all;
tic
disp('ich bin die main');

tic
 Image=zeros(13,13);
 Image(ceil(size(Image,1)/2),ceil(size(Image,2)/2))=255;
 %Image(floor(size(Image,1)/2)+1,floor(size(Image,2)/2))=255;
 %Image(floor(size(Image,1)/2),floor(size(Image,2)/2+1))=255;
 %Image(floor(size(Image,1)/2+1),floor(size(Image,2)/2+1))=255;
Image=rgb2gray(imread('test_pic4.jpg'));
cameramatrix=createcameramatrix(Image);
%Image=[1,0;0,1]
Image=double(Image)/255;
%Image=create_cross(size(Image,1),size(Image,2));

warpablepic=pic2warpablepic(Image,cameramatrix);
%rotation by x degrees
%warpablepic(1:3,:)=rotx(20)*warpablepic(1:3,:);
%projection on groundplane
warpablepic(1,:)=warpablepic(1,:)./warpablepic(3,:);
warpablepic(2,:)=warpablepic(2,:)./warpablepic(3,:);
warpablepic(3,:)=warpablepic(3,:)./warpablepic(3,:);
%interpolation
%warpablepic(1:2,:)=round(warpablepic(1:2,:))+ones(2,length(warpablepic));
%conversion back to normal picture
Image=warpablepic2pic(warpablepic,cameramatrix,size(Image,2)+10,size(Image,1)+10); %sama hier
imshow(Image(:,:,2)./max(max(Image(:,:,2))))
figure
imshow(Image(:,:,1))


