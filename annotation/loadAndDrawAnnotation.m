function handles = loadAndDrawAnnotation(imgIdx, hObject, handles)

% Reset the Canvas to just show the original image
handles.myCanvas = imshow(handles.img);
handles.currentlyShownLabels = [];

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId,~] = fileparts(handles.imgName);

set(handles.stImgName, 'String', handles.imgId);
fullImgPath = [handles.imgDir '/'  handles.imgName];
fullAnnoPath = [handles.annoDir '/'  handles.imgId '.mat'];

if exist(fullAnnoPath,'file') && exist(fullImgPath,'file')
    
    a = load(fullAnnoPath,'anno');
    anno = a.anno;
    handles.superPixels = anno;
    handles.readyToLabel = true;
    
    handles.currentlyShownLabels = handles.superPixels.labelImg;
    
    msg = {'Image loaded', 'Annotation loaded'};
    set(handles.stStatus, 'String', msg);
    
    handles = drawOverlay(hObject,handles);
else
    msg = 'No annotation found';
    set(handles.stStatus, 'String', msg);
    disp(msg);
end

guidata(hObject, handles);

end