function unit=ConvertUnitString(unit)
%CONVERTUNITSTRING   converts unit from longname (metre) to short name (m)
%
%   Converts unit from longname to short name.
%
%   Syntax:
%   unit_short = ConvertUnitString(unit_long);
%
%   Input:
%   unit_long = input unit name (long name)
%
%   Output:
%   unit_short = output unit name (short name)
%
%   See web: <a href="http://www.unidata.ucar.edu/software/udunit">http://www.unidata.ucar.edu/software/udunit</a>
%   See also CONVERT_UNITS

%% Copyright notice
%   --------------------------------------------------------------------
%   Copyright (C) 2010 Deltares
%       <NAME>
%
%       <EMAIL>	
%
%       <ADDRESS>
%
%   This library is free software: you can redistribute it and/or
%   modify it under the terms of the GNU Lesser General Public
%   License as published by the Free Software Foundation, either
%   version 2.1 of the License, or (at your option) any later version.
%
%   This library is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%   Lesser General Public License for more details.
%
%   You should have received a copy of the GNU Lesser General Public
%   License along with this library. If not, see <http://www.gnu.org/licenses/>.
%   --------------------------------------------------------------------

% This tool is part of <a href="http://OpenEarth.nl">OpenEarthTools</a>.
% OpenEarthTools is an online collaboration to share and manage data and 
% programming tools in an open source, version controlled environment.
% Sign up to recieve regular updates of this function, and to contribute 
% your own tools.

%% Version <http://svnbook.red-bean.com/en/1.5/svn.advanced.props.special.keywords.html>
% Created: 29 Oct 2010
% Created with Matlab version: 7.9.0.529 (R2009b)

% $Id: ConvertUnitString.m 3210 2010-10-29 13:52:34Z mol $
% $Date: 2010-10-29 15:52:34 +0200 (ven., 29 oct. 2010) $
% $Author: mol $
% $Revision: 3210 $
% $HeadURL: https://repos.deltares.nl/repos/OpenEarthTools/trunk/matlab/applications/SuperTrans/conversion/ConvertUnitString.m $
% $Keywords: $

%%
switch lower(unit),
    case{'metre'};                        unit='m';
    case{'meter'};                        unit='m';
    case{'foot'};                         unit='ft';
    case{'us survey foot'};               unit='ft (US)';
    case{'nautical mile'};                unit='NM';
    case{'kilometre'};                    unit='km';
    case{'radian'};                       unit='rad';
    case{'microradian'};                  unit='microrad';
    case{'degree'};                       unit='deg';
    case{'arc-minute'};                   unit='min';
    case{'arc-second'};                   unit='s';
    case{'degree','degree minute second','degree minute second hemisphere','sexagesimal dms','sexagesimal dm', ...
            'sexagesimal dm.s','degree minute','degree hemisphere','hemisphere degree','degree minute hemisphere','hemisphere degree minute','hemisphere degree minute second'}
        unit='deg';
    case{'coefficient','unity'};          unit='-';
    case{'parts per million'};            unit='ppm';
    case{'british chain (benoit 1895 b)'};unit='British chain';
end        

