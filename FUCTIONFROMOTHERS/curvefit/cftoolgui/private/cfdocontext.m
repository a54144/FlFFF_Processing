function cfdocontext(varargin)
%CFDOCONTEXT Perform context menu actions for curve fitting tool

% Copyright 2001-2011 The MathWorks, Inc.
% $Revision: 1.7.2.10 $  $Date: 2012/08/20 23:53:20 $
import com.mathworks.toolbox.curvefit.*;

% Special action to create context menus
if isequal(varargin{1},'create')
   makecontextmenu(varargin{2});
   return
end

% Get information about what invoked this function
obj = gcbo;
action = get(obj,'Tag');
h = gco;
if isempty(h), return; end
hh = handle(h);
f = getfit(h);

% Set up variables that define some menu items
[~, styles, markers] = getmenuitems;
styles{end+1} = getString(message('curvefit:cftoolgui:style_none'));

switch action
 case {'fitcontext' 'datacontext'}
   % This code is triggered when we display the menu

   % Store a handle to the object that triggered this menu
   set(obj,'UserData',h);
   
   % Fix check marks on line width and line style cascading menus
   c = findall(obj,'Type','uimenu');
   set(c,'Checked','off');
   w = get(h,'LineWidth');
   u = findall(c,'flat','Tag',num2str(w));
   if ~isempty(u)
      set(u,'Checked','on');
   end
   w = get(h,'LineStyle');
   u = findall(c,'flat','Tag',w);
   if ~isempty(u)
      set(u,'Checked','on');
   end
   w = get(h,'Marker');
   u = findall(c,'flat','Tag',w);
   if ~isempty(u)
      set(u,'Checked','on');
   end
   
   % Add object name to some other menu items
   if isequal(get(h,'Tag'),'curvefit')
      f = getfit(h);
   elseif isequal(get(h,'Tag'),'cfdata')
      f = getds(h);
   else
      f = [];          % should not happen
   end
   if ~isempty(f)
       u = findall(c,'flat','Tag','hidecurve');
       if ~isempty(u)
          set( u,'Label', getString(message('curvefit:cftoolgui:menu_Hide', f.name )));
       end
       u = findall(c,'flat','Tag','deletefit');
       if ~isempty(u)
          set( u,'Label', getString(message('curvefit:cftoolgui:menu_Delete', f.name )));
       end
   end
   return

 % Remaining cases are triggered by selecting menu items
 case 'color'
   oldcolor = get(h,'Color');
   newcolor = uisetcolor(oldcolor);
   if ~isequal(oldcolor,newcolor)
      set(h,'Color',newcolor);
      if isa(hh,'cftool.boundedline') || isa(hh,'cftool.BoundedFitLine')
         set(get(hh,'BoundLines'),'Color',newcolor);

         % Change residuals as well
         ptype = cfgetset('residptype');
         if ~isequal(ptype,'none') && ~isempty(f) && ...
                                      ~isempty(f.rline) && ishandle(f.rline)
             set(f.rline,'Color',newcolor);
         end
      end
      cfgetset('dirty',true);   % session has changed since last save
   end

 case styles
   set(h,'LineStyle',action);

   % Change residuals as well
   ptype = cfgetset('residptype');
   if isa(hh,'cftool.boundedline') || isa(hh,'cftool.BoundedFitLine') 
      if isequal(ptype,'line') && ~isempty(f) && ...
                                  ~isempty(f.rline) && ishandle(f.rline)
         set(f.rline,'LineStyle',action);
      end
   end
   cfgetset('dirty',true);   % session has changed since last save

 case markers
   if isequal(action,'point')
      msize = 12;
   else
      msize = 6;
   end
   set(h,'Marker',action,'MarkerSize',msize);
   cfgetset('dirty',true);   % session has changed since last save

 % Either delete a fit, or a hide a fit or data set
 case {'hidecurve' 'deletefit'}
   isdataset = true;
   if isequal(get(h,'Tag'),'curvefit')
      f = getfit(h);
      isdataset = false;
   elseif isequal(get(h,'Tag'),'cfdata')
      f = getds(h);
   else
      return;          % should not happen
   end
   
   if isempty(f), return; end

   if isequal(action,'hidecurve')
      f.plot = 0;
      if ~isdataset
         FitsManager.getFitsManager.fitChanged(java(f));
      end
   else
      FitsManager.getFitsManager.deleteFits(java(f));
   end
   return

 % If the menu item is a number, it is a line width
 otherwise
   j = str2double(action);
   if ~isempty(j)
      set(h,'LineWidth',j);
      cfgetset('dirty',true);   % session has changed since last save
   end

   % Do not change residuals, wide lines will be too obtrusive
end

if isa(hh,'cftool.boundedline') || isa(hh,'cftool.BoundedFitLine')
   savelineproperties(f);
