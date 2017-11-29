function [ delta_p,error_num ] = calc_delta_p(T,I,hessian,gradient_times_jacobian,plot_flag)
%calc_delta_p Calculates the 
%   Detailed explanation goes here
delta_p=zeros(size(gradient_times_jacobian,2),1);
error_num=0;

%to plot the error
% if plot_flag==1
% ploterror=zeros(size_picy,size_picx);
% end


parfor yy=1:T.reference_object_snippet.ImageSize(1)
    for xx=1:T.reference_object_snippet.ImageSize(2)
        %error_num=error_num+abs(double(T.Data_snippet(yy,xx)-I.Data_snippet(yy,xx)));
        %error_num=error_num+double((T(yy+border_y,xx+border_x)-I(yy+w_border_y,xx+w_border_x)));%calculation of the error at pixel xx,yy
        
        delta_p=delta_p+transpose(gradient_times_jacobian(((yy-1)*T.reference_object_snippet.ImageSize(2)+xx),:))*double((T.Data_snippet(yy,xx)-I.Data_snippet(yy,xx))); %calculation of formular 10
        
    end
end
error_num=sum(sum(abs(T.Data_snippet-I.Data_snippet)))
delta_p=pinv(hessian)*delta_p;



end

