function [  ] = test_function(T,I,warp_param)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
error_before_snippet=sum(sum(abs(T.Data_snippet-I.Data_snippet)));
%imshow(abs(T.Data_snippet-I.Data_snippet))
close all
%error_before_entire=sum(sum(T.Data-I.Data));
plot2pictures(T,I,'data');
plot2pictures(T,I,'snippet')
I=I.warptzrotxyz(warp_param);
I=I.translate_op(warp_param);
I=I.get_Data_snippet(warp_param);
plot2pictures(T,I,'data')
plot2pictures(T,I,'snippet')
error_after_snippet=sum(sum(abs(T.Data_snippet-I.Data_snippet)));
%error_after_entire=sum(sum(T.Data-I.Data));
%continue here
fprintf(['error before of the snippet: ', num2str(error_before_snippet) , ' error after snippet: ', num2str(error_after_snippet) , '\n']);
imshow(abs(T.Data_snippet-I.Data_snippet))
end

