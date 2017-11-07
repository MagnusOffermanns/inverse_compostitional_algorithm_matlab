function [ T,I ] = create_images(image,size_picx,size_picy,displacement_x,displacement_y,height_snippet,width_snippet,scale,alpha,offset_x,offset_y)
%creates the 
%   Detailed explanation goes here

reference_object=imref2d([size_picy size_picx]);
to_origin_transform=[1 0 0;...
                     0 1 0;...
                     -displacement_x-mean(reference_object.XIntrinsicLimits) -displacement_y-mean(reference_object.YIntrinsicLimits) 1];

                 to_origin_transform=affine2d(to_origin_transform);
         
         reference_object.XWorldLimits=reference_object.XWorldLimits-mean(reference_object.XIntrinsicLimits);
         reference_object.YWorldLimits=reference_object.YWorldLimits-mean(reference_object.YIntrinsicLimits);
        
         Data=imwarp(image,to_origin_transform,'cubic','OutputView',reference_object);
            

T=operated_picture(Data,height_snippet,width_snippet);
%T=T.fill_data_rect(image,[displacement_y,displacement_x]);

%reference_object=imref2d(size(image));


%translation=[size(image,2)-2*(displacement_x+center_world(2)),size(image,1)-2*(displacement_y+center_world(1))];
%translation=[size(image,2)-1-2*floor(displacement_x+size_picx/2-1),size(image,1)-1-2*floor(displacement_y+size_picy/2-1)];
%warped_image=imtranslate(image,translation,'FillValues',0,'OutputView','full'); %translation is [translationx, translation_y]

 r_transform =[cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1]; %rotation around the center
            
 from_origin_transform=[1 0 0; ...
                        0 1 0;
                       -displacement_x-mean(T.reference_object_entire.XIntrinsicLimits) -displacement_y-mean(T.reference_object_entire.YIntrinsicLimits) 1];
            
 t_transform=[1 0 0; ...
              0 1 0;
              -offset_x -offset_y 1;]
            


transform =affine2d(from_origin_transform*r_transform*t_transform);%*from_origin_transform);
[warped_image]=imwarp(image,transform,'cubic','Outputview',reference_object);

%
%imwarp(T.Data,T.reference_object_entire,affine2d(eye(3)),'OutputView',T.reference_object_snippet);


%transform =affine2d([(1+scale) 0 0;0 (1+scale) 0; 0 0 1]) %postive zahl -> bild groesser -> kleinerer  Kameraausschnitt -> reinzoomen
%warped_image=imwarp(warped_image,transform);
%warped_image=warped_image(floor((size(warped_image,1)/2)-(T.size_picy/2))+1+offset_y:ceil((size(warped_image,1)/2)+(T.size_picy/2))+offset_y,...
%                            floor((size(warped_image,2)/2)-(T.size_picx/2))+1+offset_x:ceil((size(warped_image,2)/2)+(T.size_picx/2))+offset_x);
%warped_image=warped_image(floor((size(warped_image,1)/2)-(T.size_picy/2))+1+offset_y:ceil((size(warped_image,1)/2)+(T.size_picy/2))+offset_y,...
%                            floor((size(warped_image,2)/2)-(T.size_picx/2))+1+offset_x:ceil((size(warped_image,2)/2)+(T.size_picx/2))+offset_x);

%warped_image=warped_image(floor((size(warped_image,1)/2))-floor(T.size_picy/2)+floor((1-(1+scale))/2*size_picy)+offset_y:floor((size(warped_image,1)/2)+(T.size_picy/2)-((1-(1+scale))/2*size_picy)-1)+offset_y,...
%    floor((size(warped_image,2)/2))-floor((T.size_picx/2))+floor(((1-(1+scale))/2*size_picx))+offset_x:floor((size(warped_image,2)/2))+floor(T.size_picx/2)-floor((1-(1+scale))/2*size_picx)+offset_x);

%transform =affine2d([1/(1+scale) 0 0;0 1/(1+scale) 0; 0 0 1])

%warped_image=imwarp(warped_image,transform);%,'OutputView', imref2d( size(T.Data) ));

%figure
%imshow(warped_image)

I=operated_picture(warped_image,height_snippet,width_snippet);

end