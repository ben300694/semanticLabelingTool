function handles = updateImg(imgIdx, hObject, handles)

% if (~handles.isSaved) % Check if previous modifications have been saved
%    selection = questdlg('Save new Annotations?',...
%                         'Save new Annotations?',...
%                         'Yes','No','Yes');
% 
%    switch selection,
%       case 'Yes',
%          annotationToMat(handles)
%       case 'No'
%    end
% end

% Save current zoom settings
if handles.databaseLoaded
    Limits = get(gca,{'xlim','ylim'});
end

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId,~] = fileparts(handles.imgName);

disp(['Current handles.imgIdx is ', int2str(handles.imgIdx)])

set(handles.stImgName, 'String', handles.imgId);
fullImgPath = [handles.imgDir, handles.imgName];

% Update the values in the table in GUI_imageMetadata
updateMetadata(fullImgPath, hObject, handles);

if exist(fullImgPath,'file')
    handles.img = imread(fullImgPath);
    % disp(handles)
    imshow(handles.img, 'Parent', handles.myCanvas);
    handles.currentlyShownLabels = [];
    handles.readyToLabel = false;
    msg = {'Image loaded', 'No annotation loaded'};
    set(handles.stStatus, 'String', msg);
else
    disp('No image found');
end

% Restore old zoom settings
if handles.databaseLoaded
    zoom reset;
    set(gca, {'xlim','ylim'}, Limits);
end
    
guidata(hObject, handles);

end