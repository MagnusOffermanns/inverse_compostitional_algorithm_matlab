clc;
clear variables;
close all;
tic
disp('ich bin die main');
%load('test.mat');
%Image=test_data;
tic
Image=rgb2gray(imread('test_pic4.jpg'));%=zeros(10)%rgb2gray(imread('test_pic4.jpg'));
%Image(size(Image,1)/2,size(Image,2)/2)=0;
%Image(size(Image,1)/2+1,size(Image,2)/2)=0
%Image(size(Image,1)/2,size(Image,2)/2+1)=0
%Image(size(Image,1)/2+1,size(Image,2)/2+1)=0

displacement_y=320; %1
displacement_x=320; %1
size_picx=500; %8
size_picy=500; %8 
offset_y=3;
offset_x=2;
D=[50*1;-100*1]; %y,x
A=[-50*1;-100*1];
C=[50*1;100*1];
B=[-50*1;100*1];
%D=[3;-3]
%A=[-3,-3]
%C=[3;3]
%B=[-3;3]
center_world=[size_picy/2;size_picx/2];
alpha=2*pi/360*0; %0.0175
scale=0;


[T,I]=create_images(Image,size_picx,size_picy,displacement_x,displacement_y,D,C,B,A,center_world,scale,alpha,offset_x,offset_y); %create_images(image,size_picx,size_picy,offset_x,offset_y,border,displacement_x,displacement_y)
%plot2pictures(T,I)
warp_parameters=warpestimator_func(T,I);


%ideen -> warp parameter groesser machen waerend der fehler noch gross ist
%(levenberg marquard)
%0.5 fehler kommen von der round funktion

%T=rgb2gray(imread('Landschaftsbilder_1.jpg')); %read in rgb image and 
%I=rgb2gray(imread('Landschaftsbilder_2.jpg')); %converts it to reyscale
%warp_parameters=warpestimator_func(T,I);
toc


