function samexaxis(varargin)
%% helper function to clean up subplots that have common x axises
%
% USAGE: samexaxis([optionalarguments])
% 
% Optional arguments:
%   * YAxisLocation (default='left') : choose left,right, alternate or alternate2
%   * XAxisLocation (default='bottom') : choose bottom,top or both
%   * YLabelDistance (default=1.4)  
%   * Box (default='on')
%   * XTick
%   * XLim
%   * XTickLabel
%   * XMinorTick
%   * ABC : add a),b),c), ... to each sub plot
%   * Join: joins the subplots vertically
%   * YTickAntiClash: try to aviod yticklabel clashes (default=false)
%
%
% Example:
%   subplot(3,1,1); plot(randn(100,1),randn(100,1),'x'); ylabel('QF')
%   subplot(3,1,2); plot([-1 0 .5 1],[0 100 100 10],'x-'); ylabel('HT');
%   subplot(3,1,3); plot(randn(100,1),randn(100,1)*33,'x'); ylabel('DV');
%   samexaxis('abc','xmt','on','ytac','join','yld',1)
%
% ---
% (c) Aslak Grinsted 2005
%



Args=struct('YAxisLocation','left','XAxisLocation','bottom','Box','on','XLim',[],'XTick',[],'XTickLabel',[],'XMinorTick',[],'YLabelDistance',1.4,'ABC',false,'Join',false,'YTickAntiClash',false); 
Args=parseArgs(varargin,Args,{'abc' 'join' 'ytickanticlash'});



%--------------- Get all axis handles (that are not legends) ----------------
f=gcf;
ax=get(f,'children');

for ii=length(ax):-1:1
    if (~strcmpi(get(ax(ii),'type'),'axes'))|(strcmpi(get(ax(ii),'tag'),'legend'))
        ax(ii)=[];
    end
end
if numel(ax)<2
    error('samexaxis works on figures with more than one axis')
end

%---------------- apply xtick,xticklabel&xminortick ----------------
if ~isempty(Args.XTick)
    set(ax,'xtick',Args.XTick);
end
if ~isempty(Args.XTickLabel)
    set(ax,'xticklabel',Args.XTickLabel);
end
if ~isempty(Args.XMinorTick)
    set(ax,'xminortick',Args.XMinorTick);
end
if ~isempty(Args.XLim)
    set(ax,'XLim',Args.XLim);
end
set(ax,'box',Args.Box);

%---------------- sort ax by y top pos ------------------
pos=cell2mat(get(ax,'pos'));
ytop=pos(:,2)+pos(:,4);
[ytop,idx]=sortrows(-ytop);
ax=ax(idx);
pos=pos(idx,:);

if Args.Join
    H=(pos(1,2)+pos(1,4))-pos(end,2); %total height of axes
    Hused=sum(pos(:,4));
    stretch=max(H/Hused,1);
    pos(1,2)=pos(1,2)-pos(1,4)*(stretch-1);
    pos(:,4)=pos(:,4)*stretch;
    set(ax(1),'pos',pos(1,:));
    for ii=2:length(ax)
        pos(ii,2)=pos(ii-1,2)-pos(ii,4);
        set(ax(ii),'pos',pos(ii,:));
    end
end

%----------------- Set x&y axis positions ---------------------------
switch lower(Args.YAxisLocation)
    case {'alt' 'alternate' 'alt1' 'alternate1'}
        set(ax(1:2:end),'Yaxislocation','right');
        set(ax(2:2:end),'Yaxislocation','left');        
    case {'alt2' 'alternate2'}
            set(ax(1:2:end),'Yaxislocation','left');
        set(ax(2:2:end),'Yaxislocation','right');
    case {'left' 'right'}
        set(ax,'Yaxislocation',Args.YAxisLocation);
    otherwise
        warning('could not recognize YAxisLocation')
end

switch lower(Args.XAxisLocation)
    case 'top'
        set(ax(2:end),'xticklabel',[]);
        set(ax(1),'xaxislocation','top')
    case 'bottom'
        set(ax(1:(end-1)),'xticklabel',[]);
        set(ax(end),'xaxislocation','bottom')
    case 'both'
        set(ax(2:(end-1)),'xticklabel',[]);
        set(ax(end),'xaxislocation','bottom')
        set(ax(1),'xaxislocation','top')
    otherwise
        warning('could not recognize Xaxislocation')
end

%--------------- find common xlim and apply it to all -------------------
xlims=get(ax,'xlim');
xlim=[min([xlims{:}]) max([xlims{:}])];
set(ax,'xlim',xlim);

%---------make sure that ylabels doesn't jump in and out-----------
ylbl=get(ax,'ylabel');
ylbl=[ylbl{:}];
for ii=1:length(ylbl)
    if strcmpi(get(ylbl(ii),'interpreter'),'tex')
        txt=get(ylbl(ii),'string');
        txt=['^{ }' txt '_{ }'];
        set(ylbl(ii),'string',txt);
    end
end
set(ylbl,'units','normalized');
yisleft=strcmpi('left',get(ax,'yaxislocation'));


ylblpos=cell2mat(get(ylbl,'pos'));

set(ylbl(yisleft),'pos',[min(ylblpos(yisleft,1))*Args.YLabelDistance 0.5 0],'verticalalignment','bottom');
set(ylbl(~yisleft),'pos',[1+max(ylblpos(~yisleft,1)-1)*Args.YLabelDistance 0.5 0],'verticalalignment','top');

%--------------------- Anti yaxislabel clash: ------------------------------
if (Args.YTickAntiClash)&(length(strmatch(Args.YAxisLocation,{'left' 'right'}))>0)
    for ii=2:length(ax)
        if strcmpi(get(ax(ii),'ylimmode'),'auto') %only do it for axes that hasn't manual ylims 
            ytick=get(ax(ii),'ytick');
            ylim=get(ax(ii),'ylim');
            obymax=objbounds(ax(ii));
            obymax=obymax(4);

            dytick=ytick(end)-ytick(end-1);
            if (ylim(end)>(ytick(end)-dytick*.001))
                ylim(end)=ytick(end)-dytick*.00001;
                if ylim(end)<obymax
                    ylim(end)=ytick(end)+dytick*0.49999;
                end
            else
                ylim(end)=ytick(end)+dytick*0.49999;
            end
            set(ax(ii),'ylim',ylim,'xlim',xlim);
        end
    end
end



%---------------- add abc -------------------------
if Args.ABC
    for ii=1:length(ax)
        axes(ax(ii))
        text(0,1,[' ' 'a'+ii-1 ')'],'units','normalized','verticalalignment','top')
    end
end


try
    linkaxes(ax,'x');
catch
    warning('linkaxes only works in matlab7+')
end
