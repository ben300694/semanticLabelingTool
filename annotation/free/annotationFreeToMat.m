function annotationFreeToMat(handles)

anno = handles.currentlyShownLabels;
save([handles.annoFreeDir, 'anno_free_', handles.imgId, '.mat'], 'anno');

end