% 9094,Gold Coast foot,length,9001,6378300,20926201,"Used in Ghana and some adjacent parts of British west Africa prior to metrication, except for the metrication of projection defining parameters when British foot (Sears 1922) used.",Ordnance Survey International,EPSG,2001-01-21,2000.86,0
% 9095,British foot (1936),length,9001,0.3048007491,1,For the 1936 retriangulation OSGB defines the relationship of 10 feet of 1796 to the International metre through the logarithmic relationship (10^0.48401603 exactly). 1 ft = 0.3048007491?m. Also used for metric conversions in Ireland.,"1. ""The Retriangulation of Great Britain"", Ordnance Survey of Great Britain.2. ""The Irish Grid - A Description of the Co-ordinate Reference System"" published by Ordnance Survey of Ireland, Dublin and Ordnance Survey of Northern Ireland, Belfast.",EPSG,2006-11-27,2002.621 2006.932,0
% 9096,yard,length,9001,0.9144,1,=3 international feet.,OGP,OGP,2006-07-14,,0
% 9097,chain,length,9001,20.1168,1,=22 international yards or 66 international feet.,OGP,OGP,2006-07-14,,0
% 9098,link,length,9001,20.1168,100,=1/100 international chain.,OGP,OGP,2006-07-14,,0
% 9099,British yard (Sears 1922 truncated),length,9001,0.914398,1,Uses Sear's 1922 British yard-metre ratio (UoM code 9040) truncated to 6 significant figures.,Defence Geographic Centre,OGP,2006-10-23,2006.901,0
% 9101,radian,angle,9101,1,1,SI standard unit.,ISO 1000:1992,EPSG,1995-06-02,,0
% 9102,degree,angle,9101,3.14159265358979,180,= pi/180 radians,,EPSG,2002-11-18,96.22 2002.86,0
% 9103,arc-minute,angle,9101,3.14159265358979,10800,1/60th degree = ((pi/180) / 60) radians,,EPSG,2002-11-18,96.22 2002.86,0
% 9104,arc-second,angle,9101,3.14159265358979,648000,1/60th arc-minute = ((pi/180) / 3600) radians,,EPSG,2002-11-18,96.22 2002.86,0
% 9105,grad,angle,9101,3.14159265358979,200,=pi/200 radians.,,EPSG,2002-11-18,96.22  99.05 2002.86,0
% 9106,gon,angle,9101,3.14159265358979,200,=pi/200 radians,,EPSG,2002-11-18,96.22 2002.86,0
% 9107,degree minute second,angle,9102,,,"Degree representation. Format: signed degrees (integer) - arc-minutes (integer) - arc-seconds (real, any precision). Different symbol sets are in use as field separators, for example º ' "". Convert to degrees using algorithm.",EPSG,EPSG,2002-11-22,96.19 2002.07 2002.78,0
% 9108,degree minute second hemisphere,angle,9102,,,"Degree representation. Format: degrees (integer) - arc-minutes (integer) - arc-seconds (real) - hemisphere abbreviation (single character N S E or W). Different symbol sets are in use as field separators for example º ' "". Convert to deg using algorithm.",EPSG,EPSG,2002-11-22,96.19 2002.07 2002.78,0
% 9109,microradian,angle,9101,1,1000000,rad * 10E-6,ISO 1000.,EPSG,1996-10-18,99.05,0
% 9110,sexagesimal DMS,angle,9102,,,Pseudo unit format: signed degrees - period - minutes (two digits) - integer seconds (two digits) - fraction of seconds (any precision). Must include leading zero in minutes and seconds and exclude decimal point for seconds. Convert to deg using formula.,EPSG,EPSG,2002-11-22,2002.27 2002.78,0
% 9111,sexagesimal DM,angle,9102,,,Pseudo unit. Format: sign - degrees - decimal point - integer minutes (two digits) - fraction of minutes (any precision).  Must include leading zero in integer minutes.  Must exclude decimal point for minutes.  Convert to deg using algorithm.,EPSG,EPSG,2002-11-22,2002.07 2002.78,0
% 9112,centesimal minute,angle,9101,3.14159265358979,20000,1/100 of a grad and gon = ((pi/200) / 100) radians,http://www.geodesy.matav.hu/,EPSG,2005-09-06,98.48  99.51 2002.86 2005.46,0
% 9113,centesimal second,angle,9101,3.14159265358979,2000000,"1/100 of a centesimal minute or 1/10,000th of a grad and gon = ((pi/200) / 10000) radians",http://www.geodesy.matav.hu/,EPSG,2005-09-06,99.51 2002.86 2005.46,0
% 9114,mil_6400,angle,9101,3.14159265358979,3200,Angle subtended by 1/6400 part of a circle.  Approximates to 1/1000th radian.  Note that other approximations (notably 1/6300 circle and 1/6000 circle) also exist.,http://www.geodesy.matav.hu/,EPSG,2005-09-06,99.51 2005.46,0
% 9115,degree minute,angle,9102,,,"Degree representation. Format: signed degrees (integer)  - arc-minutes (real, any precision). Different symbol sets are in use as field separators, for example º '. Convert to degrees using algorithm.",EPSG,EPSG,2002-11-22,2002.78,0
% 9116,degree hemisphere,angle,9102,,,"Degree representation. Format: degrees (real, any precision) - hemisphere abbreviation (single character N S E or W). Convert to degrees using algorithm.",EPSG,EPSG,2002-11-22,,0
% 9117,hemisphere degree,angle,9102,,,"Degree representation. Format: hemisphere abbreviation (single character N S E or W) - degrees (real, any precision). Convert to degrees using algorithm.",EPSG,EPSG,2002-11-22,,0
% 9118,degree minute hemisphere,angle,9102,,,"Degree representation. Format: degrees (integer) - arc-minutes (real, any precision) - hemisphere abbreviation (single character N S E or W). Different symbol sets are in use as field separators, for example º '. Convert to degrees using algorithm.",EPSG,EPSG,2002-11-22,,0
% 9119,hemisphere degree minute,angle,9102,,,"Degree representation. Format:  hemisphere abbreviation (single character N S E or W) - degrees (integer) - arc-minutes (real, any precision). Different symbol sets are in use as field separators, for example º '. Convert to degrees using algorithm.",EPSG,EPSG,2002-11-22,,0
% 9120,hemisphere degree minute second,angle,9102,,,"Degree representation. Format: hemisphere abbreviation (single character N S E or W) - degrees (integer) - arc-minutes (integer) - arc-seconds (real). Different symbol sets are in use as field separators for example º ' "". Convert to deg using algorithm.",EPSG,EPSG,2002-11-22,,0
% 9121,sexagesimal DMS.s,angle,9102,,,"Pseudo unit. Format: signed degrees - minutes (two digits) - seconds (real, any precision). Must include leading zero in minutes and seconds where value is under 10 and include decimal separator for seconds. Convert to degree using algorithm.",ISO 6709:1983.,EPSG,2002-11-22,,0
% 9122,degree (supplier to define representation),angle,9101,3.14159265358979,180,"= pi/180 radians. The degree representation (e.g. decimal, DMSH, etc.) must be clarified by suppliers of data associated with this code.",EPSG,EPSG,2004-01-05,,0
% 9201,unity,scale,9201,1,1,,,EPSG,1996-09-12,,0
% 9202,parts per million,scale,9201,1,1000000,,,EPSG,1996-09-12,,0
% 9203,coefficient,scale,9201,1,1,Used when parameters are coefficients.  They inherently take the units which depend upon the term to which the coefficient applies.,EPSG,EPSG,2004-09-14,2004.53,0
% 9204,Bin width 330 US survey feet,length,9001,3960,39.37,,EPSG,EPSG,2000-10-19,2000.59,0
% 9205,Bin width 165 US survey feet,length,9001,1980,39.37,,EPSG,EPSG,2000-10-19,2000.59,0
% 9206,Bin width 82.5 US survey feet,length,9001,990,39.37,,EPSG,EPSG,2000-10-19,2000.59,0
% 9207,Bin width 37.5 metres,length,9001,37.5,1,,EPSG,EPSG,2000-10-19,2000.59,0
% 9208,Bin width 25 metres,length,9001,25,1,,EPSG,EPSG,2000-10-19,2000.59,0
% 9209,Bin width 12.5 metres,length,9001,12.5,1,,EPSG,EPSG,2000-10-19,2000.59,0
% 9210,Bin width 6.25 metres,length,9001,6.25,1,,EPSG,EPSG,2000-10-19,2000.59,0
% 9211,Bin width 3.125 metres,length,9001,3.125,1,,EPSG,EPSG,2000-10-19,2000.59,0
% 9300,British foot (Sears 1922 truncated),length,9001,0.914398,3,"Uses Sear's 1922 British yard-metre ratio (UoM code 9040) truncated to 6 significant figures; this truncated ratio (0.914398, UoM code 9099) then converted to other imperial units. 3 ftSe(T) = 1 ydSe(T).",Defence Geographic Centre,OGP,2006-10-23,2006.901,0
% 9301,British chain (Sears 1922 truncated),length,9001,20.116756,1,"Uses Sear's 1922 British yard-metre ratio (UoM code 9040) truncated to 6 significant figures; this truncated ratio (0.914398, UoM code 9099) then converted to other imperial units. 1 chSe(T) = 22 ydSe(T). Used in metrication of Malaya RSO grid.",Defence Geographic Centre,OGP,2006-10-23,2006.901,0
% 9302,British link (Sears 1922 truncated),length,9001,20.116756,100,"Uses Sear's 1922 British yard-metre ratio (UoM code 9040) truncated to 6 significant figures; this truncated ratio (0.914398, UoM code 9099) then converted to other imperial units. 100 lkSe(T) = 1 chSe(T).",Defence Geographic Centre,OGP,2006-10-23,2006.901,0
%         
%         
        