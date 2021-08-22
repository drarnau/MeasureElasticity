*************************************************************************************
*This do-file reads the raw data, produces Tables 1 and 4, and creates DataInputs.csv
*************************************************************************************

*Clear all
clear all

* Define slash
if "`c(os)'" == "Windows" {
	global MySlash "\"
}
else {
	global MySlash "/"
}

*************************
*Prepare UN SNA Table 1.1
*************************

*Import UN SNA table 1.1
import delimited "RawData${MySlash}UN_TABLE1.1.csv", clear

*Rename
ren countryorarea country

*Keep SNA2008 (latest revision)
keep if (inlist(country,"Canada","France","Germany","Italy","Japan","United Kingdom","United States","Switzerland") & inlist(series,1000)) | (country == "Iceland" & inlist(series,1100))

*Only keep relevant variables
keep country item year value

*Rename the values of item (variable names)
replace item = "C_HH" if item == "Household final consumption expenditure"
replace item = "C_NPISHs" if item == "NPISHs final consumption expenditure"
replace item = "G" if item == "General government final consumption expenditure"
replace item = "I" if item == "Gross capital formation"
replace item = "GDP" if item == "Equals: GROSS DOMESTIC PRODUCT"

*Reshape from wide to long
reshape wide value, i(country year) j(item) string

*Rename variables
foreach var of varlist value* {
	local newname = substr("`var'", 6, .)
	ren `var' `newname'
}

*Save tempfile
tempfile table1_1
save "`table1_1'"


*************************
*Prepare UN SNA Table 1.3
*************************

*Import UN SNA table 1.3
import delimited "RawData${MySlash}UN_TABLE1.3.csv", clear

*Rename
ren countryorarea country

*Keep SNA2008 (latest revision)
keep if inlist(country,"Canada","France","Germany","Italy","Japan","United Kingdom","United States","Switzerland","Iceland") & inlist(series,1000)

*Only keep relevant variables
keep country item year value

*Rename the values of item (variable names)
replace item = "Depreciation" if item == "Less: Consumption of fixed capital"

*Reshape from wide to long
reshape wide value, i(country year) j(item) string

*Rename variables
foreach var of varlist value* {
	local newname = substr("`var'", 6, .)
	ren `var' `newname'
}

*Save tempfile
tempfile table1_3
save "`table1_3'"


*************************
*Prepare UN SNA Table 4.5
*************************

*Import UN SNA table 4.5
import delimited "RawData${MySlash}UN_TABLE4.5.csv", clear

*Rename
ren countryorarea country

*Keep SNA2008 (latest revision)
keep if inlist(country,"Canada","France","Germany","Italy","Japan","United Kingdom","United States","Switzerland","Iceland") & inlist(series,1000)

*Only keep relevant variables
keep country item year value

*Rename the values of item (variable names)
replace item = "IT" if item == "Taxes on production and imports, less Subsidies"
replace item = "SS" if item == "Social contributions"

*Reshape from wide to long
reshape wide value, i(country year) j(item) string

*Rename variables
foreach var of varlist value* {
	local newname = substr("`var'", 6, .)
	ren `var' `newname'
}

*Save tempfile
tempfile table4_5
save "`table4_5'"


********************************************************************
*Prepare UN SNA Table 4.9 (2015 missing for Iceland as of July 2021)
********************************************************************

*Import UN SNA table 4.9
import delimited "RawData${MySlash}UN_TABLE4.9.csv", clear

*Rename
ren countryorarea country

*Keep SNA2008 (latest revision)
keep if inlist(country,"Canada","France","Germany","Italy","Japan","United Kingdom","United States","Switzerland","Iceland") & inlist(series,1000)

*Rename the values of item (variable names)
replace item = "DT" if item == "Current taxes on income, wealth, etc."
keep if item == "DT"

*Only keep relevant variables
keep country item year value

*Reshape from wide to long
reshape wide value, i(country year) j(item) string

*Rename variables
foreach var of varlist value* {
	local newname = substr("`var'", 6, .)
	ren `var' `newname'
}

*Save tempfile
tempfile table4_9
save "`table4_9'"


*************************
*Prepare OECD SNA Table 2
*************************

*Import OECD SNA Table 2
import delimited "RawData${MySlash}OECD_TABLE2.csv", clear

*Keep countries
keep if inlist(country,"Canada","France","Germany","Italy","Japan","United Kingdom","United States","Switzerland","Iceland")

