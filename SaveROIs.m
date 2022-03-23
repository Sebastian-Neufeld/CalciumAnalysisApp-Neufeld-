function SaveROIs(dataPath, fileName, ROIsData)
% Saves ROIs and their corresponding data

ROIsPath = [dataPath, fileName, '_ROIsData.mat'];

% So if the user deltes all ROIs there won´t be any remnants of the struct
% which could interfere with some functions/Checks
if ROIsData.nROIs == 0
    delete(ROIsPath)
else
    % Just to make sure the already used ROI-characteristics are correct
    rp = regionprops(ROIsData.ROIs,'Area');
    ROIsData.sizes = [rp.Area];
    ROIsData.nROIs = length(ROIsData.sizes);
    %Now we need to take care what happens with traces / fits when ROIs are
    %deleted later on?

    save(ROIsPath, 'ROIsData')
end
    

    
end

