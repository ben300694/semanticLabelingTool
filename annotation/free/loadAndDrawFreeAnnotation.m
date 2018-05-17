function handles = loadAndDrawFreeAnnotation(imgIdx, hObject, handles)

% Save current zoom settings
Limits = get(gca,{'xlim','ylim'});

% Reset the Canvas to just show the original image
imshow(handles.img, 'Parent', handles.myCanvas);
handles.currentlyShownLabels = [];

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId, ~] = fileparts(handles.imgName);

set(handles.stImgName, 'String', handles.imgId);
fullImgPath = [handles.imgDir, handles.imgName];
fullAnnoPath = [handles.annoFreeDir, 'anno_free_', handles.imgId, '.mat'];

if exist(fullAnnoPath,'file') && exist(fullImgPath,'file')
    
    A = load(fullAnnoPath, 'anno');
    anno = A.anno;
    
    handles.currentlyShownLabels = anno;
    handles.freeAnnotationLabels = anno;
    
    msg = {'Image loaded', 'Free Annotation loaded'};
    set(handles.stStatus, 'String', msg);
    
    fullMask = im2bw(int16(anno));
      
    hold on
        overlay_final = ind2rgb(anno, handles.colors);
        overlay_final = uint8(overlay_final);
        currentCanvas = imshow(overlay_final, 'Parent', handles.myCanvas);
        alphaMask = double(fullMask)*handles.alphaValue;
        set(currentCanvas, 'AlphaData', alphaMask);   
    hold off
else
    disp('No Free Annotation File found, generate it first!');
end

% Restore old zoom settings
zoom reset
set(gca, {'xlim','ylim'}, Limits)

guidata(hObject, handles);

end