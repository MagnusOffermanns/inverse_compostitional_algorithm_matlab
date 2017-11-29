clc
clear all

 Image=rgb2gray(imread('test_pic4.jpg'));
 Image=Image(500:700,500:700);
 Image=cat(3,Image,Image);
theta=pi/16;
 t = [cos(theta)  0      -sin(theta)   0
     0             1              0     0
     sin(theta)    0       cos(theta)   0
     0             0              0     1];
 transform=affine3d(t);
 
 Image=imwarp(Image,transform);

 sizeOut = size(Image);
hFigRotated = figure;
hAxRotated  = axes;
slice(double(Image),sizeOut(2)/2,sizeOut(1)/2,sizeOut(3)/2);
grid on, shading interp, colormap gray