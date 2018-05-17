function handles = drawAnnotationOverlay(hObject, handles, overlay)

% Save current zoom settings
Limits = get(gca, {'xlim','ylim'});

% Set labels to get correct pixel info
handles.currentlyShownLabels = overlay;

% Plot new Overlay
imshow(handles.img, 'Parent', handles.myCanvas);

hold on
    overlay_final = ind2rgb(overlay, handles.colors);
    overlay_final = uint8(overlay_final);
    currentCanvas = imshow(overlay_final, 'Parent', handles.myCanvas);
    [m, n] = size(overlay);
    fullMask = ones(m, n);
    alphaMask = double(fullMask)*handles.alphaValue;
    set(currentCanvas, 'AlphaData', alphaMask);
hold off

% Restore old zoom settings
zoom reset
set(gca, {'xlim','ylim'}, Limits)

%imagesc(overlay)

end