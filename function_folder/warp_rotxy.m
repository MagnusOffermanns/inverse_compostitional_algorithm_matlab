function [ output_Image ] = warp_rotxy(Image,warp_params)%offset_x,offset_y,alpha,scale,rotx_deg,roty_deg )
%warp_xy warps the image so that a rotation around x and y and z achis is
%applied. Additionally a translation in z direction is applied (scale). The
%warp is applied with the center of warp in the middle of the picture.
%   Detailed explanation goes here
%warp_params=[transx,transy,transz,rotz,rotx,roty]
%create a camera matrix to later transform the picture coordinates to -1 to 1


%convert the 2x2 picture into a 4xnumber of pixels vector (x coord,y coord,z coord,pixel intensity)
warpablepicobj=warpablepic(Image);

%generate matrixes to later transform
%roation matrix z
 rz_transform =[cos(warp_params(6)) -sin(warp_params(6)) 0;...
     sin(warp_params(6)) cos(warp_params(6)) 0;...
     0 0 1]; %rotation around the center

 %rotation y         
ry_transform=[cos(warp_params(5)) 0 sin(warp_params(5));
              0 1 0;
              -sin(warp_params(5)) 0 cos(warp_params(5))];
 
%roation x
rx_transform=[1 0 0;
              0 cos(warp_params(4)) -sin(warp_params(4));
              0 sin(warp_params(4)) cos(warp_params(4))];
%scale matrix
s_transform=[(1+warp_params(3)) 0 0;...
            0 (1+warp_params(3)) 0 ;...
            0 0 1];
        
%translation matrix (not yet implemented)
% t_transform=[1 0 -offset_x; ...
%              0 1 -offset_y;
%              0 0 1];        
        
%apply the four transforms first rotation (r_transform) then scale (s_transform) then rotation in x (rotx) and
%then rotation in y roty
warpablepicobj.data(1:3,:)=rz_transform*rx_transform*ry_transform*s_transform*warpablepicobj.data(1:3,:);

%project on groundplane
warpablepicobj.data(1,:)=warpablepicobj.data(1,:)./warpablepicobj.data(3,:);
warpablepicobj.data(2,:)=warpablepicobj.data(2,:)./warpablepicobj.data(3,:);
warpablepicobj.data(3,:)=1; %substitute by 1 to for speed up

%converts back from a 4X1 array of pixels to a 2x2 picture
output_Image=warpablepicobj.warpablepic2pic(); %next challenge -> fix padding



end

