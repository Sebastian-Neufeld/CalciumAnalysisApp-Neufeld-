function SaveROIs(dataPath, fileName, ROIsData)
% Saves ROIs and their corresponding data

ROIsPath = [dataPath, fileName, '_ROIsData.mat'];

% Just to make sure the already used ROI-characteristics are correct
rp = regionprops(ROIsData.ROIs,'Area');
ROIsData.sizes = [rp.Area];
ROIsData.nROIs = length(ROIsData.sizes);
%Now we need to take care what happens with traces / fits when ROIs are
%deleted later on?
    
save(ROIsPath, 'ROIsData')
    

    
end

