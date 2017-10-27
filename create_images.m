function [ T,I ] = create_images(image,size_picx,size_picy,displacement_x,displacement_y,D,C,B,A,center_world,scale,alpha,offset_x,offset_y)
%creates the 
%   Detailed explanation goes here




T=operated_picture(D,C,B,A,size_picx,size_picy,center_world);
T=T.fill_data_rect(image,[displacement_y,displacement_x]);




translation=[size(image,2)-2*(displacement_x+center_world(2)),size(image,1)-2*(displacement_y+center_world(1))];
warped_image=imtranslate(image,translation,'FillValues',0,'OutputView','full'); %translation is [translationx, translation_y]

transform =affine2d([cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1]);
warped_image=imwarp(warped_image,transform);



%transform =affine2d([(1+scale) 0 0;0 (1+scale) 0; 0 0 1]) %postive zahl -> bild groesser -> kleinerer  Kameraausschnitt -> reinzoomen
%warped_image=imwarp(warped_image,transform);
warped_image=warped_image(floor((size(warped_image,1)/2)-(T.size_picy/2))+offset_y:floor((size(warped_image,1)/2)+(T.size_picy/2))+offset_y-1,...
                            floor((size(warped_image,2)/2)-(T.size_picx/2))+offset_x:floor((size(warped_image,2)/2)+(T.size_picx/2))+offset_x-1);

%warped_image=warped_image(floor((size(warped_image,1)/2))-floor(T.size_picy/2)+floor((1-(1+scale))/2*size_picy)+offset_y:floor((size(warped_image,1)/2)+(T.size_picy/2)-((1-(1+scale))/2*size_picy)-1)+offset_y,...
%    floor((size(warped_image,2)/2))-floor((T.size_picx/2))+floor(((1-(1+scale))/2*size_picx))+offset_x:floor((size(warped_image,2)/2))+floor(T.size_picx/2)-floor((1-(1+scale))/2*size_picx)+offset_x);

%transform =affine2d([1/(1+scale) 0 0;0 1/(1+scale) 0; 0 0 1])

%warped_image=imwarp(warped_image,transform);%,'OutputView', imref2d( size(T.Data) ));

%figure
%imshow(warped_image)
center_world=(size(warped_image).')./2
I=operated_picture(D,C,B,A,size_picx,size_picy,center_world);
I=I.fill_data_rect(warped_image,[1,1]);
end