*Only keep relevant variables
keep country transaction year value

*Rename the values of transaction (variable names)
replace transaction = "W" if transaction == "Compensation of employees"

*Reshape from wide to long
reshape wide value, i(country year) j(transaction) string

*Rename variables
foreach var of varlist value* {
	local newname = substr("`var'", 6, .)
	ren `var' `newname'
}

*Convert from millions to actual currency
replace W = 1000000*W

*Save tempfile
tempfile table2
save "`table2'"


***************************************************************************************************
*Problem for OPSUE: OECD SNA Table 13 has no data on Iceland, so use UN Table 4.9 for all countries
***************************************************************************************************

*Import UN SNA table 4.9
import delimited "RawData${MySlash}UN_TABLE4.9.csv", clear

*Rename
ren countryorarea country

*Keep SNA2008 (latest revision)
keep if inlist(country,"Canada","France","Germany","Italy","Japan","United Kingdom","United States","Switzerland","Iceland") & inlist(series,1000)

*Rename the values of item (variable names)
replace item = "OPS" if item == "OPERATING SURPLUS, GROSS"
replace item = "MI" if item == "MIXED INCOME, GROSS"
keep if item == "OPS" | item == "MI"

*Only keep relevant variables
keep country item year value

*Reshape from wide to long
reshape wide value, i(country year) j(item) string

*Rename variables
foreach var of varlist value* {
	local newname = substr("`var'", 6, .)
	ren `var' `newname'
}

*Compute OPSUE
gen OPSUE = MI+OPS
drop MI OPS

*Save tempfile
tempfile table4_9_OPSUE
save "`table4_9_OPSUE'"


******************************************
*Prepare OECD CIV_EMPL using OECD_ALFS_EMP
******************************************

*Import OECD CIV_EMPL
import delimited "RawData${MySlash}OECD_ALFS_EMP.csv", clear

*Only keep relevant variables
keep country time value
ren time year
ren value CIV_EMPL

*Save tempfile
tempfile CIV_EMPL
save "`CIV_EMPL'"


******************************************************************************************************************************
*Prepare OECD CIV_EMPL using OECD_ALFS_POP_LABOUR (for Switzerland 1995-2005, as OECD_ALFS_EMP is NA for Switzerland pre-1998)
******************************************************************************************************************************

*Import OECD CIV_EMPL
import delimited "RawData${MySlash}OECD_ALFS_POP_LABOUR.csv", clear

*Only keep relevant variables
keep country v4 time value
ren time year

*Rename the values of unit (variable names)
replace v4 = "CIV_EMPL_POP_LABOUR" if v4 == "Civilian employment"

*Reshape from wide to long
reshape wide value, i(year) j(v4) string

*Rename variables
foreach var of varlist value* {
	local newname = substr("`var'", 6, .)
	ren `var' `newname'
}

*Save tempfile
tempfile CIV_EMPL_POP_LABOUR
save "`CIV_EMPL_POP_LABOUR'"


********************
*Prepare WB MIL_EMPL
********************

*Import WB MIL_EMPL
import delimited "RawData${MySlash}World_Bank_Armed_Forces_Personnel.csv", clear

*Only keep relevant variables
ren countryname country
keep country seriescode yr*

*Keep countries
keep if inlist(country,"Canada","France","Germany","Italy","Japan","United Kingdom","United States","Switzerland","Iceland")

*Reshape to long
destring yr*, replace force
reshape long yr, i(country seriescode) j(year)

*Rename variables
drop seriescode
ren yr MIL_EMPL

*Divide by 1000 (to get number in thousands)
replace MIL_EMPL = MIL_EMPL/1000

*Save tempfile
tempfile MIL_EMPL
save "`MIL_EMPL'"


*****************
*Merge all tables
*****************

*Merge
use "`table1_1'"

merge 1:1 country year using "`table1_3'"
drop _merge

merge 1:1 country year using "`table4_5'"
drop _merge

merge 1:1 country year using "`table4_9'"
drop _merge

merge 1:1 country year using "`table2'"
drop _merge

merge 1:1 country year using "`table4_9_OPSUE'"
drop _merge

merge 1:1 country year using "`CIV_EMPL'"
drop _merge

merge m:1 country year using "`CIV_EMPL_POP_LABOUR'"
drop _merge

merge 1:1 country year using "`MIL_EMPL'"
drop _merge


