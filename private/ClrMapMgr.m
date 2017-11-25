function this = ClrMapMgr()
%CLRMAPMGR Color map manager.
%
%   H = CLRMAPMGR
%
%   H is a structure of function handles providing access to the following
%   functions:
%
%     addClrMap(name,rgb)   adds a color map specified by a name and an
%                           N-by-3 array of rgb values.
%
%     cmap = getClrMap()    returns the currently selected color map as a
%                           a structure with the fields 'name' and 'rgb'.
%
%     rgb = getClrMapRgb()  returns an N-by-3 array of rgb values
%                           corresponding the currently selected color map.
%
%     setClrMap(name)       sets the current color map by name.
%
%     prev()                selects the previous color map (wrt the position
%                           of the current one in the list of color maps).
%
%     next()                selects the next     color map (wrt the position
%                           of the current one in the list of color maps).
%
%     size()                returns the number of available color maps.
%
%     cmaps = getClrMaps()  returns the available color maps as a cell array
%                           of structures with the fields 'name' and 'rgb'.
%
%   Author: Kristian Loewe

cmaps = {};
cmapSel = 1;

% add color maps
addClrMap('gray',      gray(64));
addClrMap('gray_ud',   flipud(gray(64)));
addClrMap('bone',      bone(64));
addClrMap('copper',    copper(64));
addClrMap('pink',      pink(64));
addClrMap('spring',    spring(64));
addClrMap('summer',    summer(64));
addClrMap('autumn',    autumn(64));
addClrMap('winter',    winter(64));
addClrMap('hot',       hot(64));
addClrMap('cool',      cool(64));
if ~verLessThan('matlab', '8.4')
  addClrMap('parula',  parula(64));
end
addClrMap('jet',       jet(64));
addClrMap('hsv',       hsv(64));
addClrMap('lines',     lines(64));
addClrMap('colorcube', colorcube(64));
addClrMap('prism',     prism(64));
addClrMap('flag',      flag(64));
addClrMap('br',        [0 0 1; 1 0 0]);
addClrMap('rb',        [1 0 0; 0 0 1]);
addClrMap('by',        [0 0 1; 1 1 0]);
addClrMap('yb',        [1 1 0; 0 0 1]);

%% function handles
this = struct;
this.addClrMap    = @addClrMap;
this.setClrMap    = @setClrMap;
this.getClrMap    = @getClrMap;
this.getClrMapRgb = @getClrMapRgb;
this.prev         = @prev;
this.next         = @next;
this.size         = @size;
this.getClrMaps   = @getClrMaps;


%% nested functions

  function addClrMap(name,rgb)
    cmaps{end+1} = struct('name', name, 'rgb', rgb);
  end

  function setClrMap(cmap)
    % setClrMap(name)
    % setClrMap(cmap)
    % setClrMap(rgb)
    % setClrMap(idx)
    
    if ischar(cmap)                               % setClrMap(name)
      idx = cellfun(@(c) strcmp(c.name, cmap), cmaps);
      idx = find(idx);
      assert(~isempty(idx), 'Unknown color map');
    elseif isnumeric(cmap)
      if isscalar(cmap)                           % setClrMap(idx)
        idx = cmap;
        assert(idx >= 1 && idx <= numel(cmaps));
      elseif ismatrix(cmap) && size(cmap,2) == 3  % setClrMap(rgb)
        idx = cellfun(@(c) isequal(c.rgb, cmap), cmaps);
        if isempty(idx)
          cmaps{end+1} = struct('name', 'custom', 'rgb', cmap);
          idx = numel(cmaps);
        else
          idx = find(idx);
        end
      else
        error('Unexpected value for cmap.');
      end
    elseif isstruct(cmap) ...                     % setClrMap(cmap)
        && all(isfield(cmap, {'name','rgb'}))
       idx = cellfun(@(c) isequal(c, cmap), cmaps);
       if isempty(idx)
        cmaps{end+1} = cmap;
        idx = numel(cmaps);
       else
         idx = find(idx);
       end
    else
      error('Unexpected value for cmap.');
    end
    assert(isscalar(idx));
    cmapSel = idx;
  end

  function cmap = getClrMap()
    cmap = cmaps{cmapSel};
  end

  function rgb = getClrMapRgb()
    cmap = this.getClrMap();
    rgb = cmap.rgb;
  end

  function prev()
    cmapSel = mod(cmapSel-2, this.size()) + 1;
  end

  function next()
    cmapSel = mod(cmapSel, this.size()) + 1;
  end

  function n = size()
    n = numel(cmaps);
  end

  function c = getClrMaps()
    c = cmaps;
  end
end
