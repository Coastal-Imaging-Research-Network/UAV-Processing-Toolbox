function h = geomplot(no_axes_ver,no_axes_hor,pos_ver,pos_hor,width,axis_ver,marg_hor,marg_ver,gaps)

%function geomplot(no_axes_ver,no_axes_hor,pos_ver,pos_hor,width,axis_ver,marg_hor,marg_ver,gaps)

set(gcf,'units','centimeters')
axis_hor = (width-(no_axes_hor-1)*gaps(1)-marg_hor(1)-marg_hor(2))/no_axes_hor;
height = axis_ver*no_axes_ver+(no_axes_ver-1)*gaps(2)+marg_ver(1)+marg_ver(2);
disp(['Calculated height of figure is ' num2str(height) ' cm'])
set(gcf,'paperposition',[0 0 width height])
set(gcf,'position',[0 0 width height])

%Plot result
h = subplot('position',[(marg_hor(1)+(pos_hor-1)*(axis_hor+gaps(1)))/width (height-(marg_ver(1)+pos_ver*axis_ver+(pos_ver-1)*gaps(2)))/height axis_hor/width axis_ver/height]);