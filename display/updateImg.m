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

disp(['Current handles.imgIdx is ', int2str(handles.imgIdx)])

% Save current zoom settings
if handles.databaseLoaded
    Limits = get(gca,{'xlim','ylim'});
end

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId,~] = fileparts(handles.imgName);

set(handles.stImgName,'String',handles.imgId);
fullImgPath = [handles.imgDir '/'  handles.imgName];
    
if exist(fullImgPath,'file')
    handles.img = imread(fullImgPath);
    handles.myCanvas = imshow(handles.img);
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