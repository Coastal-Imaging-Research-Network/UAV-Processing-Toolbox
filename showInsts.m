function showInsts(I,insts,beta, globs)
%   showInsts(I,insts,beta, globals)
%
% plot instrument locations on an image to confirm that they are proper

figure(3); clf
imagesc(I)
hold on

for i = 1: length(insts)
    xyz = [insts(i).xyzAll];
    UV = findUVnDOF(beta,xyz, globs);
    UV = reshape(UV,[],2);
    plot(UV(:,1),UV(:,2),'.')
end
