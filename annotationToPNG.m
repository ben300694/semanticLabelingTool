function annotationToPNG(imgIdx, hObject, handles)

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId,~] = fileparts(handles.imgName);

set(handles.stImgName,'String',handles.imgId);
fullImgPath = [handles.imgDir '/'  handles.imgName];
fullAnnoPath = [handles.annoDir '/'  handles.imgId '.mat'];
fullAnnoPNGPath = [handles.annoPNGDir '/' 'anno_' handles.imgId '.png'];

if exist(fullAnnoPath,'file')
    a = load(fullAnnoPath,'anno');
    anno = a.anno;
    % Save labels as uint16 PNG
    imwrite(uint16(anno.labelImg), fullAnnoPNGPath);
    disp(['Annotation in PNG format written to ', fullAnnoPNGPath]);
    
    % Add new annotation to list of available training images
    fileID = fopen(handles.trainFile, 'a'); % Open file with permission to append
    fprintf(fileID, '%s', fullImgPath);
    fprintf(fileID, ' ');
    fprintf(fileID, '%s\n', fullAnnoPNGPath);
    fclose(fileID);

    guidata(hObject, handles);
else
   disp('No annotation found!');
end

end