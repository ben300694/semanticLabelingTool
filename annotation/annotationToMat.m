function annotationToMat(handles)

anno = handles.superPixels;
save([handles.annoDir '/'  handles.imgId '.mat'], 'anno');

end