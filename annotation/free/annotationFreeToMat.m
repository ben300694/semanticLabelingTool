function annotationFreeToMat(handles)

fullFileName = [handles.annoFreeDir, 'anno_free_', handles.imgId, '.mat'];

anno = handles.currentlyShownLabels;

% Create a backup copy of the annotation if it already exits
if exist(fullFileName, 'file')
    disp([fullFileName, ' already found, making a backup copy in the same folder.'])
    system(['cp', ' ', fullFileName, ' ', [fullFileName, '_backup']]);
end

save(fullFileName, 'anno');

end