function  plot2pictures( T,I,snippet_or_data)
%plot2pictures function to plot pictures of the Picture object
%   T original object
%   I warped object
%   snippet_or_data if snippet -> plots just snippet if data -> plots just Data 
if isequal(snippet_or_data,'data')
reference_objectT=imref2d(size(T.Data),[-1 1],[-1,1]);
reference_objectI=imref2d(size(I.Data),[-1 1],[-1,1]);
f = figure;
p = uipanel('Parent',f,'BorderType','none'); 
subplot(1,2,1,'Parent',p) 
imshow(T.Data,T.reference_object_entire)
title('T') 
subplot(1,2,2,'Parent',p)
imshow(I.Data,I.reference_object_entire)
title('I') 
elseif isequal(snippet_or_data,'snippet')
reference_objectT=imref2d(size(T.Data_snippet),[-1 1],[-1,1]);
reference_objectI=imref2d(size(I.Data_snippet),[-1 1],[-1,1]);
f = figure;
p = uipanel('Parent',f,'BorderType','none'); 
subplot(1,2,1,'Parent',p) 
imshow(T.Data_snippet,T.reference_object_snippet)
title('T') 
subplot(1,2,2,'Parent',p)
imshow(I.Data_snippet,I.reference_object_snippet)
title('I') 
    
end

end

