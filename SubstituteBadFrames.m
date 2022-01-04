% This functions needs to be public to load "previous
% configurations" of similar files, e.g. UGpLG / URpLR
function [stack, stackInfo] = SubstituteBadFrames(stack, stackInfo, badFrames, dataPath, fileName)
wb = waitbar(0,'Please wait while substituting bad frames');
% specifies how many continous frames are badFrames, 1 means a
% single one
contBF = 1;
% Specifies if frames should be substituted. As long there are
% continous ones, the functions goes further and just counts
% how many. Once the next one is not continous (diffBFT >1),
% substitution takes place
substitute = false;

% so we know how far we already iterated through badFrames
i = 1;
while i <= length(badFrames)
    % For length = 1, "badFrames(i +/- 1)" won´t work
    if length(badFrames) > 1
        % true on last element of badFrames, but if the last n
        % badFrames are continous the extra if is needed
        if i == length(badFrames)
            substitute = true;
            if badFrames(i) == badFrames(i-1) + 1
                contBF = contBF+1;
            end
        elseif badFrames(i+1)-badFrames(i) == 1
            contBF = contBF +1;
        else
            substitute = true;
        end
    else
        substitute = true;
    end

    if substitute == true
        substitute = false;
        % We want the difference of the last ok and the next ok frame,
        % if badFrames = [51,52,53] then badFrames(i) will be 53 when
        % this "if" is entered, contBF starts at 1 and is incremented
        % twice (at 52 and 53 as they are only 1 frame apart) so the
        % stack Dif is frame 53-3 = 50 up to 53+1 = 54 and 50 and 54 are
        % ok if 51,52,53 are bad - So we can calculate meaningful
        % "intermediate frames"
        stackDiff = stack(:,:,badFrames(i) + 1) - ...
                    stack(:,:,badFrames(i) - contBF);
        for f = 1:contBF
            stack(:,:,badFrames(i) - contBF + f) = ...
                stack(:,:,badFrames(i) - contBF) + stackDiff*f/contBF;
        end
        contBF = 1;
    end
i = i + 1;
end
stackInfo.substitutedFrames = unique([stackInfo.substitutedFrames;badFrames]);
waitbar(0.2,wb)
% Saves the stack, which edits the stackInfo aswell, but
% outputs the new stackInfo aswell, so we don´t have to load it
% again
stackInfo = SaveStack(dataPath, fileName, stack, stackInfo);
waitbar(1,wb)
close(wb)