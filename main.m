clc;
clear variables;
close all;
tic
disp('ich bin die main');
%breakpoints
dbstop in test_function

%load('test.mat');
%Image=test_data;
tic
%Image=rgb2gray(imread('test_pic4.jpg'));%=zeros(10)%rgb2gray(imread('test_pic4.jpg'));
%Image=zeros(13,13);
%Image(ceil(size(Image,1)/2),ceil(size(Image,2)/2))=255;
%Image(floor(size(Image,1)/2)+1,floor(size(Image,2)/2))=255;
%Image(floor(size(Image,1)/2),floor(size(Image,2)/2+1))=255;
%Image(floor(size(Image,1)/2+1),floor(size(Image,2)/2+1))=255;
%if normal test picture
test_or_real='rect';

if isequal(test_or_real,'real')
Image=rgb2gray(imread('test_pic4.jpg'));
Image=double(Image)/255;
displacement_y=size(Image,1)/4+30; 
displacement_x=size(Image,2)/4+120; %original 30
size_picx=size(Image,2)/6;   
size_picy=size(Image,1)/6;  
Image=markpoint(Image,displacement_x+size_picx/2,displacement_y+size_picy/2); %muss verbessert werden (unter pixel genauigkeit)
elseif isequal(test_or_real,'test')
 size_cross=16;
 Image=create_cross(size_cross,size_cross);
 size_picx=8;
 size_picy=8;
 displacement_x=size_cross/2-(size_picx/2);
 displacement_y=size_cross/2-(size_picy/2);
 imshow(Image)
elseif isequal(test_or_real,'rect')
multiplier=50
    
size_rect=multiplier*6
size_picx=multiplier*3;
size_picy=multiplier*3; 
 
 displacement_x=size_rect/2-(size_picx/2);
 displacement_y=size_rect/2-(size_picy/2);

 Image=paint_rect(size_rect,size_rect,0,multiplier*1,multiplier*1,multiplier*4,multiplier*4,1,1);
 Image=paint_rect(size_rect,size_rect,Image,multiplier*2,multiplier*2,multiplier*2,multiplier*2,0,0);
 
 imshow(Image)
elseif isequal(test_or_real,'dot')
size_dot=16;
Image=create_dot(size_dot);       
 size_picx=8;
 size_picy=8;
 displacement_x=size_dot/2-(size_picx/2);
 displacement_y=size_dot/2-(size_picy/2);
 imshow(Image,imref2d(size(Image),[-1 1],[-1 1]));   
end

%Image(1:20,1:20) = 1;
% Image(size(Image,1),1) = 1;
% Image(1,size(Image,2)) = 1;
% Image(size(Image,1),size(Image,2)) = 1;
%Image=create_cross(size(Image,1),size(Image,2));
 


width_snippet=1;%world coordinates from -1 to 1
height_snippet=1;

global jacobianchooser
global ground_truth
global interpolation_degree;

interpolation_degree='linear';

offset_x=0;-1;
offset_y=0;2;
scale=0;(-1+(1.01)); %-1 to calculate the actual scale since we scale by 1+scale %minus -> bigger plus -> smaller
rotation_x=0;-2*pi/360*20; %0.0087
rotation_y=0;%-2*pi/360*0; %0.0087
alpha=0;-2*pi/360*0.5; %0.0087


jacobianchooser=bi2de([1 1 1 0 0 1])

ground_truth=[offset_x;offset_y;scale;rotation_x;rotation_y;alpha];
[T,I]=create_images(Image,size_picx,size_picy,displacement_x,displacement_y,height_snippet,width_snippet,scale,alpha,offset_x,offset_y,rotation_x,rotation_y); %create_images(image,size_picx,size_picy,offset_x,offset_y,border,displacement_x,displacement_y)
plot2pictures(T,I,'data')
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


