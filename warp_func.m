function [I_temp] = warp_func(warp_param,I)
%warp_func warps a picture by warp paramerters warp_param
%   Detailed explanation goes here

I_temp=I;
%function for translation in z and rotation in x,z,z
I_temp=I_temp.warptzrotxyz(warp_param);
%translation function
I_temp=I_temp.translate_op(warp_param);
I_temp=I_temp.get_Data_snippet(warp_param);


end

