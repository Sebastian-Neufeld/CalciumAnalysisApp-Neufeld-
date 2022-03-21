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
        % Conversion to int is important as the matrices are uint and a 
        % difference between 2 uints will always be positive (absolute).
        % Range uin16 = [ 0 2^16-1] (65535), int16 would only have [0 2^15-1] (32767).
        % As no physiological value should be in that range we could "only"
        % use int16 for the conversion, but then the whole stack should be
        % saved as int16 and not only this step. This can be decided
        % another day :D
        stackDiff = int32(stack(:,:,badFrames(i) + 1)) - ...
                    int32(stack(:,:,badFrames(i) - contBF)); 
        for f = 1:contBF
            % Converting from to int32 is necessary to calculate the
            % stack+stackDiff. then reverting back to uint16 ensures we
            % still have the same datatype in the stack.
            % (contBF+1 is important as for a single bad frame f = 1 contBF = 1 --> the whole dif is added instead of half, with f = 1 and f = 2 for contBF = 2 it will be 1/(2+1) and 2(/(2+1) so 1/3 and 2/3.
            stack(:,:,badFrames(i) - contBF + f) = ...
                uint16(int32(stack(:,:,badFrames(i) - contBF)) + stackDiff*f/(contBF+1)); 
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