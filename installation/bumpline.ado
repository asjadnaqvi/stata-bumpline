*! bumpline v1.21 (11 Jun 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com, @AsjadNaqvi)


* v1.21 (11 Jun 2024): added wrap() for label wrapping. Code clean up
* v1.2  (10 Feb 2024): minor cleanups, fixes to how colors are assigned.
* v1.1  (28 May 2023): ifin fixed. removed graph grid. isid added. added mlabsize for smaller labels.
* v1.0  (10 May 2023): First release

cap prog drop bumpline

prog def bumpline, sortpreserve
version 15
	
syntax varlist(min=2 max=2) [if] [in], by(varname)  ///
	[ top(real 50) smooth(real 4) SELect(string) palette(string) offset(real 15)  ] ///
	[ LABSize(string) MLABSize(string) MSize(string) MSYMbol(string) MLWIDth(string) MLColor(string) MColor(string) LWidth(string) ]  ///
	[ XLABSize(string) YLABSize(string) XLABAngle(string) points(real 50) wrap(numlist >=0 max=1) * ] 
	
	
	// check dependencies
	capture findfile colorpalette.ado
	if _rc != 0 {
		display as error "The {bf:palettes} package is missing. Install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}
	
	capture findfile labmask.ado
	if _rc != 0 {
		qui ssc install labutil, replace
	}	
	
	marksample touse, strok

qui {	
preserve	

	keep if `touse'

	keep `varlist' `by'

	isid `varlist' `by'
	
	gettoken yvar xvar : varlist 
	drop if `yvar' == .

	egen _x = group(`xvar')

	gsort `xvar' -`yvar'
	by `xvar': gen _rank = _n	


	bysort `by' : egen _minrank = min(_rank)

	sort `xvar' _rank

	summ _x, meanonly
	local last = r(max)

	gen _mark = 1 if _rank <= `top' & _x==`last'

	bysort `by': egen _maxlast = max(_mark)

	
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
			
			replace _xval = (`xmax' - `xmin') * (_xnorm - 0) / (1 - 0) + `xmin'  if _x==`i' & _group==`y'	
			
			// y
			summ _rankrev if _group==`y' & _x==`i', meanonly
			local ymin = r(min)
			
			summ _rankrev if _group==`y' & _x==`j', meanonly 
			local ymax = r(max)
			
			replace _yval = (`ymax' - `ymin') * (_ynorm - 0) / (1 - 0) + `ymin'  if _x==`i' & _group==`y'
			
			
			summ _ranklast if _group==`y' & _mark==1, meanonly
			replace _ranklast = r(max) if _group==`y' & _ranklast==.
		
			}
	}


	// prepare to draw

	summ _rank
	local ymin = r(min)
	local ymax = r(max)
	labmask _rankrev, val(_rank)
		

	if "`lwidth'" 	== "" local lwidth 0.8
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
		

		colorpalette `palette', nograph n(`top') `poptions'
		
		
		local lines `lines' (line    _yval _xval if _group==`x', lw(`lwidth') lc("`r(p`clr')'") cmissing(n) )
		
		
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
		
		
		local marks `marks' (scatter _rankrev `xvar' if _group==`x' & _tagxy==1, msym(`msymbol') mlwidth(`mlwidth') msize(`msize')  mc("`mclr'") mlc("`mlclr'") )
		
	}

	// control the x axis
	summ `xvar', meanonly
	local xrmin = `r(min)'
	summ `xvar', meanonly
	local xrmax = r(max) + ((r(max) - r(min)) * (`offset' / 100)) 	
	
	
	if "`wrap'" != "" {
		gen _lab2 = `by' if _taglast!=.
		
		gen _length = length(_lab2) if _lab2!= ""
		summ _length, meanonly		
		local _wraprounds = floor(`r(max)' / `wrap')
		
		forval i = 1 / `_wraprounds' {
			local wraptag = `wrap' * `i'
			replace _lab2 = substr(_lab2, 1, `wraptag') + "`=char(10)'" + substr(_lab2, `=`wraptag' + 1', .) if _length > `wraptag' & _lab2!= ""
		}
		
		drop _length
		local by _lab2
	}		
	
	
	levelsof `xvar'
	local xlist = "`r(levels)'"
	
	levelsof _rankrev
	local ylist = "`r(levels)'"
	
	if "`labsize'"   == "" local labsize   2.2
	if "`mlabsize'"  == "" local mlabsize  1.6
	if "`xlabsize'"  == "" local xlabsize  2.5
	if "`ylabsize'"  == "" local ylabsize  2.5
	if "`xlabangle'" == "" local xlabangle 0
	

	// draw

	twoway ///
		(scatter _rankrev `xvar' if _taglast==1				 , mlabel(`by') mlabpos( 3) mlabsize(`labsize') mc(none) mlabgap(1.4)) ///
		`lines' ///
		`marks' ///
		(scatter _rankrev `xvar' if _taglast==0 & _tagctry==1, mlabel(`by') mlabpos(12) mlabsize(`mlabsize') mc(none) mlabgap(0.15)) ///
		, ///
		xtitle("") ytitle("") ///
		ylabel(`ylist', valuelabels labsize(`ylabsize') nogrid ) ///
		xlabel(`xlist', labsize(`xlabsize') angle(`xlabangle') nogrid) ///
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
