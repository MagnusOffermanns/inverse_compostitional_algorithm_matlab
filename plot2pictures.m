function  plot2pictures( T,I )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
f = figure;
p = uipanel('Parent',f,'BorderType','none'); 
subplot(1,2,1,'Parent',p) 
imshow(T.Data)
T.plot_camera_pos();
title('T') 
subplot(1,2,2,'Parent',p)
imshow(I.Data)
I.plot_camera_pos();
title('I') 


end

