load testAC_stack %stack
%stack = stack(50:100,60:110);
mask = zeros(size(stack));
[row, col] = find(stack==max(stack,[],'all'));
mask(row-5:row+5,col-5:col+5) = 1;

iters = [1,3,5,10,25,100];
ac = zeros([size(stack),length(iters)]);

for i = 1:length(iters)
    iter = iters(i);
    ac(:,:,i) = activecontour(stack,mask,iter);
end

%bounds
mask_bounds = bwboundaries(mask);
ac_bounds3 = bwboundaries(ac(:,:,3));
ac_bounds6 = bwboundaries(ac(:,:,6));

%ac_bounds_smooth   
acEnd = ac(:,:,end);
s = size(acEnd);
M = zeros(s);
for r = 2:s(1)-1
    for c = 2:s(2)-1
        if ac(r,c,end)>0
            M(r,c) = sum(acEnd(r+[-1;0;1], c+[-1;0;1])>0,'all');
        end
    end
end
acEnd(M<5) = 0;
ac_bounds_smooth   = bwboundaries(acEnd);

%fig stuff
figure('Name','Mask')
hold on
imagesc(stack,'AlphaData', 0.6);
plot(mask_bounds{1}(:,2), mask_bounds{1}(:,1), ...
	'Color', [0 0 0]);    

figure('Name','IT3')
hold on
imagesc(stack,'AlphaData', 0.6);
plot(ac_bounds3{1}(:,2), ac_bounds3{1}(:,1), ...
    'Color', [0 0 0]);    

figure('Name','IT6')
hold on
imagesc(stack,'AlphaData', 0.6);
plot(ac_bounds6{1}(:,2), ac_bounds6{1}(:,1), ...
    'Color', [0 0 0]);    


figure('Name','smooth')
hold on
imagesc(stack,'AlphaData', 0.6);
plot(ac_bounds_smooth{1}(:,2), ac_bounds_smooth{1}(:,1), ...
    'Color', [0 0 0]);   
