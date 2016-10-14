function data = sampleDJIFrame(insts, I, beta, globs)
%   data = sampleDJIFrame(insts, I, beta, globs);
%
%  samples pixels from a grayshade frame, I, at pixels that are determined
%  by the instrument descriptions in insts, created by makeDJIInsts
U = 1:globs.lcp.NU;
V = 1:globs.lcp.NV;
for i = 1: length(insts)
    data(i).I = nan(1,size(insts(i).xyzAll,1));
    UV = round(findUVnDOF(beta,insts(i).xyzAll,globs));
    UV = reshape(UV,[],2);
    good = find(onScreen(UV(:,1),UV(:,2),globs.lcp.NU,globs.lcp.NV));
    ind = sub2ind([globs.lcp.NV globs.lcp.NU],UV(good,2),UV(good,1));
    data(i).I(good) = I(ind);
end
            