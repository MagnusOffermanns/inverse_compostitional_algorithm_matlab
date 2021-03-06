function [ output_Image ] = warp_rotxy(Image,goal_image,warp_params)%offset_x,offset_y,alpha,scale,rotx_deg,roty_deg )
%warp_xy warps the image so that a rotation around x and y and z achis is
%applied. Additionally a translation in z direction is applied (scale). The
%warp is applied with the center of warp in the middle of the picture.
%   Detailed explanation goes here
%warp_params=[transx,transy,transz,rotz,rotx,roty]
%create a camera matrix to later transform the picture coordinates to -1 to 1


%convert the 2x2 picture into a 4xnumber of pixels vector (x coord,y coord,z coord,pixel intensity)
warpablepicobj=warpablepic(Image,goal_image);

%generate matrixes to later transform
%roation matrix z
 rz_transform =[cos(warp_params(6)) -sin(warp_params(6)) 0;...
     sin(warp_params(6)) cos(warp_params(6)) 0;...
     0 0 1]; %rotation around the center

%roation x
rx_transform=[1 0 0;
              0 cos(warp_params(4)) -sin(warp_params(4));
              0 sin(warp_params(4)) cos(warp_params(4))];
 
 %rotation y         
ry_transform=[cos(warp_params(5)) 0 sin(warp_params(5));
              0 1 0;
              -sin(warp_params(5)) 0 cos(warp_params(5))];
 
%scale matrix
s_transform=[(1+warp_params(3)) 0 0;...
            0 (1+warp_params(3)) 0 ;...
            0 0 1];
        
        
%apply the four transforms first rotation (r_transform) then scale (s_transform) then rotation in x (rotx) and
%then rotation in y roty
warpablepicobj.data(1:3,:)=rz_transform*ry_transform*rx_transform*warpablepicobj.data(1:3,:);

%translation
translationvector=warpablepicobj.cameramatrix*[warp_params(1);warp_params(2);0];
translationvector(3)=warp_params(3);
warpablepicobj.data(1:3,:)=bsxfun(@minus,warpablepicobj.data(1:3,:),translationvector);



%project on groundplane
warpablepicobj.data(1,:)=warpablepicobj.data(1,:)./warpablepicobj.data(3,:);
warpablepicobj.data(2,:)=warpablepicobj.data(2,:)./warpablepicobj.data(3,:);
warpablepicobj.data(3,:)=1; %substitute by 1 to for speed up




 %plots the points created by the warp and altered by the frame
%creator
%xyrot_translationvector=rx_transform*ry_transform*[0;0;1];
%xyrot_translationvector=xyrot_translationvector./xyrot_translationvector(3);

%creates a frame around the data
%warpablepicobj.data=frame_creator(warpablepicobj.data,[0;0;0]);
%scatter(warpablepicobj.data(1,:),warpablepicobj.data(2,:))
%axis ij

%xyrot_translationvector=rx_transform*ry_transform*[0;0;1];
%xyrot_translationvector=xyrot_translationvector./xyrot_translationvector(3)

            



%translation
%translationvector=warpablepicobj.cameramatrix*[warp_params(1);warp_params(2);0];
%warpablepicobj.data(1:2,:)=bsxfun(@minus,warpablepicobj.data(1:2,:),translationvector(1:2,:));

%converts back from a 4X1 array of pixels to a 2x2 picture
output_Image=warpablepicobj.warpablepic2pic(); %next challenge -> fix padding



end

