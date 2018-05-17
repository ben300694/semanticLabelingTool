function handles = loadAndDrawSuperpixelsAnnotation(imgIdx, hObject, handles)

% Reset the Canvas to just show the original image
imshow(handles.img, 'Parent', handles.myCanvas);
handles.currentlyShownLabels = [];

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId,~] = fileparts(handles.imgName);

set(handles.stImgName, 'String', handles.imgId);
fullImgPath = [handles.imgDir '/'  handles.imgName];
fullAnnoPath = [handles.annoSuperpixelsDir '/'  handles.imgId '.mat'];

if exist(fullAnnoPath,'file') && exist(fullImgPath,'file')
    
    a = load(fullAnnoPath,'anno');
    anno = a.anno;
    handles.superPixels = anno;
    handles.readyToLabel = true;
    
    handles.currentlyShownLabels = handles.superPixels.labelImg;
    
    msg = {'Image loaded', 'Annotation loaded'};
    set(handles.stStatus, 'String', msg);
    
    handles = drawSuperpixelOverlay(hObject,handles);
else
    msg = 'No annotation found';
    set(handles.stStatus, 'String', msg);
    disp(msg);
end

guidata(hObject, handles);

end