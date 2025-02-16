{smcl}
{* 16Feb2025}{...}
{hi:help bumpline}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-bumpline":bumpline v1.4 (GitHub)}}

{hline}

{title:bumpline}: A Stata package for bumpline charts.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:bumpline} {it:y x} {ifin} {weight}, {cmd:by}(varname) 
		{cmd:[} {cmd:top}({it:num}) {cmdab:sel:ect(any|last)} {cmd:smooth}({it:num}) {cmd:palette}({it:str}) {cmd:colorby}({it:var}) {cmd:labcond}({it:str}) {cmd:offset}({it:num}) 
		  {cmd:dropother} {cmd:wrap}({it:num}) {cmd:stat}({it:mean}|{it:sum})  {cmdab:lw:idth}({it:str}) {cmdab:lp:attern}({it:str}) 
		  {cmdab:ms:ize}({it:str}) {cmdab:msym:bol}({it:str}) {cmdab:mc:olor}({it:str}) {cmdab:mlc:olor}({it:str}) {cmdab:mlw:idth}({it:str}) 
		  {cmdab:labs:ize}({it:str}) {cmdab:labc:olor}({it:str}) {cmdab:laba:ngle}({it:str}) {cmdab:labpos:ition}({it:str}) {cmdab:labg:ap}({it:str})
		  {cmdab:olc:olor}({it:str}) {cmdab:olw:idth}({it:str}) {cmdab:olp:attern}({it:str})   
		  {cmdab:omc:olor}({it:str}) {cmdab:omsym:bol}({it:str}) {cmdab:oms:ize}({it:str}) {cmdab:omlc:olor}({it:str}) {cmdab:omlw:idth}({it:str})   
		  {cmdab:olabs:ize}({it:str}) {cmdab:olabc:olor}({it:str}) {cmdab:olaba:ngle}({it:str}) {cmdab:olabpos:ition}({it:str}) {cmdab:olabg:ap}({it:str})
		  {cmdab:ylabs:ize}({it:str}) * {cmd:]}


{p 4 4 2}
The options are described as follows:

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt bumpline y x, by(group)}}The command requires a numeric {it:y} variable and a numeric {it:x} variable. The x variable is usually a time variable.
The {opt by()} variable defines the groupings.{p_end}

