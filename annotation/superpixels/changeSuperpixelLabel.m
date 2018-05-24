function changeSuperpixelLabel(src, eventdata, hObject)

Position = get( ancestor(src,'axes'), 'CurrentPoint' );
Button = get( ancestor(src,'figure'), 'SelectionType' );
% hObject
% src
hfig = ancestor(src, 'figure'); % Get the handle to the figure
handles = guidata(hfig); % Get the handles struct

% hold on 
Position = int32(Position);
Point = Position(end,:);
% plot(Point(1),Point(2),'r+');
% hold off

Position = int32(Position);

if ~isempty(Position)

    Point = Position(end,:); % Only take first point (not sure why output argument consists of 2 points)

    spImg = handles.superPixels.superPixelImg;
    superPixelId = spImg(Point(2),Point(1));
    labelImg = handles.superPixels.labelImg;
    overlayMask = (spImg == superPixelId);

    labelImg(overlayMask) = handles.selectedLabel; % Colorize selected polygon
    handles.superPixels.labelImg = labelImg; % Update the overlay
    handles.isSaved = false; % Prompt user to save image

    
    % Plot new Overlay
    handles = drawSuperpixelOverlay(hObject, handles);
    
    

    % Have to set the ButtonDownFcn again 
    % because a plot clears the objects properties
    set(handles.myCanvas, 'ButtonDownFcn', @(src,eventdata)changeSuperpixelLabel(src,eventdata,hObject));    
        
    msg = {'Please hit ''Save''' 'to store modifications'};
    set(handles.stStatus, 'String', msg);

else 
    msg = {'Point is empty' 'try again'};
    set(handles.stStatus, 'String', msg);
end

guidata(hObject, handles)

end