************************************************************
*Compute model inputs separately for
*1) Table 1: Switzerland (1995-2005) and Iceland (2000-2010)
*2) Table 4: G7, Switzerland and Iceland (2000-2015)
************************************************************

*C is sum of HH and NPISHs consumption expenditure
gen C = C_HH + C_NPISHs

*Compute IT_c
gen IT_c = (2/3+(1/3*(C/(C+I))))*IT

*Compute tau_c
gen tau_c = IT_c/(C-IT_c)

*Compute y
gen y = GDP-IT

*Compute alpha (capital share) = 1 - (W + 0.5*entrepreneurial surplus)/y
gen alpha = 1 - (W + 0.5*OPSUE)/y

*Compute average alphas
*Table 1: Switzerland (1995-2005) and Iceland (2000-2010)
*Table 4: Compute average alpha for all 9 countries (2000-2015)
bysort country: egen alpha_avg_table_1 = mean(alpha) if (country == "Switzerland" & inrange(year,1995,2005)) | (country == "Iceland" & inrange(year,2000,2010))
bysort country: egen alpha_avg_table_4 = mean(alpha) if inrange(year,2000,2015)

*Compute tau_ss
gen tau_ss_table_1 = SS/((1-alpha_avg_table_1)*(GDP-IT))
gen tau_ss_table_4 = SS/((1-alpha_avg_table_4)*(GDP-IT))

*Compute tau_inc
gen tau_inc = DT/(GDP-IT-Depreciation)

*Compute military empoyment (y*2*(military employment/total employment))
*Total employment is OECD civilian employment + World Bank military employment
*For Switzerland 1995-2005 in Table 1, use OECD_ALFS_POP_LABOUR for civilian employment (OECD_ALFS_EMP is NA for Switzerland pre-1998)
gen TOT_EMPL_table_4 = CIV_EMPL + MIL_EMPL
gen TOT_EMPL_table_1 = TOT_EMPL_table_4
replace TOT_EMPL_table_1 = CIV_EMPL_POP_LABOUR + MIL_EMPL if country == "Switzerland" & inrange(year,1995,2005)
gen G_mil_table_1 = y*2*(MIL_EMPL/TOT_EMPL_table_1)
gen G_mil_table_4 = y*2*(MIL_EMPL/TOT_EMPL_table_4)

*Compute c
gen c_table_1 = C+G-G_mil_table_1-IT_c
gen c_table_4 = C+G-G_mil_table_4-IT_c

*Compute c/y
gen c_y_table_1 = c_table_1/y
gen c_y_table_4 = c_table_4/y

*Compute marginal tau_inc = 1.6*average tau_inc (assume that average tau_ss = marginal tau_ss)
ren tau_inc avg_tau_inc
gen tau_inc = 1.6*avg_tau_inc


****************************************************************
*Export Table 1: Switzerland (1995-2005) and Iceland (2000-2010)
****************************************************************

*Print LaTeX table header
forval z = 1/1 {
	qui log using "Tables${MySlash}Table_1_inputs.tex", text replace
	di "\begin{tabular}{lcccc}"
	di "& \multicolumn{1}{c}{$\displaystyle \frac{c}{y}$}"
	di "& \multicolumn{1}{c}{$\alpha$}"
	di "& \multicolumn{1}{c}{$\tau^{ss}$}"
	di "& \multicolumn{1}{c}{$\tau^{inc}$} \\[1em]"
	di "\hline"
	di "\hline"
	qui log close
}

*Compute averages and standard errors
local countries "Iceland Switzerland"
local varlist "c_y_table_1 alpha tau_ss_table_1 tau_inc"
foreach v of local varlist{
	foreach c of local countries {
		if "`c'" == "Iceland" {
			qui ci means `v' if country == "`c'" & inrange(year,2000,2010)
			local `v'_`c'_m : di %04.2f r(mean)
			local `v'_`c'_s : di %04.3f r(se)
		}
		else if "`c'" == "Switzerland" {
			qui ci means `v' if country == "`c'" & inrange(year,1995,2005)
			local `v'_`c'_m : di %04.2f r(mean)
			local `v'_`c'_s : di %04.3f r(se)
		}
	}
}

*Print results in LaTeX table
forval z = 1/1 {
	qui log using "Tables${MySlash}Table_1_inputs.tex", text append
	foreach c of local countries {
		di "`c'     & `c_y_table_1_`c'_m'       & `alpha_`c'_m'        & `tau_ss_table_1_`c'_m'          & `tau_inc_`c'_m'     \\"
		di "            & `c_y_table_1_`c'_s'      & `alpha_`c'_s'       & `tau_ss_table_1_`c'_s'         & `tau_inc_`c'_s'     \\"
	}
	di "\hline"
	di "\end{tabular}"
	qui log close
}


