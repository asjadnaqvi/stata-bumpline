{smcl}
{* 10Apr2023}{...}
{hi:help bumpline}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-bumpline":bumpline v1.0 (GitHub)}}

{hline}

{title:bumpline}: A Stata package for bump area or ribbon plots. 


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:bumpline} {it:y x} {ifin}, {cmd:by}(varname) 
		{cmd:[} {cmd:top}({it:num}) {cmdab:sel:ect(any|last)} {cmd:smooth}({it:num}) {cmd:palette}({it:str}) {cmd:labcond}({it:str}) {cmd:offset}({it:num})
		  {cmdab:lw:idth}({it:str}) {cmdab:labs:ize}({it:str}) {cmdab:xlabs:ize}({it:str}) {cmdab:ylabs:ize}({it:str}) {cmdab:xlaba:ngle}({it:str}) 
		  {cmdab:msym:bol}({it:str}) {cmdab:ms:ize}({it:str}) {cmdab:mlwid:th}({it:str})
		  {cmd:xlabel}({it:str}) {cmd:xtitle}({it:str}) {cmd:ytitle}({it:str}) {cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:note}({it:str}) 
		  {cmd:ysize}({it:num}) {cmd:xsize}({it:num}) {cmd:scheme}({it:str}) {cmd:name}({it:str}) {cmd:]}


{p 4 4 2}
The options are described as follows:

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt bumparea y x, by(group)}}The command requires a numeric {it:y} variable and a numeric {it:x} variable. The x variable is usually a time variable.
The {opt by()} variable defines the groupings.{p_end}

{p2coldent : {opt top(num)}}The number of rows to show in the graph. The default option is {top(10)}. All other values are dropped.{p_end}

{p2coldent : {opt sel:ect(any|last)}}The option {opt sel(any)} selects {opt top()} for all x-axis categories. This is the default and also shows {opt by()} categories moving in and out
of the {opt top()}. The option {opt sel(last)} tracks the path of the {top()} for the last x-axis category.{p_end}

{p2coldent : {opt smooth(num)}}The smoothing parameter that ranges from 1-8. The default value is {opt smooth(4)}. A value of 1 shows straight lines,
while a value of 8 shows almost vertical jumps.{p_end}

{p2coldent : {opt palette(str)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette tableau:{it:tableau}}.{p_end}

{p2coldent : {opt offset(num)}}Extends the x-axis range to accommodate labels. The default value is {opt offset(15)} for 15% of {it:xmax-xmin}.{p_end}

{p2coldent : {opt lw:idth(str)}}The line width of the area stroke. The default is {opt lw(0.8)}.{p_end}

{p2coldent : {opt labs:ize(str)}}Size of the {opt by()} category labels. Default value is {opt labs(2.8)}.{p_end}

{p2coldent : {opt xlabs:ize(str)}}Size of the x-axis labels. Default value is {opt xlabs(2.5)}.{p_end}

{p2coldent : {opt ylabs:ize(str)}}Size of the y-axis labels. Default value is {opt ylabs(2.5)}.{p_end}

{p2coldent : {opt xlaba:ngle(str)}}Angle of the x-axis labels. Default is {opt xlaba(0)} for horizontal.{p_end}

{p2coldent : {opt msym:bol(str)}}Symbol for markers. Default is {opt msym(2.5)}.{p_end}

{p2coldent : {opt ms:ize(str)}}Size of markers. Default is {opt ms(2)}.{p_end}

{p2coldent : {opt mlwid:th(str)}}Size of marker outline width. Default is {opt mlwid(medium)}.{p_end}

{p2coldent : {opt xtitle, ytitle, xsize, ysize}}These are standard twoway graph options.{p_end}

{p2coldent : {opt title, subtitle, note, name}}These are standard twoway graph options.{p_end}

{p2coldent : {opt scheme(string)}}Load the custom scheme. Above options can be used to fine tune individual elements.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

The {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palette} package (Jann 2018, 2022) is required:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have these installed, it is highly recommended to check for updates: {stata ado update, update}

{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-bumpline":GitHub}.

{hline}

{title:Acknowledgements}


{title:Package details}

Version      : {bf:bumpline} v1.0
This release : 10 Apr 2023
First release: 10 Apr 2023
Repository   : {browse "https://github.com/asjadnaqvi/stata-bumpline":GitHub}
Keywords     : Stata, graph, bump chart, rank plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-alluvial/issues":GitHub} by opening a new issue.

{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43. 


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb joyplot}, 
	{helpb marimekko}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb streamplot}, {helpb sunburst}, {helpb treecluster}, {helpb treemap}