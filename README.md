
![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-bumpline) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-bumpline) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-bumpline) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-bumpline) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-bumpline)

---

[Installation](#Installation) | [Syntax](#Syntax) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

# bumpline v1.0

## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

SSC (**coming soon**):

```

```

GitHub (**v1.0**):

```
net install bumpline, from("https://raw.githubusercontent.com/asjadnaqvi/stata-bumpline/main/installation/") replace
```



The `palettes` package is required to run this command:

```
ssc install palettes, replace
ssc install colrspace, replace
```

Even if you have these packages installed, please check for updates: `ado update, update`.

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

The syntax for **v1.0** is as follows:

```
bumpline y x [if] [in], by(varname) 
                [ top(num) select(any|last) smooth(num) palette(str) labcond(str) offset(num)
                  lwidth(str) labsize(str) xlabsize(str) ylabsize(str) xlabangle(str) 
                  msymbol(str) msize(str) mlwidth(str)
                  xlabel(str) xtitle(str) ytitle(str) title(str) subtitle(str) note(str) 
                  ysize(num) xsize(num) scheme(str) name(str) ]

```

See the help file `help bumpline` for details.

The most basic use is as follows:

```
bumparea y x, by(group)
```

where `y` is a numerical variable we want to plot and `x` is the time dimension. Both need to be numeric. The `by()` is the category variable.



## Examples

Load the Stata dataset

```
use "https://github.com/asjadnaqvi/stata-bumpline/blob/main/data/owid_emissions_reduced.dta?raw=true", clear

drop if iso_code==""

// keep a random set of years
keep if inlist(year, 1990, 1992, 1995, 2000, 2005, 2007, 2010, 2013, 2016, 2019)
```

Let's test the `bumpline` command:


```
bumpline total_ghg year, by(country)
```

<img src="/figures/bumpline1.png" height="600">


```
bumpline total_ghg year, by(country) ///
	xsize(2) ysize(1) 
```

<img src="/figures/bumpline2.png" height="600">

```
bumpline total_ghg year, by(country) select(last) ///
	xsize(2) ysize(1) 
```

<img src="/figures/bumpline3.png" height="600">

### Smooth

```
bumpline total_ghg year, by(country) ///
	smooth(1) xsize(2) ysize(1) 
```

<img src="/figures/bumpline4.png" height="600">

```
bumpline total_ghg year, by(country) ///
	smooth(8) xsize(2) ysize(1) 	
```

<img src="/figures/bumpline5.png" height="600">


### top lists

```
bumpline total_ghg year, by(country) ///
	top(15) xsize(2) ysize(1) 	
```

<img src="/figures/bumpline6.png" height="600">

```
bumpline total_ghg year, by(country) ///
	top(20) xsize(2) ysize(1) 	
```

<img src="/figures/bumpline7.png" height="600">

### Palettes

```
bumpline total_ghg year, by(country) ///
	palette(CET L20) xsize(2) ysize(1) 
```

<img src="/figures/bumpline8.png" height="600">


```
bumpline total_ghg year, by(country) ///
	palette(viridis) xsize(2) ysize(1) 
```

<img src="/figures/bumpline9.png" height="600">

```
bumpline total_ghg year, by(country) ///
	palette(reds, reverse) xsize(2) ysize(1) 	
```

<img src="/figures/bumpline10.png" height="600">



### Lines and symbols

```
bumpline total_ghg year, by(country) ///
	lw(1.4) xsize(2) ysize(1)
```

<img src="/figures/bumpline11.png" height="600">

```
bumpline total_ghg year, by(country) ///
	lw(1.2) msym(square) msize(1.3) xsize(2) ysize(1)	
```

<img src="/figures/bumpline12.png" height="600">

### all together

```
bumpline total_ghg year, by(country) ///	
smooth(4) top(30) palette(CET L19, reverse) ///
	lw(0.5) msym(square) mlwid(0.3) msize(1.1) xlaba(45) offset(20)  ///
	title("Top 10 countries by annual GHG emissions", size(6)) ///
			note("Source: OWID.") ///
			xsize(2) ysize(1) 
```

<img src="/figures/bumpline13.png" height="400">



## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-bumpline/issues) to report errors, feature enhancements, and/or other requests.


## Change log

**v1.0 (10 Apr 2023)**
- Public release.