else
   ds = getds(hh);
   if ~isempty(ds)
      savelineproperties(ds);
   end
end


% ---------- get handle to fit object containing this line
function f = getfit(h)
f = [];
flist = cfgetallfits;
dh = double(h);
for j=1:length(flist)
   dl = double(flist{j}.line);
   if isequal(dl,dh)
      f = flist{j};
      return
   end
end

% ---------- get handle to dataset object for this line
function ds = getds(h)
ds = [];
dslist = cfgetalldatasets;
dh = double(h);
for j=1:length(dslist)
   dl = double(dslist{j}.line);
   if isequal(dl,dh)
      ds = dslist{j};
      return
   end
end

% ---------------------- helper to make context menu
function makecontextmenu(cffig)
%MAKECONTEXTMENU Creates context menu for curve fitting figure

% First create the context menu for fit curves
c = uicontextmenu('Parent',cffig,'Tag','fitcontext','Callback',@cfdocontext);
uimenu(c,'Label',getString(message('curvefit:cftoolgui:menu_Color')),'Tag','color','Callback',@cfdocontext);
uwidth = uimenu(c,'Label',getString(message('curvefit:cftoolgui:menu_LineWidth')),'Tag','linewidth');
ustyle = uimenu(c,'Label',getString(message('curvefit:cftoolgui:menu_LineStyle')),'Tag','linestyle');

% Get menu item labels and tags
[sizes styles markers slabels mlabels] = getmenuitems;

% Sub-menus for line widths
for i = 1:length(sizes)
   val = num2str(sizes(i));
   uimenu(uwidth,'Label',val,'Callback',@cfdocontext,'Tag',val);
end

% Sub-menus for line styles
for j=1:length(styles)
   uimenu(ustyle,'Label',slabels{j},'Callback',@cfdocontext,'Tag',styles{j});
end

% Create a similar context menu for data curves
cc = copyobj(c,cffig);
set(cc,'Tag','datacontext')

% Add items for fit menus only
uimenu(c,'Label',getString(message('curvefit:cftoolgui:menu_HideFit')),'Tag','hidecurve','Callback',@cfdocontext,...
       'Separator','on');
uimenu(c,'Label',getString(message('curvefit:cftoolgui:menu_DeleteFit')),'Tag','deletefit','Callback',@cfdocontext);

% Add items for data menus only
uimenu(cc,'Label',getString(message('curvefit:cftoolgui:menu_HideData')),'Tag','hidecurve','Callback',@cfdocontext,...
       'Separator','on');
umark = uimenu(cc,'Label',getString(message('curvefit:cftoolgui:menu_Marker')),'Tag','marker','Position',4);
for j=1:length(markers)
   uimenu(umark,'Label',mlabels{j},'Callback',@cfdocontext,'Tag',markers{j});
end

ustyle = findall(get(cc,'Children'),'Tag','linestyle');
uimenu(ustyle,'Label',getString(message('curvefit:cftoolgui:style_none')),'Callback',@cfdocontext,'Tag', 'none');


% -------------- helper to get menu item labels
function [sizes,styles,markers,slabels,mlabels] = getmenuitems
%GETMENUITEMS Get items for curve fitting context menus
sizes = [0.5 1 2 3 4 5 6 7 8 9 10];
styles = {'-' '--' ':' '-.'};
markers = {'+' 'o' '*' '.' 'x' 'square' 'diamond' ...
        'v' '^' '<' '>' 'pentagram' 'hexagram'};
slabels = {getString(message('curvefit:cftoolgui:style_solid')) ...
    getString(message('curvefit:cftoolgui:style_dash')) ...
    getString(message('curvefit:cftoolgui:style_dot')) ...
    getString(message('curvefit:cftoolgui:style_dashDot'))};
mlabels = {getString(message('curvefit:cftoolgui:marker_plus')) ...
    getString(message('curvefit:cftoolgui:marker_circle')) ...
    getString(message('curvefit:cftoolgui:marker_star')) ...
    getString(message('curvefit:cftoolgui:marker_point')) ...
    getString(message('curvefit:cftoolgui:marker_xMark')) ...
    getString(message('curvefit:cftoolgui:marker_square')) ...
    getString(message('curvefit:cftoolgui:marker_diamond')) ...
    getString(message('curvefit:cftoolgui:marker_triangleDown')) ...
    getString(message('curvefit:cftoolgui:marker_triangleUp')) ...
    getString(message('curvefit:cftoolgui:marker_triangleLeft')) ...
    getString(message('curvefit:cftoolgui:marker_triangleRight')) ...
    getString(message('curvefit:cftoolgui:marker_pentagram')) ...
    getString(message('curvefit:cftoolgui:marker_hexagram'))};
