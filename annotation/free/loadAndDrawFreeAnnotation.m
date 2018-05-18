function handles = loadAndDrawFreeAnnotation(imgIdx, hObject, handles)

% Save current zoom settings
Limits = get(gca,{'xlim','ylim'});

% Reset the Canvas to just show the original image
currentCanvas = imshow(handles.img, 'Parent', handles.myCanvas);
set(currentCanvas, 'HitTest', 'off');
handles.currentlyShownLabels = [];

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId, ~] = fileparts(handles.imgName);

set(handles.stImgName, 'String', handles.imgId);
handles.fullImgPath = [handles.imgDir, handles.imgName];
handles.fullAnnoFreePath = [handles.annoFreeDir, 'anno_free_', handles.imgId, '.mat'];

if exist(handles.fullAnnoFreePath,'file') && exist(handles.fullImgPath,'file')
    
    A = load(handles.fullAnnoFreePath, 'anno');
    anno = A.anno;
    
    handles.currentlyShownLabels = anno;
    handles.freeAnnotationLabels = anno;
    
    msg = {'Image loaded', 'Free Annotation loaded'};
    set(handles.stStatus, 'String', msg);
    
    handles = drawAnnotationOverlay(hObject, handles, handles.currentlyShownLabels);
else
    disp('No Free Annotation File found, generate it first!');
end

% Restore old zoom settings
zoom reset
set(gca, {'xlim','ylim'}, Limits)

guidata(hObject, handles);

end