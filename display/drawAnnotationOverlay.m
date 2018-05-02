function handles = drawAnnotationOverlay(hObject, handles, overlay)

% Save current zoom settings
Limits = get(gca,{'xlim','ylim'});

% Set labels to get correct pixel info
handles.currentlyShownLabels = overlay;

% Plot new Overlay
handles.myCanvas = imshow(handles.img);

hold on
    overlay_final = ind2rgb(overlay, handles.colors);
    overlay_final = uint8(overlay_final);
    handles.myCanvas = imshow(overlay_final);
    [m, n] = size(overlay);
    fullMask = ones(m, n);
    alphaMask = double(fullMask)*handles.alphaValue;
    set(handles.myCanvas, 'AlphaData', alphaMask);
hold off

% Restore old zoom settings
zoom reset
set(gca, {'xlim','ylim'}, Limits)

%imagesc(overlay)

end