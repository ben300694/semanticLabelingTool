function drawOverlay(hObject,handles)
% Plot new Overlay
fullMask = im2bw(handles.superPixels.labelImg); % TODO: Check if image to bw is the right function here
handles.myCanvas = imshow(handles.superPixels.oversegImage);
hold on
overlay_final = ind2rgb(handles.superPixels.labelImg,handles.colors);
overlay_final = uint8(overlay_final);
handles.myCanvas = imshow(overlay_final);
alphaMask = double(fullMask)*0.7;
set(handles.myCanvas,'AlphaData',alphaMask);   
hold off
% guidata(handles.myCanvas, handles); 
guidata(hObject, handles);
end