function annotationToPNG(imgIdx, hObject, handles)

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId,~] = fileparts(handles.imgName);

set(handles.stImgName, 'String', handles.imgId);
fullImgPath = [handles.imgDir '/'  handles.imgName];
% fullAnnoPath = [handles.annoDir '/'  handles.imgId '.mat'];
fullAnnoPNGPath = [handles.annoPNGDir '/' 'anno_' handles.imgId '.png'];

% if exist(fullAnnoPath,'file')
    % a = load(fullAnnoPath,'anno');
    % anno = a.anno;
    % Save labels as uint8 PNG
    imwrite(uint8(handles.currentlyShownLabels), fullAnnoPNGPath);
    disp(['Annotation in PNG format written to ', fullAnnoPNGPath]);
    
    % Add new annotation to list of available training images
    fileID = fopen(handles.trainFile, 'a'); % Open file with permission to append
    fprintf(fileID, '%s', ['/images', '/', handles.imgName]);
    fprintf(fileID, ' ');
    fprintf(fileID, '%s\n', ['/annotations_PNG', '/', 'anno_', handles.imgId, '.png']);
    fclose(fileID);

    guidata(hObject, handles);
% else
%   disp('No annotation found!');
% end

end