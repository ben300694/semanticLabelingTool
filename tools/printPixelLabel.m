function printPixelLabel(src, eventdata, hObject)
disp('printPixelLabel was called.');

Position = get( ancestor(src, 'axes'), 'CurrentPoint' );
Button = get( ancestor(src, 'figure'), 'SelectionType' );
% hObject
% src
hfig = ancestor(src, 'figure'); % Get the handle to the figure
handles = guidata(hfig); % Get the handles struct

% disp(handles);

% hold on 
Position = int32(Position);
Point = Position(end,:);
% plot(Point(1),Point(2),'r+');
% hold off

Position = int32(Position);

if ~isempty(Position)

    Point = Position(end,:); % Only take first point (not sure why output argument consists of 2 points)

    if ~isempty(handles.currentlyShownLabels)
        pixelLabel = handles.currentlyShownLabels(Point(2),Point(1));
    
        if pixelLabel == 0
            pixelLabelClass = 'undefined';
        else
            pixelLabelClass = handles.colorNames{pixelLabel};
        end
        
        msg = {['Label of pixel at point ', ...
               '(', int2str(Point(2)), ', ', int2str(Point(1)), ')', ...
               ' is ', int2str(pixelLabel)], ...
               ['Class ', int2str(pixelLabel), ' is ', pixelLabelClass]
               };
        set(handles.stInfoStatus,'String',msg);
        % Console output
        disp(msg);
    else
        msg = {['Pixel at point ', ...
               '(', int2str(Point(2)), ', ', int2str(Point(1)), ')',...
               ' selected'], ...
               ['No labels are currently shown']};
        set(handles.stInfoStatus,'String',msg);
        % Console output
        disp(msg);
    end

else 
    msg = {'Point is empty' 'try again'};
    set(handles.stStatus,'String',msg);
end

end