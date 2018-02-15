function [ output_Image ] = warp_rotxy( Image,offset_x,offset_y,alpha,scale,rotx_deg,roty_deg )
%warp_xy warps the image so that a rotation around x and y and z achis is
%applied. Additionally a translation in z direction is applied (scale). The
%warp is applied with the center of warp in the middle of the picture.
%   Detailed explanation goes here

%create a camera matrix to later transform the picture coordinates to -1 to 1
cameramatrix=createcameramatrix(Image);

%convert the 2x2 picture into a 4xnumber of pixels vector (x coord,y coord,z coord,pixel intensity)
warpablepic=pic2warpablepic(Image,cameramatrix);

%generate matrixes to later transform
%roation matrix
 r_transform =[cos(alpha) -sin(alpha) 0;...
     sin(alpha) cos(alpha) 0;...
     0 0 1]; %rotation around the center

%scale matrix
s_transform=[1/(1+scale) 0 0;...
            0 1/(1+scale) 0 ;...
            0 0 1];
        
%translation matrix (not yet implemented)
% t_transform=[1 0 -offset_x; ...
%              0 1 -offset_y;
%              0 0 1];        
        
%apply the four transforms first rotation (r_transform) then scale (s_transform) then rotation in x (rotx) and
%then rotation in y roty
warpablepic(1:3,:)=r_transform*s_transform*rotx(rotx_deg)*roty(roty_deg)*warpablepic(1:3,:);

%project on groundplane
warpablepic(1,:)=warpablepic(1,:)./warpablepic(3,:);
warpablepic(2,:)=warpablepic(2,:)./warpablepic(3,:);
warpablepic(3,:)=1; %substitute by 1 to for speed up

%converts back from a 4X1 array of pixels to a 2x2 picture
output_Image=warpablepic2pic(warpablepic,cameramatrix); %next challenge -> fix padding



end