{p2coldent : {opt stat(mean|sum)}}If there are multiple observations per {opt by()} and {opt x} variables, then by default the program take the sum by triggering {opt stat(sum)}.
Even though these options is available, preparing the data beforehand is highly recommended.{{p_end}

{p2coldent : {opt top(num)}}The number of rows to show in the graph. The default option is {opt top(50)}. All other values are dropped.{p_end}

{p2coldent : {opt sel:ect(any|last)}}The option {opt sel(any)} selects {opt top()} for all x-axis categories. This is the default and also shows {opt by()} categories moving in and out
of the {opt top()}. The option {opt sel(last)} tracks the path of the {opt top()} for the last x-axis category.{p_end}

{p2coldent : {opt smooth(num)}}The smoothing parameter that ranges from 1-8. The default value is {opt smooth(4)}. A value of 1 shows straight lines,
while a value of 8 shows almost vertical jumps.{p_end}

{p2coldent : {opt palette(str)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette tableau:{it:tableau}}.{p_end}

{p2coldent : {opt colorby(var)}}Color by a specific numeric variable, that takes on discrete values starting from 1. Missing values will be assigned the color after the highest value.{p_end}

{p2coldent : {opt offset(num)}}Extends the x-axis range to accommodate labels. The default value is {opt offset(15)} for 15% of {it:xmax-xmin}.{p_end}

{p2coldent : {opt wrap(num)}}Wrap the labels after a number of characters. For example, {opt wrap(50)} will wrap labels every 50 characters.{p_end}


{it:Lines}

{p2coldent : {opt lw:idth(str)}}Line width. The default is {opt lw(0.8)}.{p_end}

{p2coldent : {opt lp:attern(str)}}Line pattern. The default is {opt lp(solid)}.{p_end}


{it:Markers}

{p2coldent : {opt ms:ize(str)}}Size of markers. Default is {opt ms(2)}.{p_end}

{p2coldent : {opt msym:bol(str)}}Symbol of the markers. Default is {opt msym(2.5)}.{p_end}

{p2coldent : {opt mc:olor(str)}}Color of markers. Default is the {opt lc()} option.{p_end}

{p2coldent : {opt mlwid:th(str)}}Size of marker outline width. Default is {opt mlwid(medium)}.{p_end}

{p2coldent : {opt mlc:olor(str)}}Color of marker outline width. Default is the the {opt lc()} option.{p_end}


{it:Labels}

{p2coldent : {opt labs:ize(str)}}Label size. Default is {opt labs(2.2)}.{p_end}

{p2coldent : {opt labc:olor(str)}}Label color. Default is {opt labc(black)}.{p_end}

{p2coldent : {opt labpos:ition(str)}}Label position. Default is {opt labpos(3)}.{p_end}

{p2coldent : {opt laba:ngle(str)}}Label angle. Default is {opt laba(0)}.{p_end}

{p2coldent : {opt labg:ap(str)}}Label gap. Default is {opt labg(1.5)}.{p_end}


{it:Left y-axis}

{p2coldent : {opt ylabs:ize(str)}}Size of the y-axis labels. Default value is {opt ylabs(2.5)}.{p_end}


{ul:{it:Other categories}}

{p2coldent : {opt dropother}}Drop {opt by()} filler categories that start and end in the middle.
Otherwise, these can be customized using the options below.{p_end}


{it:Other lines}

{p2coldent : {opt olw:idth(str)}}Other line width. The default is {opt olw(0.8)}.{p_end}

{p2coldent : {opt olp:attern(str)}}Other line pattern. The default is {opt olp(solid)}.{p_end}

{p2coldent : {opt olc:olor(str)}}Other line color. The default is {opt olc(gs12)}.{p_end}


{it:Other markers}

{p2coldent : {opt oms:ize(str)}}Size of other markers. Default is the {opt ms()} option.{p_end}

{p2coldent : {opt omsym:bol(str)}}Symbol of other markers. Default is the {opt msym()} option.{p_end}

{p2coldent : {opt omc:olor(str)}}Color of other markers. Default is the {opt olc()} option.{p_end}

{p2coldent : {opt omlc:olor(str)}}Outline color of other markers. Default is the {opt olc()} option.{p_end}

{p2coldent : {opt omlw:idth(str)}}Outline width of other markers. Default is the {opt mlwid()} option.{p_end}


{it:Other labels}

{p2coldent : {opt olabs:ize(str)}}Other label size. Default is {opt olabs(1.8)}.{p_end}

{p2coldent : {opt olabc:olor(str)}}Other label color. Default is {opt olabc(black)}.{p_end}

{p2coldent : {opt olabpos:ition(str)}}Other label position. Default is {opt olabpos(12)}.{p_end}

{p2coldent : {opt olaba:ngle(str)}}Other label angle. Default is {opt olaba(0)}.{p_end}

{p2coldent : {opt olabg:ap(str)}}Other label gap. Default is {opt olabg(1.5)}.{p_end}



{p2coldent : {opt *}}All other standard twoway options not elsewhere specified.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

Please make sure that you have the latest versions of the following packages installed:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}
{stata ssc install graphfunctions, replace}


{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-bumpline":GitHub}.


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-bumpline/issues":GitHub} by opening a new issue.


{title:Citation guidelines}

See {browse "https://ideas.repec.org/c/boc/bocode/s459195.html"} for the official SSC citation. 
Please note that the GitHub version might be newer than the SSC version.


{title:Package details}

Version      : {bf:bumpline} v1.4
This release : 16 Feb 2025
First release: 10 Apr 2023
Repository   : {browse "https://github.com/asjadnaqvi/stata-bumpline":GitHub}
Keywords     : Stata, graph, bump chart, rank plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43. 


{title:Other visualization packages}
{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb graphfunctions}, {helpb geoboundary}, {helpb geoflow}, {helpb joyplot}, 
	{helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot}, {helpb sunburst}, {helpb ternary}, {helpb treecluster}, {helpb treemap}, {helpb trimap}, {helpb waffle}

Visit {browse "https://github.com/asjadnaqvi":GitHub} for further information.	