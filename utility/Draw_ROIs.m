
%usage 
%  Draw_ROIs(data,Class_List)
% data is a M X N X P matrix indicating P scenes of size M X N.
% Class_List = 'Cloud|Dust'; % It shows the List of Classes
% When the save button is clicked the result is saved as mat file of size M X N X P
 
function Draw_ROIs(data,Class_List)
global  img h h1 h2 h3 res band clas ;

img = data;
clear data
sz=size(img);
res = zeros(sz);
nl=sz(1);
np=sz(2);
nb=sz(3);
band = 1;
clas = 1;
 %change this 
h=figure('MenuBar','none');
set(h,'CloseRequestFcn',@my_closefcn)

imagesc(img(:,:,band));
axis off, axis image
    title(strcat('Layer number : ',num2str(1)));

    % Create a uicontrol object to let users change the colormap
    % with a pop-up menu. Supply a function handle as the object's 
    % Callback:
    uicontrol('Style', 'popup',...
           'String', 'jet|hsv|hot|cool|gray',...
           'Position', [0 -30 100 50],...
           'Callback', @setmap);       % Popup function handle callback
                                       % Implemented as a subfunction
   % Add a slider uicontrol to control the vertical scaling of the
    % surface object. Position it under the Clear button.
   h1= uicontrol('Style', 'slider',...
        'Min',1,'Max',nb,'Value',1,...
        'Position', [240 0 100 20],'SliderStep',[1,1]/nb,...
        'Callback', {@imgzlim});   % Slider function handle callback
                                        % Implemented as a subfunction  
  uicontrol('Style', 'popup',...
           'String', Class_List,...
           'Position', [120 -30 100 50],...
           'Callback', @setclass);       % Popup function handle callback
       
       
    % Add a different uicontrol. Create a push button that saves the rois 
    % when pressed. Position the button inside
    % the axes at the lower left. All uicontrols have default units
    % of pixels. In this example, the axes does as well.
    h2 = uicontrol('Style', 'radiobutton', 'String', 'Draw',...
        'Position', [360 0 50 20],...
        'Callback', @drawroi);        % Pushbutton string callback
                                   % that calls a MATLAB function                                    % Implemented as a subfunction                                    
    h3 = uicontrol('Style', 'pushbutton', 'String', 'Save',...
        'Position', [480 0 50 20],...
        'Callback', @saveroi);                                    
                                      
end
    

% callback functions
function setmap(hObj,event) %#ok<INUSD>
    % Called when user activates popup menu of colormap
    val = get(hObj,'Value');
    if val ==1
        colormap(jet)
    elseif val == 2
        colormap(hsv)
    elseif val == 3
        colormap(hot)
    elseif val == 4
        colormap(cool)
    elseif val == 5
        colormap(gray)
    end
end


function setclass(hObj,event) %#ok<INUSD>
    % Called when user activates popup menu of class
   global clas
    clas = get(hObj,'Value');
       
end

function imgzlim(hObj,event) %#ok<INUSL>
    % Called to set the layer number of the image 
    % when user moves the slider control 
    
    global img h band;
    band = round(get(hObj,'Value'));
    figure(h),imagesc(img(:,:,band)), axis off, axis image
    title(strcat('Layer number : ',num2str(band)));
   % set(h,'String',num2str(val));
end

function saveroi(hObject,eventdata)
%%%% save the map
global res
filename = uiputfile('.mat','Select File to Save');  % saving as .mat file
if filename==0
    return
end
% t = Tiff(filename,'w');
% sz = size(res);
% 
% tagstruct.ImageLength = sz(1);
% tagstruct.ImageWidth = sz(2);
% tagstruct.Photometric = Tiff.Photometric.RGB;
% tagstruct.BitsPerSample = 8;
% tagstruct.SamplesPerPixel = sz(3);
% tagstruct.RowsPerStrip = 16;
% tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
% tagstruct.Software = 'MATLAB';
% t.setTag(tagstruct);
% 
% t.write(res);
%multibandwrite(uint8(res), filename, 'bsq');
save(filename, 'res');
end


function drawroi(hObject,eventdata)
%%%% save the map
global clas res hh band;

button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	% Toggle button is pressed-take appropriate action
   hh = impoly;
%position = wait(hh);

if clas == 1
    setColor(hh,'red');
else
    setColor(hh,'green');
end

ss = createMask(hh);
res(:,:,band) = res(:,:,band) + clas*ss;

set(hObject,'Value',0);

elseif button_state == get(hObject,'Min')
	% Toggle button is not pressed-take appropriate action
    %if hh is empty delete it
    delete(hh)
end



end

function my_closefcn(hObject,eventdata)

delete(hObject);
clear all
end