function computeSegments(hObject,eventdata,handles)

disp('Calling computeSegments');

imgIdx = handles.imgIdx;
handles.imgName = handles.filelist{imgIdx};

fullImgPath = [handles.imgDir '/'  handles.imgName];
fullAnnoPath = [handles.annoSuperpixelsDir '/'  handles.imgId '.mat'];

if exist(fullAnnoPath,'file')
    warning('Existing Annotation will be overwritten')
end
if exist(fullImgPath,'file')
    handles.img = imread(fullImgPath);
    
    % Compute superPixels
    set(handles.stStatus,'String','Wait...');
    drawnow;
    regionSize = handles.regionSize;
    regularizer = handles.regularizer;
    disp('Calling getAllSuperpixels');
    superPixels = getAllSuperpixels(handles.img,regionSize,regularizer);
    disp('getAllSuperpixels returned');
    currentCanvas = imshow(superPixels.oversegImage, 'Parent', handles.myCanvas);
    set(currentCanvas, 'HitTest', 'off');
    handles.superPixels = superPixels;
    set(handles.stStatus,'String','Done');
    
    handles.readyToLabel = true; % Set flag that image can be labeled
    guidata(hObject, handles);
else
    disp('No img found');
end

end