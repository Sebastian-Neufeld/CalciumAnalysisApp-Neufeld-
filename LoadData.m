function [stack,stackInfo, ROIsData] = LoadData(dataPath, fileName)
% LoadData loads the .mat file with all experimental and computed data
% It seemed safer to define this process at one point and then just call
% this small function everytime needed

stackPath = [dataPath, fileName, '_stack.mat'];
stackInfoPath = [dataPath, fileName, '_stackInfo.mat'];
ROIsPath = [dataPath, fileName, '_ROIsData.mat'];

% Loads the variable directly into the workspace
load(stackPath,'stack');
load(stackInfoPath,'stackInfo');

% ROIsData only exist after the SegmentationGUI was used
if isfile(ROIsPath)
    load(ROIsPath, 'ROIsData')
else
    ROIsData = struct();
    ROIsData.sizes = [];
    ROIsData.nROIs = 0;
end


end

