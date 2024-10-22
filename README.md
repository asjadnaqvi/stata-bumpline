
![bumpline-1](https://github.com/asjadnaqvi/stata-bumpline/assets/38498046/97dc8e00-e39a-4a2a-862f-f3d41e39f56c)

![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-bumpline) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-bumpline) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-bumpline) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-bumpline) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-bumpline)

---

[Installation](#Installation) | [Syntax](#Syntax)| [Citation guidelines](#Citation-guidelines) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

# bumpline v1.3
(22 October 2024)


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

SSC (**v1.21**):

```
ssc install bumpline, replace
```

GitHub (**v1.3**):

```
net install bumpline, from("https://raw.githubusercontent.com/asjadnaqvi/stata-bumpline/main/installation/") replace
```


Please make sure that you have the latest versions of the following packages installed:

```
ssc install palettes, replace
ssc install colrspace, replace
ssc install graphfunctions, replace
```


If you want to make a clean figure, then it is advisable to load a clean scheme. These are several available and I personally use the following:

```
ssc install schemepack, replace
set scheme white_tableau  
```

You can also push the scheme directly into the graph using the `scheme(schemename)` option. See the help file for details or the example below.

I also prefer narrow fonts in figures with long labels. You can change this as follows:

```
graph set window fontface "Arial Narrow"
```


## Syntax

The syntax for the latest version is as follows:

```stata
bumpline y x [if] [in] [weight], by(varname) 
                [ top(num) select(any|last) smooth(num) palette(str) labcond(str) offset(num) dropother wrap(num) stat(mean|sum) 
                  lwidth(str) lpattern(str) 
                  msize(str) msymbol(str) mcolor(str) mlcolor(str) mlwidth(str) 
                  labsize(str) labcolor(str) labangle(str) labposition(str) labgap(str)
                  olcolor(str) olwidth(str) olpattern(str)   
                  omcolor(str) omsymbol(str) omsize(str) omlcolor(str) omlwidth(str)   
                  olabsize(str) olabcolor(str) olabangle(str) olabposition(str) olabgap(str)
                  ylabsize(str) * ]
```

See the help file `help bumpline` for details.

The most basic use is as follows:

```
bumparea y x, by(group)
```

where `y` is a numerical variable we want to plot and `x` is the time dimension. Both need to be numeric. The `by()` is the category variable.


## Citation guidelines
Software packages take countless hours of programming, testing, and bug fixing. If you use this package, then a citation would be highly appreciated. Suggested citations:

*in BibTeX*

```
@software{bumpline,
   author = {Naqvi, Asjad},
   title = {Stata package ``bumpline''},
   url = {https://github.com/asjadnaqvi/stata-bumpline},
   version = {1.3},
   date = {2024-10-22}
}
```

*or simple text*

```
Naqvi, A. (2024). Stata package "bumpline" version 1.3. Release date 22 October 2024. https://github.com/asjadnaqvi/stata-bumpline.
```


*or see [SSC citation](https://ideas.repec.org/c/boc/bocode/s459195.html) (updated once a new version is submitted)*



## Examples

Load the Stata dataset

```stata
use "https://github.com/asjadnaqvi/stata-bumpline/blob/main/data/owid_emissions_reduced.dta?raw=true", clear

drop if iso_code==""

// keep a random set of years
keep if inlist(year, 1990, 1992, 1995, 2000, 2005, 2007, 2010, 2013, 2016, 2019)
```

Let's test the `bumpline` command:


```
bumpline total_ghg year, by(country)
```

<img src="/figures/bumpline1.png" width="100%">


```
bumpline total_ghg year, by(country) top(10) ///
	xsize(2) ysize(1) 
```

<img src="/figures/bumpline2.png" width="100%">

```
bumpline total_ghg year, by(country) select(last) top(10) ///
	xsize(2) ysize(1) 
```

<img src="/figures/bumpline3.png" width="100%">

### Smooth

```
bumpline total_ghg year, by(country) top(10) ///
	smooth(1) xsize(2) ysize(1) 
```

<img src="/figures/bumpline4.png" width="100%">

```
bumpline total_ghg year, by(country) top(10) ///
	smooth(8) xsize(2) ysize(1) 	
```

<img src="/figures/bumpline5.png" width="100%">


### top lists

```
bumpline total_ghg year, by(country) top(10) ///
	top(15) xsize(2) ysize(1) 	
```

<img src="/figures/bumpline6.png" width="100%">

```
bumpline total_ghg year, by(country) top(10) ///
	top(20) xsize(2) ysize(1) 	
```

<img src="/figures/bumpline7.png" width="100%">


```
bumpline total_ghg year, by(country) top(10) dropother ///
	top(20) xsize(2) ysize(1) 	
```

<img src="/figures/bumpline7_1.png" width="100%">

### Palettes

```
bumpline total_ghg year, by(country) top(10) ///
	palette(CET L20) xsize(2) ysize(1) 
```

<img src="/figures/bumpline8.png" width="100%">


```
bumpline total_ghg year, by(country) top(10) ///
	palette(viridis) xsize(2) ysize(1) 
```

<img src="/figures/bumpline9.png" width="100%">

```
bumpline total_ghg year, by(country) top(10) ///
	palette(reds, reverse) xsize(2) ysize(1) 	
```

<img src="/figures/bumpline10.png" width="100%">



### Lines and symbols

```
bumpline total_ghg year, by(country) top(10) ///
	lw(1.4) xsize(2) ysize(1)
```

<img src="/figures/bumpline11.png" width="100%">

```
bumpline total_ghg year, by(country) top(10) ///
	lw(1.2) msym(square) msize(1.3) xsize(2) ysize(1)	
```

<img src="/figures/bumpline12.png" width="100%">



```stata
bumpline total_ghg year, by(country)  top(12) ///	
smooth(4) palette(CET L04) ///
	lw(0.8) msym(square) mlwid(0.3) msize(1)  offset(20)  ///
	title("Top 30 countries by annual GHG emissions", size(6)) ///
			note("Source: OWID.") ///
			xsize(4) ysize(2) 
```

<img src="/figures/bumpline13.png" width="100%">


```stata
bumpline total_ghg year, by(country)  top(12) ///	
smooth(4) palette(CET L04) ///
	lw(0.8) msym(square) mlwid(0.3) msize(1)  offset(20)  ///
	title("Top 30 countries by annual GHG emissions", size(6)) ///
			note("Source: OWID.") ///
			xsize(4) ysize(2) 
```

<img src="/figures/bumpline13.png" width="100%">


### v1.3

```stata
graph set window fontface "Abel"

bumpline total_ghg year, by(country)   ///	
smooth(4) top(20) palette(CET L04) ///
	lw(0.5) msym(square) mlwid(0.3) msize(0.4) xlabel(, angle(90)) offset(20) labsize(2)  ///
	title("{fontface Merriweather Bold:Top 30 countries by annual GHG emissions}", size(6)) ///
			note("Source: Our World in Data. bumpline package. @AsjadNaqvi.") ///
			xsize(8) ysize(5) 
```

<img src="/figures/bumpline14.png" width="100%">




```stata
use "https://github.com/asjadnaqvi/stata-bumpline/blob/main/data/owid_emissions_reduced.dta?raw=true", clear
drop if iso_code==""
drop if year < 1995

levelsof year if !missing(gdp)


bumpline total_ghg year [aw = gdp], by(country) wrap(20) dropother  ///	
smooth(8) top(16) palette(CET L20, reverse) labc(white) ///
	lw(0.8) msym(square) mlwid(0.3) msize(0.5) xlabel("`r(levels)'", angle(90) labsize(2)) offset(10) labsize(2.6)  ///
	title("{fontface Merriweather Bold:Top 30 countries by annual GHG emissions (GDP weighted)}",  size(6)) ///
			note("Source: Our World in Data. bumpline package.", size(1.6)) ///
			xsize(3) ysize(1) scheme(neon)

```

<img src="/figures/bumpline15.png" width="100%">



## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-bumpline/issues) to report errors, feature enhancements, and/or other requests.


## Change log

**v1.3 (22 October 2024)**
- `wrap()` ported to `graphfunctions`. 
- Weights are now allowed.
- Added options `stat(mean)` and `stat(sum)` (default) for collapsing the data. If the data has duplicate values, collapse will be used and a warning message will be displayed.
- Added `dropther` to drop `by()` categories that start and end in the middle.
- All possible line, marker, symbol, other line, other marker, other symbol options added for maximum control.
- Removed x-axis options. Use the standard `xlabel()` with standard options. This provides the most control over the axis.
- Major code clean up.

**v1.21 (11 Jun 2024)**
- Added `wrap()` for label wrapping.
- Several code improvements for faster rendering.

**v1.2 (10 Feb 2024)**
- Fixes to how colors are assigned.
- Minor cleanups.

**v1.1 (28 May 2023)**
- Fixed `if` and `in` conditions that were not passing correctly.
- Added checks for duplicates.
- Removed graph grids.
- Added `mlabsize()` for smaller labels.
- Minor code cleanups, updates to defaults, and help file.

**v1.0 (10 Apr 2023)**
- Public release.







