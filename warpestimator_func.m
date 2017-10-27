function [ warp_param] = warpestimator_func(T,I)
%warpestimator_func estimates the translation parameters based on two pictures T and I 
%   Detailed explanation goes here
%profile on;
warp_param=[0,0,0,0]; %[x-translation,y-translation,scale,rotation]
%precalculations
[Gx,Gy]=gradientcalc(T.Data);%gradient bedenken 
gradient_times_jacobian=calcjacobiantimesgradient(Gx,Gy,T); %gradient times jacobian at x=0
hessian=calc_hessian(gradient_times_jacobian);


%warpablepicI=pic2warpablepic(I); % brings the picture in a state so that 
                                             %a warp can be applied

runtime=400;
error_vector=zeros(1,runtime);
error_plot_flag=0;
for ii=1:runtime% does the estimation 100 times since I dont know the estimated error 

[Snap_I]=warp_func(warp_param,I,T);

%[Gx,Gy,size_x,size_y]=gradientcalc(effektive_picture_scaled); %muss nicht gewarped werden da es gleich gross ist wie I und die Border sich gleich verschiebt


[delta_p,error_num]=calc_delta_p(T.snap(0,0),Snap_I,hessian,gradient_times_jacobian,error_plot_flag);
error_vector(ii)=error_num;

error_plot_flag=0;


warp_param=warp_param+transpose(delta_p);
update=['xtranslation: ',num2str(warp_param(1)),'  y translation: ', num2str(warp_param(2)), '  scale: ', num2str(warp_param(3)),'  rotation: ', num2str(warp_param(4))];
disp(update);
end
%updates the warp parameter

figure
plot(error_vector);
%profile viewer

end

