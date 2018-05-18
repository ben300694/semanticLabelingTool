function handles = drawAnnotationOverlay(hObject, handles, overlay)

% Save current zoom settings
Limits = get(gca, {'xlim','ylim'});

% Set labels to get correct pixel info
handles.currentlyShownLabels = overlay;

% Plot new Overlay
currentCanvas = imshow(handles.img, 'Parent', handles.myCanvas);
set(currentCanvas, 'HitTest', 'off');

hold on
    overlay_final = ind2rgb(overlay, handles.colors);
    overlay_final = uint8(overlay_final);
    currentCanvas = imshow(overlay_final, 'Parent', handles.myCanvas);
    set(currentCanvas, 'HitTest', 'off');
    [m, n] = size(overlay);
    fullMask = ones(m, n);
    alphaMask = double(fullMask)*handles.alphaValue;
    set(currentCanvas, 'AlphaData', alphaMask);
hold off

set(handles.myCanvas, 'Visible', 'on');
set(handles.myCanvas, 'PickableParts', 'all');

% Restore old zoom settings
zoom reset
set(gca, {'xlim','ylim'}, Limits)

%imagesc(overlay)

end