********************************************************
*Export Table 4: G7, Switzerland and Iceland (2000-2015)
********************************************************

*Replace spaces in UK and US with underscores
replace country = "United_Kingdom" if country == "United Kingdom"
replace country = "United_States" if country == "United States"

*Print LaTeX table header
forval z = 1/1 {
	qui log using "Tables${MySlash}Table_4_inputs.tex", text replace
	di "\begin{tabular}{lcccc}"
	di "& \multicolumn{1}{c}{$\displaystyle \frac{c}{y}$}"
	di "& \multicolumn{1}{c}{$\alpha$}"
	di "& \multicolumn{1}{c}{$\tau^{ss}$}"
	di "& \multicolumn{1}{c}{$\tau^{inc}$} \\[1em]"
	di "\hline"
	di "\hline"
	qui log close
}

*Compute averages and standard errors
local countries `"Canada France Germany Iceland Italy Japan Switzerland "United_Kingdom" "United_States""'
local varlist "c_y_table_4 alpha tau_ss_table_4 tau_inc"
foreach v of local varlist{
	foreach c of local countries {
		qui ci means `v' if country == "`c'" & inrange(year,2000,2015)
		local `v'_`c'_m : di %04.2f r(mean)
		local `v'_`c'_s : di %04.3f r(se)
	}
}

*Print results in LaTeX table
forval z = 1/1 {
	qui log using "Tables${MySlash}Table_4_inputs.tex", text append
	foreach c of local countries {
		if "`c'" == "United_Kingdom" {
			di "United Kingdom     & `c_y_table_4_`c'_m'       & `alpha_`c'_m'        & `tau_ss_table_4_`c'_m'          & `tau_inc_`c'_m'     \\"
		}
		else if "`c'" == "United_States" {
			di "United States      & `c_y_table_4_`c'_m'       & `alpha_`c'_m'        & `tau_ss_table_4_`c'_m'          & `tau_inc_`c'_m'     \\"
		}
		else {
			di "`c'     & `c_y_table_4_`c'_m'       & `alpha_`c'_m'        & `tau_ss_table_4_`c'_m'          & `tau_inc_`c'_m'     \\"
		}
		di "            & `c_y_table_4_`c'_s'      & `alpha_`c'_s'       & `tau_ss_table_4_`c'_s'         & `tau_inc_`c'_s'     \\"
	}
	di "\hline"
	di "\end{tabular}"
	qui log close
}


*****************************************************************************************
*Export DataInputs.csv, containing the values needed to produce
*1) All Figures: averages as in Table 1 (Switzerland (1995-2005) and Iceland (2000-2010))
*2) Table 2: averages as in Table 4 (G7, Switzerland and Iceland (2000-2015))
*****************************************************************************************

*Compute country averages of c/y and the tax rates
ren c_y_table_1 c_y
ren tau_ss_table_1 tau_ss
foreach var of varlist c_y tau_ss tau_inc {
	bysort country: egen `var'_avg_table_1 = mean(`var') if (country == "Switzerland" & inrange(year,1995,2005)) | (country == "Iceland" & inrange(year,2000,2010))
	bysort country (`var'_avg_table_1): replace `var'_avg_table_1 = `var'_avg_table_1[1]
}

drop c_y tau_ss
ren c_y_table_4 c_y
ren tau_ss_table_4 tau_ss
foreach var of varlist c_y tau_ss tau_inc {
	bysort country: egen `var'_avg_table_4 = mean(`var') if inrange(year,2000,2015)
	bysort country (`var'_avg_table_4): replace `var'_avg_table_4 = `var'_avg_table_4[1]
}

*Only keep one row per country
duplicates drop country, force

*Drop non-model inputs and reorder variables
keep country c_y_avg* alpha_avg* tau_ss_avg* tau_inc_avg*
order country c_y_avg_table_1 alpha_avg_table_1 tau_ss_avg_table_1 tau_inc_avg_table_1 c_y_avg_table_4 alpha_avg_table_4  tau_ss_avg_table_4  tau_inc_avg_table_4

*Export CSV
outsheet using "DataInputs.csv", replace delimiter(",")
