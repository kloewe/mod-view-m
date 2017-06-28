function this = RangeSlider(hp,pos)
%RANGESLIDER Wrapper for Ernest Yu's Java RangeSlider.
%
%   H = RANGESLIDER(HP,POS)
%
%   HP   parent handle
%   POS  pixel position (relative to parent)
%
%   Author: Kristian Loewe

minDat = [];   % minimum     wrt data
maxDat = [];   % maximum     wrt data
loDat  = [];   % lower value wrt data
hiDat  = [];   % upper value wrt data

minSli = [];   % minimum     wrt slider setup
maxSli = [];   % maximum     wrt slider setup
loSli  = [];   % lower value wrt slider setup
hiSli  = [];   % upper value wrt slider setup

slider = javaObjectEDT('RangeSlider');
pos(4) = slider.getPreferredSize().height;
[jhSlider,hSlider] = javacomponent(slider, pos, hp);

init();

this = struct;
this.h       = hSlider;
this.jh      = jhSlider;
this.hjh     = handle(jhSlider);
this.getLo   = @getLo;
this.getHi   = @getHi;
this.getLims = @getLims;
this.setLo   = @setLo;
this.setHi   = @setHi;
this.setLims = @setLims;
this.init    = @init;

  function init()
    jhSlider.setMinimum(0);
    jhSlider.setMaximum(round(pos(3)));
    jhSlider.setValue(0);
    jhSlider.setUpperValue(round(pos(3)));
    minSli = 0;
    maxSli = round(pos(3));
    loSli  = jhSlider.getValue();
    hiSli  = jhSlider.getUpperValue();
    minDat = [];
    maxDat = [];
    loDat = [];
    hiDat = [];
  end

  function val = getLo()
    if round(loSli) ~= jhSlider.getValue()
      loSli = jhSlider.getValue();
      if loSli > minSli
        loDat = (loSli - minSli) * (maxDat - minDat)/(maxSli - minSli) + minDat;
      else
        loDat = -Inf;
      end
    end
    val = loDat;
  end
    
  function val = getHi()
    if round(hiSli) ~= jhSlider.getUpperValue()
      hiSli = jhSlider.getUpperValue();
      if hiSli < maxSli
        hiDat = (hiSli - minSli) * (maxDat - minDat)/(maxSli - minSli) + minDat;
      else
        hiDat = +Inf;
      end
    end
    val = hiDat;
  end

  function lims = getLims()
    lims = [minDat maxDat];
  end

  function setLo(val)
    val = double(val);
    loDat = val;
    if isfinite(loDat)
      loSli = (loDat - minDat) * (maxSli - minSli)/(maxDat - minDat) + minSli;
    elseif loDat == -Inf
      loDat = minDat;
      loSli = minSli;
    else
      error('Unexpected input value.');
    end
    jhSlider.setValue(round(loSli));
  end

  function setHi(val)
    val = double(val);
    hiDat = val;
    if isfinite(hiDat)
      hiSli = (hiDat - minDat) * (maxSli - minSli)/(maxDat - minDat) + minSli;
    elseif hiDat == +Inf
      loDat = maxDat;
      hiSli = maxSli;
    else
      error('Unexpected input value.');
    end
    jhSlider.setUpperValue(round(hiSli));
  end

  function setLims(lims)
    lims = double(lims);
    minDat = lims(1);
    maxDat = lims(2);
    if isempty(loDat) || loDat < minDat
      loDat = minDat;
    end
    if isempty(hiDat) || hiDat > maxDat
      hiDat = maxDat;
    end
    setLo(loDat);
    setHi(hiDat);
  end

end
