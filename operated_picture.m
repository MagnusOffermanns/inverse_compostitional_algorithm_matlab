classdef operated_picture
    %Border is a class defining the border between the whole picture and
    %the picture which is processed
    %   Detailed explanation goes here
    
    properties
        Data
        center_W
        size_picy
        size_picx
        size_camera
        D_C   %upper left point of the operated picture %stile[y;x]
        C_C   %upper right point of the operated picture
        B_C   %lower right point of the operated picture
        A_C   %lower left point  of the operated picture
        D_W
        C_W
        B_W
        A_W
        
    end
    
    methods
        function obj=operated_picture(D_C,C_C,B_C,A_C,size_picx,size_picy,center_W)
        obj.D_C=D_C;
        obj.C_C=C_C;
        obj.B_C=B_C;
        obj.A_C=A_C;
        
        
        obj.center_W=center_W; %y,x
        obj.size_picx=size_picx;
        obj.size_picy=size_picy;
        obj.size_camera=[abs(D_C(1))+abs(A_C(1));abs(D_C(2))+abs(C_C(2))];
        
        
        obj.D_W=center_W+[-obj.D_C(1);obj.D_C(2)];
        obj.C_W=center_W+[-obj.C_C(1);obj.C_C(2)];
        obj.B_W=center_W+[-obj.B_C(1);obj.B_C(2)];
        obj.A_W=center_W+[-obj.A_C(1);obj.A_C(2)];

        
        end
        
        function obj=fill_data_rect(obj,Image,displacement)
           obj.Data=Image(displacement(1):displacement(1)+obj.size_picy-1,displacement(2):displacement(2)+obj.size_picx-1);
        end
        
        function obj=rotate_world(obj,alpha)
            %temp_size=size(obj.Data); %saving of the size of the picture before warp
            transform =affine2d([cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1]); %rotation around the center
            obj.Data=imwarp(obj.Data,transform);
           center_coordinates_new=(ceil(size(obj.Data)/2)).';
            obj=obj.set_camera(center_coordinates_new);
            % temp_size=ceil((size(obj.Data)-temp_size)/2); %coordinate difference between old and new picture
            %obj=obj.translate_camera([-temp_size.';0]); %
           % obj.plot_camera_pos();
            
        end
        
        function obj=rotate_camera(obj,alpha)
            
        rotation_matrix=[cos(alpha) -sin(alpha);...
            sin(alpha) cos(alpha)];
        
        temp_D=obj.D_W-obj.center_W;
        temp_C=obj.C_W-obj.center_W;
        temp_B=obj.B_W-obj.center_W;
        temp_A=obj.A_W-obj.center_W;
        
        temp_D=rotation_matrix*temp_D;
        temp_C=rotation_matrix*temp_C;
        temp_B=rotation_matrix*temp_B;
        temp_A=rotation_matrix*temp_A;
        
        obj.D_W=temp_D+obj.center_W;
        obj.C_W=temp_C+obj.center_W;
        obj.B_W=temp_B+obj.center_W;
        obj.A_W=temp_A+obj.center_W;
        
        %
        
        end
        
        
        function obj=translate_camera(obj,translation_vector)
            %also fit for scaling
            
% 
%             obj.D_C=floor(obj.D_C/(1+translation_vector(3))); %postive zahl -> kleinere werte -> rein zoomen
%             obj.C_C=floor(obj.C_C/(1+translation_vector(3)));
%             obj.B_C=floor(obj.B_C/(1+translation_vector(3)));
%             obj.A_C=floor(obj.A_C/(1+translation_vector(3)));
%             obj.size_camera=[abs(obj.D_C(1))+abs(obj.A_C(1));abs(obj.D_C(2))+abs(obj.C_C(2))];
%             
%             obj.D_W=obj.center_W+[-obj.D_C(1);obj.D_C(2)];
%             obj.C_W=obj.center_W+[-obj.C_C(1);obj.C_C(2)];
%             obj.B_W=obj.center_W+[-obj.B_C(1);obj.B_C(2)];
%             obj.A_W=obj.center_W+[-obj.A_C(1);obj.A_C(2)];
%             
            
            
            obj.center_W=obj.center_W+translation_vector(1:2);
            obj.D_W=obj.D_W+translation_vector(1:2);
            obj.C_W=obj.C_W+translation_vector(1:2);
            obj.B_W=obj.B_W+translation_vector(1:2);
            obj.A_W=obj.A_W+translation_vector(1:2);
            %code for upscaling to come
            %=imwarp(warped_image,transform,'OutputView', imref2d( size(T.Data) ));
            
            
        end
        
        function obj=set_camera(obj,coordinates)
           obj.center_W=coordinates;
           obj.D_W=obj.center_W+[-obj.D_C(1);obj.D_C(2)];
           obj.C_W=obj.center_W+[-obj.C_C(1);obj.C_C(2)];
           obj.B_W=obj.center_W+[-obj.B_C(1);obj.B_C(2)];
           obj.A_W=obj.center_W+[-obj.A_C(1);obj.A_C(2)];
            
        end
        
        function plot_camera_pos(obj)
        X_corners=[obj.D_W(2),obj.C_W(2),obj.B_W(2),obj.A_W(2)];
        Y_corners=[obj.D_W(1),obj.C_W(1),obj.B_W(1),obj.A_W(1)];
        if(isempty(findall(0,'Type','Figure')))
           figure
        end
        hold on
        plot(obj.center_W(2),obj.center_W(1),'x'); 
        plot(X_corners,Y_corners,'o');
        end
        
        function snapshot=snap(obj,scale,reference_picture)
           %returns the current pixel in the snap scaled to the 
           %current wanted pixel size
           if scale~=0
           transform =affine2d([(1+scale) ,0 ,0;0 ,(1+scale), 0; 0 0 1]);
           snapshot=imwarp(obj.Data(uint64(obj.D_W(1)):uint64(obj.A_W(1)-1),uint64(obj.D_W(2))-1:uint64(obj.C_W(2)-1)),transform,'OutputView', imref2d( size(reference_picture)));
           else
           snapshot=obj.Data(uint64(obj.D_W(1)):uint64(obj.A_W(1)-1),uint64(obj.D_W(2)):uint64(obj.C_W(2)-1));
           end


        end
        
        
    end
    
end

