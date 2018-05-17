function handles = drawSuperpixelOverlay(hObject, handles)

% Save current zoom settings
Limits = get(gca,{'xlim','ylim'});

% Set labels to get correct pixel info
handles.currentlyShownLabels = handles.superPixels.labelImg;

% Plot new Overlay
fullMask = im2bw(handles.superPixels.labelImg); % TODO: Check if image to bw is the right function here

imshow(handles.superPixels.oversegImage, 'Parent', handles.myCanvas);

hold on
    overlay_final = ind2rgb(handles.superPixels.labelImg, handles.colors);
    overlay_final = uint8(overlay_final);
    currentCanvas = imshow(overlay_final, 'Parent', handles.myCanvas);
    alphaMask = double(fullMask)*handles.alphaValue;
    set(currentCanvas, 'AlphaData', alphaMask);   
hold off

% Restore old zoom settings
zoom reset
set(gca, {'xlim','ylim'}, Limits)

end