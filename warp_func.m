function [I_temp] = warp_func(warp_param,I)
%warp_func warps a picture by warp paramerters warp_param
%   Detailed explanation goes here

I_temp=I;
%roationfunction
%I_temp=I_temp.rotate_op(warp_param(4)); %correct
%imshow(I.Data)
%translation function
%I_temp=I_temp.translate_op([warp_param(1);warp_param(2);warp_param(3)]); %x,y,z
%scaling
I_temp=I_temp.scale_op(warp_param(3));
%I_temp.plot_camera_pos();
%now scaling dann fertig :)

I_temp=I_temp.get_Data_snippet(warp_param);


end

