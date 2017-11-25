function this = ClrBar(hp,pos,rgb)
%CLRBAR Custom horizontal color bar.
%
%   H = CLRBAR(HP,POS,RGB)
%
%   H is a structure of function handles providing access to the following
%   functions:
%
%     getAxes()
%     getImage()
%     setColorMap(rgb)
%     setButtonDownFcn(fcn)
%     setEnabled(b)
%     setVisible(b)
%
%   HP   parent handle
%   POS  pixel position (relativ to parent)
%   RGB  N-by-3 array of rgb values
%
%   Example:
%
%     hf = figure;
%     p = getpixelposition(hf);
%     hcb = ClrBar(hf, [5 5 p(3)-10 32], parula(256));
%
%   Author: Kristian Loewe

assert(ismatrix(rgb) && size(rgb,1) > 0 && size(rgb,2) == 3);

hAx = [];
hIm = [];
bdfcn = [];
visible = 'on';

hAx = axes(...
  'Parent',   hp, ...
  'Units',    'pixels', ...
  'Position', pos, ...
  'Visible',  'off');

setColormap(rgb);

%% function handles
this = struct;
this.setColormap      = @setColormap;
this.setButtonDownFcn = @setButtonDownFcn;
this.getAxes          = @getAxes;
this.getImage         = @getImage;
this.setEnabled       = @setEnabled;
this.setVisible       = @setVisible;


%% nested functions

  function h = getAxes()
    h = hAx;
  end

  function h = getImage()
    h = hIm;
  end

  function setColormap(rgb)
    assert(ismatrix(rgb) && size(rgb,1) > 0 && size(rgb,2) == 3);

    hIm = image(reshape(rgb, [1 size(rgb,1) 3]), ...
      'Parent',        hAx, ...
      'Visible',       visible, ...
      'ButtonDownFcn', bdfcn);
    set(hAx, ...
      'Units',      'pixels', ...
      'Position',   pos, ...
      'YDir',       'normal',...
      'XTick',      get(hAx, 'XLim'), ...
      'YTick',      [], ...
      'XTickLabel', {}, ...
      'TickDir',    'out', ...
      'TickLength', [0.04 0.04], ...
      'Box',        'off',...
      'HitTest',    'off', ...
      'Visible',    'off');
  end

  function setButtonDownFcn(fcn)
    bdfcn = fcn;
    set(hIm, 'ButtonDownFcn', bdfcn);
  end

  function setEnabled(b)
    str = {'off', 'on'};
    set(hIm, 'HitTest', str{b+1});
  end

  function setVisible(b)
    str = {'off','on'};
    visible = str{b+1};
    set(hIm, 'Visible', visible);
  end

end
