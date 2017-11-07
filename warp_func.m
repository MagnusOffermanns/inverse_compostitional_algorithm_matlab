function [I_temp] = warp_func(warp_param,I)
%warp_func warps a picture by warp paramerters warp_param
%   Detailed explanation goes here

I_temp=I;
I_temp=I_temp.rotate_op(warp_param(4)); %correct
%imshow(I.Data)
I_temp=I_temp.translate_op([warp_param(1);warp_param(2);warp_param(3)]); %x,y,z
%translation correct scale broken
%I_temp.plot_camera_pos();
%now scaling dann fertig :)

I_temp=I_temp.get_Data_snippet;


end

