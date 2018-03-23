function [ warp_param] = warpestimator_func(T,I)
%warpestimator_func estimates the translation parameters based on two pictures T and I 
%   Detailed explanation goes here
%profile on;

warp_param=[0,0,0,0,0,0]; %[x-translation,y-translation,scale,z rotation,x rotation,y rotation]
%precalculations
[Gx,Gy]=gradientcalc(T.Data_snippet);%gradient berechnen 
gradient_times_jacobian=calcjacobiantimesgradient(Gx,Gy,T); %gradient times jacobian at x=0 %chagned
hessian=calc_hessian(gradient_times_jacobian); 


%warpablepicI=pic2warpablepic(I); % brings the picture in a state so that 
                                             %a warp can be applied

runtime=500;
global error_vector;
global warp_param_vector;
error_vector = -100*ones(1,runtime);
warp_param_vector=-100*ones(6,runtime);

cleanupObj = onCleanup(@()cleanMeUp());
error_plot_flag=0;
for ii=1:runtime% does the estimation 100 times since I dont know the estimated error 

[I_temp]=warp_func(warp_param,I);

%[Gx,Gy,size_x,size_y]=gradientcalc(effektive_picture_scaled); %muss nicht gewarped werden da es gleich gross ist wie I und die Border sich gleich verschiebt


[delta_p,error_num]=calc_delta_p(T,I_temp,hessian,gradient_times_jacobian,error_plot_flag);
error_vector(ii)=error_num;

error_plot_flag=0;


warp_param=warp_param+transpose(delta_p);
warp_param_vector(:,ii)=transpose(warp_param);
update=['xtranslation: ',num2str(warp_param(1)),'  y translation: ', num2str(warp_param(2)), '  z translation: ', num2str(warp_param(3)),'  rotation x: ', num2str(warp_param(4)),'  rotation y: ',num2str(warp_param(5)),'  rotation z: ',num2str(warp_param(6)),' iteration: ',num2str(ii)];
disp(update);
end
%updates the warp parameter

%figure
%subplot(1,2,1)
%plot(error_vector);

%profile viewer

end


function [] = cleanMeUp()
%cleanMeUP gets executed if controll-c is pressed 

global error_vector;
global warp_param_vector;
global ground_truth;
global stepsize_multiplier;


error_vector=error_vector(error_vector~=-100);
warp_param_vector=warp_param_vector(:,warp_param_vector(1,:)~=-100);
 ground_truth=ones(size(warp_param_vector,2),6)*[ground_truth(1),0,0,0,0,0;0,ground_truth(2),0,0,0,0;0,0,ground_truth(3),0,0,0;0,0,0,ground_truth(4),0,0;0,0,0,0,ground_truth(5),0;0,0,0,0,0,ground_truth(6)];
ground_truth=transpose(ground_truth);
%correction of the warp params by the stepsize multiplier
warp_param_vector=bsxfun(@times, warp_param_vector, stepsize_multiplier');
scrsz = get(groot,'ScreenSize');
figure('Position',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
subplot(1,2,2)
plot(error_vector);
subplot(1,2,1)
hold all
%correct for parmas 1-3 and 6
plot(warp_param_vector(1,:),'color','r');
plot(warp_param_vector(2,:),'color','c');
plot(warp_param_vector(3,:)*100,'color','g');
plot(warp_param_vector(4,:)*100,'color','k');
plot(warp_param_vector(5,:)*100,'color','b');
plot(warp_param_vector(6,:)*100,'color','m');
plot(-ground_truth(1,:),'color','r');
plot(-ground_truth(2,:),'color','c');
plot(-ground_truth(3,:)*100,'color','g');
plot(-ground_truth(4,:)*100,'color','k');
plot(-ground_truth(5,:)*100,'color','b');
plot(-ground_truth(6,:)*100,'color','m');
legend('xtrans', 'ytrans' ,'ztrans','rotx','roty','rotz');
end


