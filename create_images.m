function [ T,I ] = create_images(image,size_picx,size_picy,displacement_x,displacement_y,height_snippet,width_snippet,scale,alpha,offset_x,offset_y)
%creates the 
%   Detailed explanation goes here
%generate the original Template T 
reference_object=imref2d([size_picy size_picx]); %generates the reference object

%matrix that shifts the middle of the wanted image in the coordinate (0/0)
%-> dispacement_x+half of the picture witdth and dispalcement_y+half of the
%height are now (0/0)
to_origin_transform=[1 0 0;...
                     0 1 0;...
                     -displacement_x-mean(reference_object.XIntrinsicLimits) -displacement_y-mean(reference_object.YIntrinsicLimits) 1];

                 %creates the affine 2d object for later warp
                 to_origin_transform=affine2d(to_origin_transform);
         % creates a reference object which is fitting for the image  
         reference_object.XWorldLimits=reference_object.XWorldLimits-mean(reference_object.XIntrinsicLimits);
         reference_object.YWorldLimits=reference_object.YWorldLimits-mean(reference_object.YIntrinsicLimits);
        %warps and gives just the pixels out which are in the reference
        %objects reference frame
         Data=imwarp(image,to_origin_transform,'cubic','OutputView',reference_object);
            
%create the Picture object
T=operated_picture(Data,height_snippet,width_snippet);




%displacement matrix to (0/0)            
 from_origin_transform=[1 0 0; ...
                        0 1 0;
                       -displacement_x-mean(T.reference_object_entire.XIntrinsicLimits) -displacement_y-mean(T.reference_object_entire.YIntrinsicLimits) 1];

%roation matrix
 r_transform =[cos(alpha) -sin(alpha) 0;...
     sin(alpha) cos(alpha) 0;...
     0 0 1]; %rotation around the center

%scale matrix
s_transform=[1/(1+scale) 0 0;...
            0 1/(1+scale) 0 ;...
            0 0 1];

 
%translation matrix            
 t_transform=[1 0 0; ...
              0 1 0;
              -offset_x -offset_y 1;]
            

% create affine 2d object for the warp
transform =affine2d(from_origin_transform*r_transform*s_transform*t_transform);%*from_origin_transform);
[warped_image]=imwarp(image,transform,'cubic','Outputview',reference_object);


I=operated_picture(warped_image,height_snippet,width_snippet);

end