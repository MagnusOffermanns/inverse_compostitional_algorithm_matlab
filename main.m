clc;
clear variables;
close all;
tic
disp('ich bin die main');
%load('test.mat');
%Image=test_data;
tic
%Image=rgb2gray(imread('test_pic4.jpg'));%=zeros(10)%rgb2gray(imread('test_pic4.jpg'));
 Image=zeros(13,13);
 Image(ceil(size(Image,1)/2),ceil(size(Image,2)/2))=255;
 %Image(floor(size(Image,1)/2)+1,floor(size(Image,2)/2))=255;
 %Image(floor(size(Image,1)/2),floor(size(Image,2)/2+1))=255;
 %Image(floor(size(Image,1)/2+1),floor(size(Image,2)/2+1))=255;
Image=rgb2gray(imread('test_pic4.jpg'));
 
 
displacement_y=500; 
displacement_x=500;
size_picx=200;   %just uneven numbers
size_picy=100;  
offset_y=3;
offset_x=2;
width_snippet=1;%world coordinates from -1 to 1
height_snippet=1
% D=[50*1/2;-100*1/2]; %y,x
% A=[-50*1/2;-100*1/2];
% C=[50*1/2;100*1/2];
% B=[-50*1/2;100*1/2];
%D=[2.5;-2.5]
%A=[-2.5,-2.5]
%C=[2.5;2.5]
%B=[-2.5;2.5]
alpha=2*pi/360*0; %0.0175
scale=0;

[T,I]=create_images(Image,size_picx,size_picy,displacement_x,displacement_y,height_snippet,width_snippet,scale,alpha,offset_x,offset_y); %create_images(image,size_picx,size_picy,offset_x,offset_y,border,displacement_x,displacement_y)
%plot2pictures(T,I)
translation_vector=[I.reference_object_entire.PixelExtentInWorldY*offset_y,... %debug information
    I.reference_object_entire.PixelExtentInWorldX*offset_x]
warp_parameters=warpestimator_func(T,I);


%ideen -> warp parameter groesser machen waerend der fehler noch gross ist
%(levenberg marquard)
%0.5 fehler kommen von der round funktion

%T=rgb2gray(imread('Landschaftsbilder_1.jpg')); %read in rgb image and 
%I=rgb2gray(imread('Landschaftsbilder_2.jpg')); %converts it to reyscale
%warp_parameters=warpestimator_func(T,I);
toc


