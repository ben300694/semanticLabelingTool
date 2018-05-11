function annotationSuperpixelsToMat(handles)

anno = handles.superPixels;
save([handles.annoSuperpixelsDir '/'  handles.imgId '.mat'], 'anno');

end