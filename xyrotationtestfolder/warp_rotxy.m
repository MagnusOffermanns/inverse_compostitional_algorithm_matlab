function [ output_Image ] = warp_rotxy( Image,rotx_deg,roty_deg )
%warp_xy warps the image so that a rotation around x and y is applied
%   Detailed explanation goes here

%create a camera matrix to warp the picture to -1 to 1
cameramatrix=createcameramatrix(Image);

%convert the 2x2 picture into a 3xnumber of pixels vector 
warpablepic=pic2warpablepic(Image,cameramatrix);

%roation matrix
 r_transform =[cos(alpha) -sin(alpha) 0;...
     sin(alpha) cos(alpha) 0;...
     0 0 1]; %rotation around the center

%scale matrix
s_transform=[1/(1+scale) 0 0;...
            0 1/(1+scale) 0 ;...
            0 0 1];

%rotation by x degrees in x and y direction
warpablepic(1:3,:)=r_transform*s_transform*rotx(rotx_deg)*roty(roty_deg)*warpablepic(1:3,:);

%projection on groundplane
warpablepic(1,:)=warpablepic(1,:)./warpablepic(3,:);
warpablepic(2,:)=warpablepic(2,:)./warpablepic(3,:);
warpablepic(3,:)=1;%warpablepic(3,:)./warpablepic(3,:); %substitute by 1 to for speed up

%converts back from a 3*number of pixels to a 2x2 picture
output_Image=warpablepic2pic(warpablepic,cameramatrix,100,100); %next challenge -> fix padding




end

