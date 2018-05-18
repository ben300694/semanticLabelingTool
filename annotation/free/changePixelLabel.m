function changePixelLabel(src, eventdata, hObject)
disp('changePixelLabel was called.');

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

    if ~isempty(handles.currentlyShownLabels)
        msg = {['Pixel at point ', ...
               '(', int2str(Point(2)), ', ', int2str(Point(1)), ')',...
               ' selected']};
        set(handles.stInfoStatus,'String',msg);
        
        % Get currently selected label
        indName = get(get(handles.Labels, 'SelectedObject'), 'String');
        ind = find(ismember(handles.colorNames, indName)); % Get ind corresponding to color / label
        handles.selectedLabel = ind;
        
        handles.currentlyShownLabels(Point(2),Point(1)) = handles.selectedLabel;
        handles.freeAnnotationLabels(Point(2),Point(1)) = handles.selectedLabel;

        % Update the overlay
        handles = drawAnnotationOverlay(hObject, handles, handles.freeAnnotationLabels);

        set(handles.myCanvas, 'Visible', 'on');
        set(handles.myCanvas, 'PickableParts', 'all');
        % Have to set the ButtonDownFcn again 
        % because a plot clears the objects properties
        set(handles.myCanvas, 'ButtonDownFcn', @(src,eventdata)changePixelLabel(src,eventdata,hObject));    

        % Prompt user to save image
        handles.isSaved = false;
        msg = {'Please hit ''Save''' 'to store modifications'};
        set(handles.stStatus, 'String', msg);
    else
        msg = {['Pixel at point ', ...
               '(', int2str(Point(2)), ', ', int2str(Point(1)), ')',...
               ' selected'], ...
               ['No labels are currently shown']};
        set(handles.stInfoStatus,'String',msg);
    end

else 
    msg = {'Point is empty' 'try again'};
    set(handles.stStatus, 'String', msg);
end

guidata(hObject, handles)

end