function [] = debug_func( T,I,warp_parameters)
%UNTITLED2 calculates errors and compares efficacy of warp functions
%   Detailed explanation goes here
previouse_error=T.Data_snippet-I.Data_snippet;
previouse_error_sum=sum(sum(abs(T.Data_snippet-I.Data_snippet)));
I_temp=warp_func(warp_parameters,I)
post_error=T.Data_snippet-I_temp.Data_snippet;
post_error_sum=sum(sum(abs(T.Data_snippet-I_temp.Data_snippet)));

disp(['previouse error: ',num2str(previouse_error_sum),' post_error: ',num2str(post_error_sum)]);

figure
subplot(2,1,1)       % add first plot in 2 x 1 grid
imshow(previouse_error)
title('previouse error')

subplot(2,1,2)       % add second plot in 2 x 1 grid
imshow(post_error)       
title('post error')

figure 
imshowpair(T.Data_snippet,T.reference_object_snippet,I_temp.Data_snippet,I_temp.reference_object_snippet)

end

