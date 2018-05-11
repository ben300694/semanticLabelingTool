function computeSegments(hObject,eventdata,handles)
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
    superPixels = getAllSuperpixels(handles.img,regionSize,regularizer);
    handles.myCanvas = imshow(superPixels.oversegImage);
    handles.superPixels = superPixels;
    set(handles.stStatus,'String','Done');
    handles.readyToLabel = true; % Set flag that image can be labels
    guidata(hObject, handles);  
else
    disp('No img found');
end

end