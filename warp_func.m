function [snapshot_I] = warp_func(warp_param,I,T)
%warp_func warps a picture by warp paramerters warp_param
%   Detailed explanation goes here

I_temp=I;
I_temp=I_temp.rotate_world(warp_param(4)); %correct
%imshow(I.Data)
I_temp=I_temp.translate_camera([warp_param(2);warp_param(1);warp_param(3)]);
%translation correct scale broken
%I_temp.plot_camera_pos();
%now scaling dann fertig :)

snapshot_I=I_temp.snap(warp_param(3),T.snap(0,0));


end

