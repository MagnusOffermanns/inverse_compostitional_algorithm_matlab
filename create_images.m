function [ T,I ] = create_images(image,size_picx,size_picy,displacement_x,displacement_y,height_snippet,width_snippet,scale,alpha,offset_x,offset_y,rotation_x,rotation_y,save_to_drive)
%create_images creates the two images which are later used to run the inverse
%conpositional algorithm
%   Detailed explanation goes here

global interpolation_degree

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%T%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generate the original Template T 
reference_object=imref2d([size_picy size_picx],[-1 1], [-1 1]); %generates the reference object
help_reference_object=imref2d(size(image),reference_object.PixelExtentInWorldX,reference_object.PixelExtentInWorldY); 
%matrix that shifts the middle of the wanted image in the coordinate (0/0)
%-> dispacement_x+size_picx/2 and dispalcement_y+size_picy/2 are now (0/0)
to_origin_transform=[1 0 0;...
                     0 1 0;...
                     (-displacement_x-mean(reference_object.XIntrinsicLimits))*reference_object.PixelExtentInWorldX (-displacement_y-mean(reference_object.YIntrinsicLimits))*reference_object.PixelExtentInWorldY 1];

%creates the affine 2d object for later warp from to_origin transform
to_origin_transform=affine2d(to_origin_transform);

% shifts the X- and Y- Worldlimits of the reference_object to (0/0) to cut
% a picture with size_picx and size_picy out of the center of the picture
%reference_object.XWorldLimits=reference_object.XWorldLimits-mean(reference_object.XIntrinsicLimits);
%reference_object.YWorldLimits=reference_object.YWorldLimits-mean(reference_object.YIntrinsicLimits);
        
%apply the origin transform and cut it out with the reference object
Data=imwarp(image,help_reference_object,to_origin_transform,interpolation_degree,'OutputView',reference_object);
            
%create the Picture object
T=operated_picture(Data,height_snippet,width_snippet,interpolation_degree);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%I%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create the I object
%create a reference object which is used to keep the frame stable when we
%move the pixels around
%reference_object=imref2d([size_picy size_picx],[-1 1], [-1 1]); %generates the reference object
help_reference_object=imref2d(size(image),reference_object.PixelExtentInWorldX,reference_object.PixelExtentInWorldY); 
%help_reference_object.XWorldLimits=help_reference_object.XWorldLimits-(mean(help_reference_object.XIntrinsicLimits)*help_reference_object.PixelExtentInWorldX);
%help_reference_object.YWorldLimits=help_reference_object.YWorldLimits-(mean(help_reference_object.YIntrinsicLimits)*help_reference_object.PixelExtentInWorldY);

%move center of the future cut out picture to the center of the frame 
%crop_transform=[1 0 0; ...
 %               0 1 0;
 %               mean(help_reference_object.XIntrinsicLimits)+(-displacement_x-(size_picx/2)) mean(help_reference_object.YIntrinsicLimits)+(-displacement_y-(size_picy/2)) 1];

crop_transform=[1 0 0; ...
                0 1 0;
                (-0.5-displacement_x-(size_picx/2)+(mean(help_reference_object.XIntrinsicLimits)))*help_reference_object.PixelExtentInWorldX (-0.5-displacement_y-(size_picy/2)+(mean(help_reference_object.YIntrinsicLimits)))*help_reference_object.PixelExtentInWorldY 1];
 
 %apply the crop transform and get the pixels which are still in the
%frame of help_reference_object

cropped_image=imwarp(image,help_reference_object,affine2d(crop_transform),interpolation_degree,'OutputView',help_reference_object);


%warp the picture in rotation in x,y,z and translation in z
warped_image=warp_rotxy(cropped_image,T.Data,[offset_x,offset_y,scale,rotation_x,rotation_y,alpha]);       
%srxyrot_warped_image=cropped_image;
%imshow(srxyrot_warped_image)

%get a new referenceobject from the warped picture (warp_rotxy changes the image size)
%!help_reference_object=imref2d(size(srxyrot_warped_image),reference_object.PixelExtentInWorldX,reference_object.PixelExtentInWorldY);
%move the zero point of the reference object of the newly warped picture to (0/0) 
%! help_reference_object.XWorldLimits=help_reference_object.XWorldLimits-mean(help_reference_object.XIntrinsicLimits*help_reference_object.PixelExtentInWorldX);
%! help_reference_object.YWorldLimits=help_reference_object.YWorldLimits-mean(help_reference_object.YIntrinsicLimits*help_reference_object.PixelExtentInWorldY);

 %translation   
%!help_reference_object.XWorldLimits=help_reference_object.XWorldLimits-offset_x*help_reference_object.PixelExtentInWorldX;
%!help_reference_object.YWorldLimits=help_reference_object.YWorldLimits-offset_y*help_reference_object.PixelExtentInWorldY;
% from_origin_transform=[1 0 0; ...
%                        0 1 0;
%                       -mean(help_reference_object.XIntrinsicLimits) -mean(help_reference_object.YIntrinsicLimits) 1];


%defining the transformation matrix to translate the picture since
%warp_rotxy does not translate
%translation matrix            
%  t_transform=[1 0 0; ...
%               0 1 0;
%               -offset_x*help_reference_object.PixelExtentInWorldX -(offset_y*help_reference_object.PixelExtentInWorldY) 1];
%  

%1t_transform=eye(3)
 % create affine 2d object for the warp
%1 transform = affine2d(t_transform);            



%warp the picture 
%1[warped_image,~]=imwarp(srxyrot_warped_image,help_reference_object,transform,interpolation_degree,'Outputview',reference_object);

%figure
%imshow(warped_image)

%generate the I object
I=operated_picture(warped_image,height_snippet,width_snippet,interpolation_degree);

if strcmp(save_to_drive, 'save')
    imwrite(T.Data,'T_Data.png')
    imwrite(I.Data,'I_Data.png')
end

end