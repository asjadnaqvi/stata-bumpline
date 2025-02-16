*! bumpline v1.4 (16 Feb 2025)
*! Asjad Naqvi (asjadnaqvi@gmail.com, @AsjadNaqvi)

* v1.4  (16 Feb 2025): colorby() added. Other clean ups.
* v1.3  (22 Oct 2024): stat(mean|sum) added. default is sum. xlabel options removed. dropother added. extensive label, line, marker control options added.
* v1.21 (11 Jun 2024): added wrap() for label wrapping. Code clean up
* v1.2  (10 Feb 2024): minor cleanups, fixes to how colors are assigned.
* v1.1  (28 May 2023): ifin fixed. removed graph grid. isid added. added mlabsize for smaller labels.
* v1.0  (10 May 2023): First release

cap prog drop bumpline

prog def bumpline, sortpreserve
version 15
	
syntax varlist(min=2 max=2) [if] [in] [aw fw pw iw/], by(varname)  ///
	[ top(real 10) smooth(real 4) SELect(string) palette(string) offset(real 15)  ] ///
	[ YLABSize(string) points(real 50) wrap(numlist >=0 max=1) stat(string) dropother ]  ///
	[ LWidth(string) LPattern(string) ]  ///    // standard lines
	[ MSize(string) MSYMbol(string) MLWidth(string) MLColor(string) MColor(string) ] ///   // standard markers
	[ LABSize(string)  LABColor(string) LABAngle(string) LABPosition(string) LABGap(string)    ] 	///		// standard labels	
	[ OLColor(string) OLWidth(string) OLPattern(string) ] ///  // other lines // v1.3
	[ OMColor(string) OMLWidth(string) OMLColor(string) OMSYMbol(string) OMSize(string) ] ///  // other markers
	[ OLABSize(string) OLABColor(string) OLABAngle(string) OLABPosition(string) OLABGap(string) ] ///  // other labels
	[ colorby(varname) *  ] // v1.4 options
	
	
	// check dependencies
	capture findfile colorpalette.ado
	if _rc != 0 {
		display as error "The {bf:palettes} package is missing. Install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}
	
	capture findfile labmask.ado
		if _rc != 0 quietly ssc install labutil, replace
		
	capture findfile labsplit.ado
		if _rc != 0 quietly ssc install graphfunctions, replace				
	
	
	if "`stat'" != "" & !inlist("`stat'", "mean", "sum") {
		display as error "Valid options are {bf:stat(mean)} [default] or {bf:stat(sum)}."
		exit
	}	
	
	marksample touse, strok

quietly {	
preserve	

	keep if `touse'
	
	if "`colorby'" !="" {
		gen _mycolors = `colorby'
	}
	else {
		gen _mycolors = .
	}
	

	keep `varlist' `by' `exp' _mycolors

	
	gettoken yvar xvar : varlist 
	
	drop if missing(`yvar')

	
	if "`stat'" == "" local stat sum
	
	duplicates tag `by' `xvar', gen(_dups)
	summ _dups, meanonly

	
	if `r(max)'> 0 {
		noisily display in yellow "{it:`xvar'} and {it:`by'} duplicates combined using {it:stat(`stat')}. See {stata help bumpline} or prepare the data before running the command." 
	}
	
	
	if "`weight'" != "" local myweight  [`weight' = `exp']	

	collapse (`stat') `yvar'  (first) _mycolors `myweight', by(`by' `xvar')	
	
	egen _x = group(`xvar')

	gsort `xvar' -`yvar'
	by `xvar': gen _rank = _n	


	bysort `by' : egen _minrank = min(_rank)

	sort `xvar' _rank

	
	summ _x, meanonly
	local last = r(max)

	gen _mark = 1 if _rank <= `top' & _x==`last'


	bysort `by': egen _maxlast = max(_mark)
	recode _maxlast (.=0)

	
	
	
	if "`select'"=="any" | "`select'"=="" {
		drop if _rank > `top'  // hard ranks 
	}
	
	if "`select'"=="last" {
		keep if _maxlast==1 // (top X in last year only)
	}
	
	
	egen _group = group(`by')

	// reverse the ranks
	summ _rank, meanonly
	gen _rankrev = r(max) + 1 - _rank

	// get a generic sigmoid in place	
	sort `by' `xvar'
	gen _id = _n
	order _id
	

	local newobs = `points'	+ 1	
	expand `newobs'
	bysort _id: gen _seq = _n

	
	*** for the sigmoid box
	sort `by' `xvar' _seq
	bysort _id: gen double _xnorm =  ((_n - 1) / (`newobs' - 2))
	replace _xnorm = . if _seq == `newobs'
	gen double _ynorm =  (1 / (1 + (_xnorm / (1 - _xnorm))^-`smooth'))
	replace _ynorm = 0 if _seq==1
	replace _ynorm = 1 if _seq== `points'	

	
	// tag the countries
	by `by' (`xvar'), sort: gen _tagctry = 1 if (_n==_N)
	gen _taglast = _x==`last' & _tagctry==1
	
	
	// also mark structural breaks
	by `by': replace _tagctry = 1 if (_x[_n+1] - _x) > 1
	
	
	gen     _ranklast = _rank if _x==`last'
	replace _ranklast = _rank if _taglast==0 & _tagctry==1
	
	
	
	// we interporate upto x-1 items	
	gen double _xval = .
	gen double _yval = .
	
	levelsof _x, local(lvls)
	local items = r(r) - 1
		
	levelsof _group, local(grp)
	
	forval i = 1/`items' {
		
		local j = `i' + 1
		

		foreach y of local grp {
			
			// x
			summ `xvar' if _group==`y' & _x==`i', meanonly
			local xmin = r(min)
			
			summ `xvar' if _group==`y' & _x==`j', meanonly 
			local xmax = r(max)
			
			replace _xval = (`xmax' - `xmin') * (_xnorm) + `xmin'  if _x==`i' & _group==`y'	
			
			// y
			summ _rankrev if _group==`y' & _x==`i', meanonly
			local ymin = r(min)
			
			summ _rankrev if _group==`y' & _x==`j', meanonly 
			local ymax = r(max)
			
			replace _yval = (`ymax' - `ymin') * (_ynorm)  + `ymin'  if _x==`i' & _group==`y'
			
			
			summ _ranklast if _group==`y' & _mark==1, meanonly
			replace _ranklast = r(max) if _group==`y' & _ranklast==.
		
			}
	}


	// prepare to draw

	summ _rank, meanonly
	local ymin = r(min)
	local ymax = r(max)
	labmask _rankrev, val(_rank)
		

	if "`lwidth'" 	== "" local lwidth 0.8
	if "`lpattern'" == "" local lpattern solid
	
	if "`msize'" 	== "" local msize 2
	if "`msymbol'" 	== "" local msymbol circle
	if "`mlwidth'" 	== "" local mlwidth medium
	if "`palette'" 	== "" {
		local palette tableau	
	}
	else {
		tokenize "`palette'", p(",")
		local palette  `1'
		local poptions `3'
	}		
	
	
	egen _tagxy = tag(_group `xvar')
	
	
	

	levelsof _group, local(lvl)

	foreach x of local lvl {
		
		
		summ _taglast if _group==`x', meanonly
		

		if r(max) == 1 {		
			summ _ranklast if _group==`x' & _taglast==1, meanonly
			local clr = r(min)
		}		
		if r(max) == 0 {	
			summ _ranklast if _group==`x', meanonly
			local clr = r(max)
		}
		

		
		
		if "`colorby'"== "" {	
			colorpalette `palette', nograph n(`top') `poptions'
			local lines `lines' (line _yval _xval if _group==`x' & _maxlast==1, lw(`lwidth') lp(`lpattern') lc("`r(p`clr')'") cmissing(no))
			
			if "`mcolor'" == "" {
				local mclr `r(p`clr')'
			}
			else {
				local mclr `mcolor'
			}
			
			if "`mlcolor'" == "" {
				local mlclr `r(p`clr')'
			}
			else {
				local mlclr `mlcolor'
			}
					
		
		
			local marks `marks' (scatter _rankrev `xvar' if _group==`x' & _tagxy==1 & _maxlast==1, msym(`msymbol') mlwidth(`mlwidth') msize(`msize')  mc("`mclr'") mlc("`mlclr'") )
		
		
		}
		

	}
	
	
	
		if "`colorby'"!= "" {
			summ _mycolors, meanonly
			local items = r(max) + 1
			replace _mycolors = `items' if missing(_mycolors)
			
			
			forval i = 1/`items' {
				colorpalette `palette', nograph n(`items') `poptions'
				
				local lines `lines' (line _yval _xval 		 if _mycolors==`i' & _maxlast==1, lw(`lwidth') lp(`lpattern') lc("`r(p`i')'") cmissing(no))
				
				if "`mcolor'" == "" {
					local mclr `r(p`i')'
				}
				else {
					local mclr `mcolor'
				}
				
				if "`mlcolor'" == "" {
					local mlclr `r(p`i')'
				}
				else {
					local mlclr `mlcolor'
				}
				
				
				local marks `marks' (scatter _rankrev `xvar' if _mycolors==`i' & _tagxy==1 & _maxlast==1, msym(`msymbol') mlwidth(`mlwidth') msize(`msize')  mc("`mclr'") mlc("`mlclr'") )
				
			}
			
				
			
			
		}	

	
	if "`olwidth'"  == "" local olwidth `lwidth'
	if "`olcolor'"  == "" local olcolor  gs12
	if "`olpattern'"  == "" local olpattern  solid
	
	if "`omsymbol'" == "" local omsymbol `msymbol'
	if "`omlwidth'" == "" local omlwidth `mlwidth'
	if "`omlcolor'" == "" local omlcolor `olcolor'
	
	if "`omsize'"   == "" local omsize   `msize'
	if "`omcolor'"  == "" local omcolor  gs12
	
	if "`labsize'"       == "" local labsize   		2.2
	if "`labgap'"        == "" local labgap   		1.5
	if "`labangle'"      == "" local labangle  		0
	if "`labcolor'"      == "" local labcolor  		black
	if "`labposition'"   == "" local labposition  	3
	
	if "`olabsize'"      == "" local olabsize 		1.8
	if "`olabcolor'"     == "" local olabcolor  	black
	if "`olabposition'"  == "" local olabposition  	12
	if "`olabangle'"     == "" local olabangle	   	0
	if "`olabgap'"     	 == "" local olabgap	   	1.5	
	

	if "`dropother'" == "" {
		local line2 (line    _yval _xval     if             _maxlast==0, lpattern(`oldpattern') lwidth(`olwidth') lcolor(`olcolor') cmissing(n) )
		local mark2 (scatter _rankrev `xvar' if _tagxy==1 & _maxlast==0, msymbol(`omsymbol') mlwidth(`omlwidth') msize(`omsize')  mcolor(gs10) mlcolor(`omlcolor') )
		local scat2 (scatter _rankrev `xvar' if _taglast==0 & _tagctry==1, mlabel(`by') mcolor(none) mlabpos(`olabposition') mlabsize(`olabsize') mlabcolor(`olabcolor') mlabangle(`olabangle') mlabgap(`olabgap')) 
	}
	
	// control the x axis
	summ `xvar', meanonly
	local xrmin = `r(min)'
	summ `xvar', meanonly
	local xrmax = r(max) + ((r(max) - r(min)) * (`offset' / 100)) 	
	
	
	
	
	

	if "`wrap'" != "" {
		
		
		cap confirm numeric var `by'		
		
		if _rc!=0 {  // if string
			gen _lab2_temp = `by'
		}
		else {
			if "`: value label `by''" != "" {
				decode `by', gen(_lab2_temp)
			}
			else {
				gen _lab2_temp = string(`by')
			}
		}
		
		
		labsplit _lab2_temp, wrap(`wrap') gen(_lab2)
		drop _lab2_temp
		local by _lab2
	}		
	
	
	levelsof _rankrev
	local ylist = "`r(levels)'"
	

	if "`ylabsize'"      == "" local ylabsize  2.5	
	
	lab var _rankrev "Rank"

	//////////////
	// 	draw 	//
	//////////////

	twoway ///
		(scatter _rankrev `xvar' if _taglast==1, mlabel(`by') mlabpos(`labposition') mlabsize(`labsize') mc(none) mlabgap(`labgap') mlabangle(`labangle') mlabcolor(`labcolor')) ///
		`lines' ///
		`marks' ///
		`line2'	///
		`mark2' ///
		`scat2'	///
		, ///
		ylabel(`ylist', valuelabels labsize(`ylabsize') nogrid ) ///
		yscale(noline) ///
		xscale(noline range(`xrmin' `xrmax')) ///
		legend(off)  `options' 

		
*/	

restore
}
	
end


************************
***** END OF FILE ******
************************
