********************************************************************************
****** Financing Needs Cleaning 							 			********
****** Date: Aug 2024													********
****** Author: Olivia													********
******                         										    ********
********************************************************************************

clear all
set more off
capture log close

gl user = c(username)

global data_input "/Users/$user/Dropbox/Corporate Transparency/Data/04_UGANDA RCT/00_Raw Data/Financing Needs"
global data_output "/Users/$user/Dropbox/Corporate Transparency/Data/04_UGANDA RCT/01_Intermediary Data/Financing Needs"
global eligibility "/Users/$user/Dropbox/Corporate Transparency/Data/04_UGANDA RCT/01_Intermediary Data/Financing Needs/Eligibility"

********************************************************************************
* 1) IMPORT & SAVE ALL QUALTRICS DATA
********************************************************************************
* NEED TO ADJUST FROM QUALTRICS ON AUG 22 FOR THE PCT WOMEN VARS! 
* save control Qualtrics as dta file
import excel using "$data_input/financing_needs_control_aug22.xlsx", firstrow clear

gen treat = 0

save "$data_input/financing_needs_control_aug22.dta", replace

* save treat Qualtrics as dta file
import excel using "$data_input/financing_needs_treat_aug22.xlsx", firstrow clear

gen treat = 1 

save "$data_input/financing_needs_treat_aug22.dta", replace

* append 
append using "$data_input/financing_needs_control_aug22.dta"

// rename all variables to lowercase
rename *, lower(*)

drop if startdate == "Start Date"
drop if finished == "False"
drop if status == "Survey Preview"

destring pct_owner_women_1, replace
gen pct_owner_women = ""
replace pct_owner_women = "Less than 29%" if pct_owner_women_1 < 29 & pct_owner_women_1 != .
replace pct_owner_women = "Between 30%-49%" if pct_owner_women_1 >= 30 & pct_owner_women_1 <= 49 & pct_owner_women_1 != .
replace pct_owner_women = "Between 50%-69%" if pct_owner_women_1 >= 50 & pct_owner_women_1 <= 69 & pct_owner_women_1 != .
replace pct_owner_women = "At least 70%" if pct_owner_women_1 >= 70 & pct_owner_women_1 != .

destring pct_mgmt_women_1, replace
gen pct_mgmt_women = ""
replace pct_mgmt_women = "Less than 29%" if pct_mgmt_women_1 < 29 & pct_mgmt_women_1 != .
replace pct_mgmt_women = "Between 30%-49%" if pct_mgmt_women_1 >= 30 & pct_owner_women_1 <= 49 & pct_owner_women_1 != .
replace pct_mgmt_women = "Between 50%-69%" if pct_mgmt_women_1 >= 50 & pct_owner_women_1 <= 69 & pct_owner_women_1 != .
replace pct_mgmt_women = "At least 70%" if pct_mgmt_women_1 >= 70 & pct_mgmt_women_1 != .

destring pct_all_women_1, replace
gen pct_all_women = ""
replace pct_all_women = "Less than 29%" if pct_all_women_1 < 29 & pct_all_women_1 != .
replace pct_all_women = "Between 30%-49%" if pct_all_women_1 >= 30 & pct_all_women_1 <= 49 & pct_all_women_1 != .
replace pct_all_women = "Between 50%-69%" if pct_all_women_1 >= 50 & pct_all_women_1 <= 69 & pct_owner_women_1 != .
replace pct_all_women = "At least 70%" if pct_all_women_1 >= 70 & pct_all_women_1 != .

keep responseid pct_owner_women pct_mgmt_women pct_all_women

save "$data_input/financing_needs_aug22_women.dta", replace

* save control Qualtrics as dta file
import excel using "$data_input/financing_needs_control.xlsx", firstrow clear

gen treat = 0

save "$data_input/financing_needs_control.dta", replace

* save treat Qualtrics as dta file
import excel using "$data_input/financing_needs_treat.xlsx", firstrow clear

gen treat = 1 

save "$data_input/financing_needs_treat.dta", replace

* append 
append using "$data_input/financing_needs_control.dta"


********************************************************************************
* 2) QUALTRICS Basic Cleaning Data
********************************************************************************
// rename all variables to lowercase
rename *, lower(*)

drop if startdate == "Start Date"
drop if finished == "False"
drop if status == "Survey Preview"

merge 1:1 responseid using "$data_input/financing_needs_aug22_women.dta", replace update
drop _merge

// drop unnecessary Qualtrics vars
drop status ipaddress progress finished recipientlastname recipientfirstname recipientemail externalreference locationlatitude locationlongitude distributionchannel userlanguage

rename responseid fn_qualtrics_id

// drop test IDs
drop if company_name == "g" | company_name == "d" | company_name == "ciao"
drop if fn_qualtrics_id == "R_80OBiO6djdCGtkq" // ITEC Associates filled out survey twice, dropping earlier entry.

// Company IDs
gen company_id = 4576 if company_name == "Msichana Esteem Products Ltd."
replace company_id = 6038 if company_name == "Golden Basket Limited"
replace company_id = 4044 if company_name == "JB PROCUREMENT AGENCIES LTD "
replace company_id = 4334 if company_name == "Easy Ride Auto Rescue"
replace company_id = 4450 if company_name == "Greendoor supplies Uganda limited"
replace company_id = 6002 if company_name == "Zunie Agri-consultancy Ltd(ZAC)"
replace company_id = 5030 if company_name == "Agri Business and Real Estate Investments Limited"
replace company_id = 4619 if company_name == "Bren fresh set Cleaning services."
replace company_id = 5079 if company_name == "DUMARK ENTERPRISES LTD"
replace company_id = 5044 if company_name == "Clepter investments Uganda limited"
replace company_id = 4530 if company_name == "Primus Auto Solutions Limited"
replace company_id = 4527 if company_name == "ITEC Associates Ltd"
replace company_id = 5015 if company_name == "Royal Reach Investments Limited"
replace company_id = 4604 if company_name == "Platinum sourcing limited"
replace company_id = 4578 if company_name == "Provide International Limited"
replace company_id = 5004 if company_name == "Premium Paints and Chemical Products Ltd"
replace company_id = 4604 if company_name == "Platinum sourcing limited"
replace company_id = 4340 if company_name == "Gwokto Energies Limited"
replace company_id = 5060 if company_name == "Amoseph farms (rebranded to Rutah hub)"
replace company_id = 4132 if company_name == "Bravo Shoes Ltd"

label var company_id "\emph{Company ID}"

//Save new dta for report creation
save "$data_output/financing_needs_all_REPORT.dta", replace
 

// Cleaning variables
label define yn_lab 0 "No" 1 "Yes"

label define treat_l 0 "Control" 1 "Treatment"
label val treat treat_l 
 
rename durationinseconds duration_s
destring duration_s, replace
gen duration_m = duration_s/60
label var duration_s "\emph{Survey Duration [Seconds]}"
label var duration_m "\emph{Survey Duration [Minutes]}"

gen double survey_date = clock(recordeddate, "MDY hm")
format survey_date %tc 
sort survey_date
label var survey_date "\emph{Survey Date}"
drop startdate enddate recordeddate 


rename treat_cfo_contact_oe_7_text treat_cfo_contact_oe_text

encode financing, gen(financing_yn)
drop financing
rename financing_yn financing
label var financing "\emph{Firm Seeking Financing [0/1=Yes]}"
label values financing yn_lab

rename no_interest_oe no_interest
rename no_interest_oe_4_text no_interest_text

encode consent, gen(consent_yn)
drop consent
rename consent_yn consent
label val consent yn_lab
label var consent "\emph{Consent to Sharing Financial Documents [0/1=Yes]}"

* Sector
rename sector_9_text sector_ot_text
gen sector_code = . 
replace sector_code = 1 if sector == "Agriculture, Forestry, and Fishing"
replace sector_code = 2 if sector == "Mining"
replace sector_code = 3 if sector == "Construction"
replace sector_code = 4 if sector == "Manufacturing"
replace sector_code = 5 if sector == "Transportation, Communications, Electric, Gas, and Sanitary Services"
replace sector_code = 6 if sector == "Wholesale and Retail Trade"
replace sector_code = 7 if sector == "Finance, Insurance, and Real Estate"
replace sector_code = 8 if sector == "Services"
replace sector_code = 96 if sector == "Other (please specify):"
label define sector_label 1 "Agriculture, Forestry \& Fishing" 2 "Mining" 3 "Construction" 4 "Manufacturing" 5 "Transport, Comm., Electric, Gas \& Sanitary" 6 "Wholesale and Retail Trade" 7 "Finance, Insurance \& Real Estate" 8 "Services" 96 "Other"
label values sector_code sector_label
label var sector_code "\emph{Sector Code}"

gen agroprocessing_yn = .
replace agroprocessing_yn = 0 if agroprocessing == "No"
replace agroprocessing_yn = 1 if agroprocessing == "Yes                                     "
replace agroprocessing_yn = 99 if agroprocessing == "Uncertain (please explain):"
drop agroprocessing
rename agroprocessing_yn agroprocessing
label define yn_uncertain_lab 0 "No" 1 "Yes" 99 "Uncertain"
label values agroprocessing yn_uncertain_lab

rename agroprocessing_3_text agroprocessing_99_text

gen goal_agri = 0
replace goal_agri = 1 if goal_agri_innovation == "Yes, to foster agriculture and support smallholder farmers." | goal_agri_innovation == "Yes, both."
label val goal_agri yn_lab

gen goal_innovation = 0
replace goal_innovation = 1 if goal_agri_innovation == "Yes, to foster innovation, digitalization, and/or create jobs." | goal_agri_innovation == "Yes, both."
label val goal_innovation yn_lab

rename founding_my_4 founding_month
replace founding_month = "July" if founding_month == "July 21"
replace founding_month = "October" if founding_month == "OCTOBER"
replace founding_month = "September" if founding_month == "SEPTEMBER" | founding_month == "September "
replace founding_month = "June" if founding_month == "june"
replace founding_month = "November" if founding_month == "November "

gen founding_month_temp = .
replace founding_month_temp = 1 if founding_month == "January"
replace founding_month_temp = 2 if founding_month == "February"
replace founding_month_temp = 3 if founding_month == "March"
replace founding_month_temp = 4 if founding_month == "April"
replace founding_month_temp = 5 if founding_month == "May"
replace founding_month_temp = 6 if founding_month == "June"
replace founding_month_temp = 7 if founding_month == "July"
replace founding_month_temp = 8 if founding_month == "August"
replace founding_month_temp = 9 if founding_month == "September"
replace founding_month_temp = 10 if founding_month == "October"
replace founding_month_temp = 11 if founding_month == "November"
replace founding_month_temp = 12 if founding_month == "December"
drop founding_month
rename founding_month_temp founding_month
 
label define months 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
label values founding_month months

rename founding_my_5 founding_year 
destring founding_year, replace

gen founding_date = ym(founding_year, founding_month)
format founding_date %tm
list founding_date

local survey_month = month(dofc(survey_date))
local survey_date = ym(2024, `survey_month')

gen company_age = (`survey_date' - founding_date) / 12
format company_age %9.2f
drop founding_date

* Employees
replace ft_employees = "8" if ft_employees == "8 full-time employees"
replace ft_employees = "10" if ft_employees == "Ten"
replace ft_employees = "5" if ft_employees == "5 employees"
replace ft_employees = "3" if ft_employees == "Three"
destring ft_employees, replace

replace pt_employees = "5" if pt_employees == "5 part- time employees" |pt_employees == "Five"
replace pt_employees = "2" if pt_employees == "2 employees"
replace pt_employees = "20" if pt_employees == "15-25"
replace pt_employees = "10" if pt_employees == "more than 10 (Consultants)"
destring pt_employees, replace


gen founders_nationality_ug = 0
replace founders_nationality_ug = 1 if strpos(founders_nationality_1, "at least one of the company") > 0
drop founders_nationality_1


gen founders_nationality_ke = 0
replace founders_nationality_ke = 1 if strpos(founders_nationality_4, "at least one of the company") > 0
drop founders_nationality_4

drop founders_nationality_5

replace n_owners = "2" if n_owners == "2 directors" | n_owners == "Two" | n_owners == "Two directors" | n_owners == "Two ( 1 is QUASI Owner)"
destring n_owners, replace


encode owner_ft, gen(owner_ft_temp)
drop owner_ft
rename owner_ft_temp owner_ft
label val owner_ft yn_lab

gen business_physical = 0
replace business_physical = 1 if business_physical_1 == "Yes, we have a physical location/outlet."
drop business_physical_1
label var business_physical "\emph{Business has Physical Presence [0/1=Yes]}"

gen business_online = 0
replace business_online = 1 if business_physical_4 == "Yes, we have an online presence."
drop business_physical_4
label var business_online "\emph{Business has Online Presence [0/1=Yes]}"

rename business_physical_5 business_no_physicalonline
label var business_no_physicalonline "\emph{Business has Neither Physical nor Online Presence}"

gen flag = ""
replace flag = "Check the business_physical var for some of these; noticed Qualtrics had this question set as only one answer choice allowed previously" if survey_date <= tc("20aug2024 04:11:00")
label var flag "\emph{Post-Survey Flags}"

destring revenues_1, replace
rename revenues_1 revenues_numeric
format revenues_numeric %14.0g
rename revenues_2 revenues_text

replace revenues_numeric = 1700000000 if revenues_text == "One Billion Seven Hundred Million uganda shillings"
replace revenues_numeric = 500000000 if revenues_text == "Five hundred million"

// Pulled from xe.com on 8/20/24
gen revenues_usd_numeric = revenues_numeric * 0.00026910462
format revenues_usd_numeric %12.0g

encode profitable, gen(profitable_temp)
drop profitable
recode profitable_temp (1 = 0 "Non-profitable") (2 = 1 "Profitable"), gen(profitable)
drop profitable_temp
label var profitable "\emph{Business Profitable Over Last Financial Year [0/1=Yes]}"

encode underserved, gen(underserved_temp)
drop underserved
recode underserved_temp (1 = 0 "No") (2=1 "Yes"), gen(underserved)
drop underserved_temp
label var underserved "\emph{Business Considered Underserved Enterprise [0/1=Yes]}"

rename underserved_1_text underserved_text

foreach var in esg_positive esg_negative {
	gen `var'_temp = 0
	replace `var'_temp = 1 if `var' == "Yes"
	drop `var'
	rename `var'_temp `var'
	label val `var' yn_lab
}

rename esg_positive_oe esg_positive_text
rename esg_negative_1_text esg_negative_text

// Bank
rename bank_1 bank_dfcu 
rename bank_2 bank_kcb
rename bank_3 bank_stanbic
rename bank_4 bank_centenary
rename bank_5 bank_absa
rename bank_6 bank_postbank
rename bank_7 bank_ot
rename bank_7_text bank_ot_text
rename bank_8 bank_hasbba 

label var bank_dfcu "\emph{Banks with dfcu}"
label var bank_kcb "\emph{Banks with KCB Uganda}"
label var bank_stanbic "\emph{Banks with Stanbic Bank}"
label var bank_centenary "\emph{Banks with Centenary Bank}"
label var bank_absa "\emph{Banks with Absa Bank Uganda}"
label var bank_postbank "\emph{Banks with PostBank}"
label var bank_ot "\emph{Banks with Other Bank}"
label var bank_ot_text "\emph{Banks with Other Bank [Description]}"
label var bank_hasbba "\emph{Does Not Have Business Bank Account}"

label var bank_usd "\emph{Has USD Bank Account}"

gen ops_ug_regions_temp = 0 if ops_ug_regions == "No"
replace ops_ug_regions_temp = 1 if ops_ug_regions == "Yes"
label val ops_ug_regions_temp yn_lab
drop ops_ug_regions
rename ops_ug_regions_temp ops_ug_regions

// Financing Purpose
gen f_purpose_fa = 0
replace f_purpose_fa = 1 if financing_purpose_1 == "Fixed assets (e.g., purchasing machinery, equipment, property)"
label var f_purpose_fa "\emph{Financing Purpose: Fixed Assets}"

gen f_purpose_wc = 0
replace f_purpose_wc = 1 if financing_purpose_2 == "Working capital (e.g., covering operational expenses, inventory)"
label var f_purpose_wc "\emph{Financing Purpose: Working Capital}"

gen f_purpose_expansion = 0
replace f_purpose_expansion = 1 if financing_purpose_3 == "Expansion (e.g., scaling operations, entering new markets)"
label var f_purpose_expansion "\emph{Financing Purpose: Expansion}"

gen f_purpose_rd = 0
replace f_purpose_rd = 1 if financing_purpose_4 == "R&D (e.g., product development, innovation)"
label var f_purpose_rd "\emph{Financing Purpose: R\&D}"

gen f_purpose_dr = 0
replace f_purpose_dr = 1 if financing_purpose_5 == "Debt refinancing (e.g., consolidating existing debts, improving cash flow)"
label var f_purpose_dr "\emph{Financing Purpose: Debt Refinancing}"

gen f_purpose_marketing = 0
replace f_purpose_marketing = 1 if financing_purpose_6 == "Marketing and sales (e.g., advertising campaigns)"
label var f_purpose_marketing "\emph{Financing Purpose: Marketing}"

gen f_purpose_hr = 0
replace f_purpose_hr = 1 if financing_purpose_7 == "Human resources (e.g., hiring new staff)"
label var f_purpose_hr "\emph{Financing Purpose: Human Resources}"

gen f_purpose_ot = 0
replace f_purpose_ot = 1 if financing_purpose_8 == "Other (please specify):"
label var f_purpose_ot "\emph{Financing Purpose: Other}"

rename financing_purpose_8_text financing_purpose_ot_text

drop financing_purpose_1 financing_purpose_2 financing_purpose_3 financing_purpose_4 financing_purpose_5 financing_purpose_6 financing_purpose_7 financing_purpose_8 

// Unable to send docs
encode documents_unable_0, gen(all_doc_provided)
replace all_doc_provided = 0 if all_doc_provided == .
label var all_doc_provided "\emph{Firm Provided All Documents [0/1=Yes]}"

gen documents_unable_cert = 0
replace documents_unable_cert = 1 if documents_unable_1 == "Certificate of Registration and/or Certificate of Incorporation"
label var documents_unable_cert "\emph{Unable to Provide Certificate of Registration [0/1=Unable]}"

gen documents_unable_moa = 0
replace documents_unable_moa = 1 if documents_unable_2 == "Memorandum of Association and/or Statement of Particulars"
label var documents_unable_moa "\emph{Unable to Provide Memorandum of Association [0/1=Unable]}"

gen documents_unable_profile = 0
replace documents_unable_profile = 1 if documents_unable_3 == "Company Profile and/or Business Plan"
label var documents_unable_profile "\emph{Unable to Provide Company Profile/Business Plan [0/1=Unable]}"

gen documents_unable_cv = 0
replace documents_unable_cv = 1 if documents_unable_4 == "Owner CVs and/or Employee Information"
label var documents_unable_cv "\emph{Unable to Provide Owner CV/Employee Info [0/1=Unable]}"

gen documents_unable_tax = 0
replace documents_unable_tax = 1 if documents_unable_5 == "Tax Clearance Certificate and/or Trading License"
label var documents_unable_tax "\emph{Unable to Provide Tax Clearance/Trading License [0/1=Unable]}"

gen documents_unable_lfs = 0
replace documents_unable_lfs = 1 if documents_unable_6 == "Latest Financial Documents (Balance Sheet, Profit&Loss Statement, Statement of Cashflows)"
label var documents_unable_lfs "\emph{Unable to Provide Latest Financial Statements [0/1=Unable]}"

gen documents_unable_afs = 0
replace documents_unable_afs = 1 if documents_unable_7 == "Audited Finacial Documents  (Balance Sheet, Profit&Loss Statement, Statement of Cashflows)"
label var documents_unable_afs "\emph{Unable to Provide Audited Financial Statements [0/1=Unable]}"

gen documents_unable_ma = 0
replace documents_unable_ma = 1 if documents_unable_8 == "Management Accounts (Accounts Payable Ageing Schedule and Accounts Receivable Ageing Schedule)"
label var documents_unable_ma "\emph{Unable to Provide Management Accounts [0/1=Unable]}"

gen documents_unable_cfp = 0
replace documents_unable_cfp = 1 if documents_unable_9 == "Cash Flow Projections"
label var documents_unable_cfp "\emph{Unable to Provide Cash Flow Projections [0/1=Unable]}"

gen documents_unable_bbs = 0
replace documents_unable_bbs = 1 if documents_unable_10 == "Business Bank Statements"
label var documents_unable_bbs "\emph{Unable to Provide Business Bank Statements [0/1=Unable]}"

gen documents_unable_ufb = 0
replace documents_unable_ufb = 1 if documents_unable_11 == "Use of Financing Brief"
label var documents_unable_ufb "\emph{Unable to Provide Use of Financing Brief [0/1=Unable]}"

gen documents_unable_ch = 0
replace documents_unable_ch = 1 if documents_unable_12 == "Credit History"
label var documents_unable_ch "\emph{Unable to Provide Credit History [0/1=Unable]}"

drop documents_unable_0 documents_unable_1 documents_unable_2 documents_unable_3 documents_unable_4 documents_unable_5 documents_unable_6 documents_unable_7 documents_unable_8 documents_unable_9 documents_unable_10 documents_unable_11 documents_unable_12

foreach var in unable_cert_oe unable_moa_oe unable_profile_oe unable_cv_oe unable_lfs_oe unable_afs_oe unable_ma_oe unable_cfp_oe unable_bbs_oe unable_ufb_oe {
	rename `var' documents_`var'
}
rename unable_taxtrading_oe documents_unable_tax_oe
rename unable_credit_oe documents_unable_ch_oe

label var documents_unable_cert_oe "\emph{Unable to Provide Certificate of Registration [Text]}"
label var documents_unable_moa_oe "\emph{Unable to Provide Memorandum of Association [Text]}"
label var documents_unable_profile_oe "\emph{Unable to Provide Company Profile/Business Plan [Text]}"
label var documents_unable_cv_oe "\emph{Unable to Provide Owner CV/Employee Info [Text]}"
label var documents_unable_tax_oe "\emph{Unable to Provide Tax Clearance/Trading License [Text]}"
label var documents_unable_lfs_oe "\emph{Unable to Provide Latest Financial Statements [Text]}"
label var documents_unable_afs_oe "\emph{Unable to Provide Audited Financial Statements [Text]}"
label var documents_unable_ma_oe "\emph{Unable to Provide Management Accounts [Text]}"
label var documents_unable_cfp_oe "\emph{Unable to Provide Cash Flow Projections [Text]}"
label var documents_unable_bbs_oe "\emph{Unable to Provide Business Bank Statements [Text]}"
label var documents_unable_ufb_oe "\emph{Unable to Provide Use of Financing Brief [Text]}"
label var documents_unable_ch_oe "\emph{Unable to Provide Credit History [0/1=Unable]}"


destring financing_amt_1, replace
rename financing_amt_1 financing_amt_numeric
format financing_amt_numeric %14.0g
rename financing_amt_9 financing_amt_text

destring financing_amt_min_1,replace
rename financing_amt_min_1 financing_amt_min_numeric
format financing_amt_min_numeric %14.0g
rename financing_amt_min_9 financing_amt_min_text

// Pulled from xe.com on 8/20/24
gen financing_amt_usd_numeric = financing_amt_numeric * 0.00026910462
format financing_amt_usd_numeric %12.0g

gen financing_amt_min_usd_numeric = financing_amt_min_numeric * 0.00026910462
format financing_amt_min_usd_numeric %12.0g

encode exclude_investors_yn, gen(excl_investors_temp)
drop exclude_investors_yn
recode excl_investors_temp (1 = 0 "No - Send All") (2=1 "Yes - Exclude"), gen(excl_investors)
drop excl_investors_temp 
label var excl_investors "\emph{Exclude Investors [0/1=Exclude]}"

gen excl_agdevco = 0
replace excl_agdevco = 1 if strpos(exclude_investors_1, "AgDevC") > 0
label var excl_agdevco "\emph{Exclude AgDevCo [0/1=Yes]}"

gen excl_dfcu = 0 
replace excl_dfcu = 1 if strpos(exclude_investors_2, "dfcu Bank") > 0
label var excl_dfcu "\emph{Exclude dfcu Bank [0/1=Yes]}"

gen excl_findingxy = 0 
replace excl_findingxy = 1 if strpos(exclude_investors_3, "Finding XY") > 0
label var excl_findingxy "\emph{Exclude Finding XY [0/1=Yes]}"

gen excl_inua = 0
replace excl_inua = 1 if strpos(exclude_investors_4, "Inua Capital") > 0
label var excl_inua "\emph{Exclude Inua Capital [0/1=Yes]}"

gen excl_iungo = 0
replace excl_iungo = 1 if strpos(exclude_investors_5, "Iungo Capital") > 0
label var excl_iungo "\emph{Exclude Iungo Capital [0/1=Yes]}"

gen excl_kcb = 0
replace excl_kcb = 1 if strpos(exclude_investors_6, "KCB Bank Uganda") > 0
label var excl_kcb "\emph{Exclude KCB Bank Uganda [0/1=Yes]}"

gen excl_konnect = 0
replace excl_konnect = 1 if strpos(exclude_investors_7, "Konnect Initiatives") > 0
label var excl_konnect "\emph{Exclude Konnect Initiatives [0/1=Yes]}"

gen excl_nyota = 0
replace excl_nyota = 1 if strpos(exclude_investors_8, "Nyota Capital") > 0
label var excl_nyota "\emph{Exclude Nyota Capital [0/1=Yes]}"

gen excl_ortus = 0
replace excl_ortus = 1 if strpos(exclude_investors_9, "Ortus Africa Capital") > 0
label var excl_ortus "\emph{Exclude Ortus Africa Capital [0/1=Yes]}"

gen excl_shona = 0
replace excl_shona = 1 if strpos(exclude_investors_10, "SHONA Capital") > 0
label var excl_shona "\emph{Exclude SHONA Capital [0/1=Yes]}"

drop exclude_investors_1 exclude_investors_2 exclude_investors_3 exclude_investors_4 exclude_investors_5 exclude_investors_6 exclude_investors_7 exclude_investors_8 exclude_investors_9 exclude_investors_10

label define exclude_l 0 "Keep App" 1 "Exclude App"
foreach var in excl_agdevco excl_findingxy excl_investors excl_dfcu excl_inua excl_iungo excl_kcb excl_konnect excl_nyota excl_ortus excl_shona {
	label val `var' exclude_l
}

// Save the treatment responses on CFO to a separate dataset, drop from this one
preserve
keep company_name contact_email contact_mobile treat_cfo_contact treat_cfo_contact_oe treat_cfo_contact_oe_text

save "/Users/$user/Dropbox/Corporate Transparency/Data/03_UGANDA SURVEY/01_Intermediary Data/CFO/treat_cfo_contact.dta", replace
restore

drop treat_cfo_contact treat_cfo_contact_oe treat_cfo_contact_oe_text

label var company_name "\emph{Company Name}"
label var treat "\emph{Treatment Status}"
label var contact_email "\emph{Contact Email}"
label var contact_mobile "\emph{Contact Mobile}"
label var address "\emph{Physical Business Address}"
label var sector "\emph{Sector}" 
label var sector_ot_text "\emph{Other Sector [Text]}" 
label var business_activity "\emph{Business Activity}"
label var agroprocessing "\emph{Agroprocessing}"
label var agroprocessing_99_text "\emph{Agroprocessing Uncertain [Text]}" 
label var goal_agri_innovation "\emph{Primary Goal: Foster Agriculture or Innovation}" 
label var goal_agri "\emph{Primary Goal: Foster Agriculture [0/1=Yes]}" 
label var goal_agri_oe "\emph{Primary Goal: Foster Agriculture [Text]}" 
label var goal_innovation "\emph{Primary Goal: Innovation [0/1=Yes]}" 
label var goal_innovation_oe "\emph{Primary Goal: Innovation [Text]}" 

label var no_interest "\emph{Not Interested Confirmation}"
label var no_interest_text"\emph{Not Interested [Text]}"
label var company_age "\emph{Company Age [Years]}"
label var founding_year "\emph{Founding Year}"
label var founding_month "\emph{Founding Month}"
label var ops_ug_regions "\emph{Has Operations in Certain Ugandan Regions [0/1=Yes]}"

label var ft_employees "\emph{Full-Time Employees [Count]}"
label var pt_employees "\emph{Part-Time Employees [Count]}"
label var founders_nationality_ug "\emph{Founder Nationality Ugandan [0/1=Yes]}"
label var founders_nationality_ke "\emph{Founder Nationality Kenyan [0/1=Yes]}"
label var n_owners "\emph{Number of Directors}"
label var owner_ft "\emph{Owner Full Time}"
label var pct_owner_women "\emph{Women-Owned [\%]}"
label var pct_mgmt_women "\emph{Women-Managed [\%]}"
label var pct_all_women "\emph{Women Across Entire Firm [\%]}"
label var outstanding_debts "\emph{Has Outstanding Debts Exceeding 30\% of Assets}"
label var revenues_numeric "\emph{Revenues Last Fiscal Year [Numeric]}"
label var revenues_usd_numeric "\emph{Revenues Last Fiscal Year [USD, Numeric]}"
label var revenues_text "\emph{Revenues Last Fiscal Year [Words]}"
label var profitable "\emph{Business Profitable Last Fiscal Year [0/1=Yes]}"
label var underserved_text "\emph{Business Considered Underserved [Text]}"
label var esg_positive "\emph{ESG Positive Business [0/1=Yes]}"
label var esg_positive_text "\emph{ESG Positive Business [Text]}"
label var esg_negative "\emph{ESG Negative Business [0/1=Yes]}"
label var esg_negative_text "\emph{ESG Negative Business [Text]}"
label var all_doc_provided "\emph{All Documents Provided [0/1=Yes]}"

label var financing_amt_numeric "\emph{Financing Amount [UGX, Numeric]]}"
label var financing_amt_usd_numeric "\emph{Financing Amount [USD, Numeric]]}"
label var financing_amt_text "\emph{Financing Amount [UGX, Words]]}"

label var financing_amt_min_numeric "\emph{Minimum Financing Amount [UGX, Numeric]]}"
label var financing_amt_min_usd_numeric "\emph{Minimum Financing Amount [USD, Numeric]]}"
label var financing_amt_min_text "\emph{Minimum Financing Amount [UGX, Words]]}"

label var financing_purpose_ot_text "\emph{Financing Purpose: Other [Text]}"

order company_id company_name treat financing consent no_interest no_interest_text contact_email contact_mobile address business_physical business_online business_no_physicalonline sector sector_code sector_ot_text business_activity agroprocessing agroprocessing_99_text goal_agri_innovation goal_agri goal_agri_oe goal_innovation goal_innovation_oe ///
company_age founding_year founding_month ops_ug_regions ///
ft_employees pt_employees founders_nationality_ug founders_nationality_ke n_owners owner_ft pct_owner_women pct_mgmt_women pct_all_women outstanding_debts /// 
revenues_numeric revenues_text revenues_usd_numeric profitable underserved underserved_text esg_positive esg_positive_text esg_negative esg_negative_text ///
bank_dfcu bank_kcb bank_stanbic bank_centenary bank_absa bank_postbank bank_ot bank_hasbba bank_ot_text bank_usd /// 
all_doc_provided documents_unable_cert documents_unable_cert_oe documents_unable_moa documents_unable_moa_oe documents_unable_profile documents_unable_profile_oe documents_unable_cv documents_unable_cv_oe documents_unable_tax documents_unable_tax_oe documents_unable_lfs documents_unable_lfs_oe documents_unable_afs documents_unable_afs_oe documents_unable_ma documents_unable_ma_oe documents_unable_cfp documents_unable_cfp_oe documents_unable_bbs documents_unable_bbs_oe documents_unable_ufb documents_unable_ufb_oe documents_unable_ch documents_unable_ch_oe /// 
financing_amt_usd_numeric financing_amt_numeric financing_amt_text financing_amt_min_usd_numeric financing_amt_min_numeric financing_amt_min_text ///
 f_purpose_fa f_purpose_wc f_purpose_expansion f_purpose_rd f_purpose_dr f_purpose_marketing f_purpose_hr f_purpose_ot financing_purpose_ot_text /// 
excl_investors excl_agdevco excl_dfcu excl_findingxy excl_inua excl_iungo excl_kcb excl_konnect excl_nyota excl_ortus excl_shona /// 
survey_date duration_s duration_m fn_qualtrics_id /// 
flag

save "$data_output/financing_needs_all.dta", replace



use "$data_output/financing_needs_all.dta", clear


// merge 1:1 company_id using "/Users/$user/Dropbox/Corporate Transparency/Data/04_UGANDA RCT/02_Cleaned Data/Midline_cleaned.dta", gen(merge1)


********************************************************************************
* 3) Matching Criteria
********************************************************************************
label define eligibility_l 0 "Ineligible" 1 "Eligible"

foreach var in excl_agdevco excl_dfcu excl_findingxy excl_inua excl_iungo excl_kcb excl_konnect excl_nyota excl_ortus excl_shona {
    gen `var'_eligible = 0
// 	gen `var'_manualr = 0

    // strip prefix and rename: eligible
    local newvar = subinstr("`var'_eligible", "excl_", "", 1)
    rename `var'_eligible `newvar'
	label val `newvar' eligibility_l
	
	// strip prefix and rename: send app vs. manual review
//     local newvar2 = subinstr("`var'_manualr", "excl_", "", 1)
//     rename `var'_manualr `newvar2'
	
}

label var agdevco_eligible "\emph{Eligible For AgDevCo [0/1=Yes]}"
label var dfcu_eligible "\emph{Eligible For dfcu Bank [0/1=Yes]}"
label var findingxy_eligible "\emph{Eligible For Finding XY [0/1=Yes]}"
label var inua_eligible "\emph{Eligible For Inua Capital [0/1=Yes]}"
label var iungo_eligible "\emph{Eligible For Iungo Capital [0/1=Yes]}"
label var kcb_eligible "\emph{Eligible For KCB Bank Africa [0/1=Yes]}"
label var konnect_eligible "\emph{Eligible For Konnect Initiatives [0/1=Yes]}"
label var nyota_eligible "\emph{Eligible For Nyota Capital [0/1=Yes]}"
label var ortus_eligible "\emph{Eligible For Ortus Africa Capital [0/1=Yes]}"
label var shona_eligible "\emph{Eligible For SHONA Capital [0/1=Yes]}"

// label var agdevco_manualr "\emph{Manual Review: AgDevCo [0/1= Review]}"
// label var dfcu_manualr "\emph{Manual Review: dfcu Bank [0/1= Review]}"
// label var findingxy_manualr "\emph{Manual Review: Finding XY [0/1= Review]}"
// label var inua_manualr "\emph{Manual Review: Inua Capital [0/1= Review]}"
// label var iungo_manualr "\emph{Manual Review: Iungo Capital [0/1= Review]}"
// label var kcb_manualr "\emph{Manual Review: KCB Bank Africa [0/1= Review]}"
// label var konnect_manualr "\emph{Manual Review: Konnect Initiatives [0/1= Review]}"
// label var nyota_manualr "\emph{Manual Review: Nyota Capital [0/1= Review]}"
// label var ortus_manualr "\emph{Manual Review: Ortus Africa Capital [0/1= Review]}"
// label var shona_manualr "\emph{Manual Review: SHONA Capital [0/1=Review]}"

**************************************************************************
****************** MAPPING OUT REQUIREMENTS FOR EACH CP ******************
**************************************************************************
****** AgDevCo Requirements
// Sector: agriculture
gen agdevco_req_sector = 0
replace agdevco_req_sector = 1 if sector_code == 1

//No ESG negative sectors: 
gen agdevco_req_negesg = 0
replace agdevco_req_negesg = 1 if esg_negative != 1 

// Ticket Size
gen agdevco_req_ts = 1
replace agdevco_req_ts = 0 if financing_amt_usd_numeric <= 0.70*1000000

replace agdevco_eligible = 1 if agdevco_req_sector == 1 & agdevco_req_negesg == 1 & agdevco_req_ts == 1


****** dfcu Bank Requirements

gen dfcu_req_age = 0
replace dfcu_req_age = 1 if company_age >= 2 

replace dfcu_eligible = 1 if dfcu_req_age == 1

****** Finding XY Requirements
// 1. CYK/Main Fund
// Ticket Size 
gen findingxy_cyk_req_ts = 1
replace findingxy_cyk_req_ts = 0 if financing_amt_usd_numeric <= 0.7*500

// Majority women-owned
gen findingxy_cyk_req_women = 0
replace findingxy_cyk_req_women = 1 if pct_owner_women == "Between 50%-69%" | pct_owner_women == "At least 70%"

// Dedicated to operating the business full-time
gen findingxy_cyk_req_owner_ft = owner_ft

// Business operational for at least one year
gen findingxy_cyk_req_age = 0
replace findingxy_cyk_req_age = 1 if company_age >=1

// Involved in sectors or trades that are ESG-responsible - does not have to be ESG positive: manual review
gen findingxy_cyk_req_esg = 0
replace findingxy_cyk_req_esg = 1 if esg_negative == 0

// Maintains a physical location and an online presence  --> needs double checking/confirmation! see if it has to be one or the other.
gen findingxy_cyk_req_location = 0
replace findingxy_cyk_req_location = 1 if business_physical == 1 | business_online == 1

gen findingxy_cyk_eligible = 0
replace findingxy_cyk_eligible = 1 if findingxy_cyk_req_ts == 1 & findingxy_cyk_req_women == 1 & findingxy_cyk_req_owner_ft == 1 & findingxy_cyk_req_age == 1 & findingxy_cyk_req_esg == 1 & findingxy_cyk_req_location == 1


** Women in Agriculture Impact Fund 
// Ticket Size 100k+ 
gen findingxy_wia_req_ts = 0
replace findingxy_wia_req_ts = 1 if financing_amt_usd_numeric >= 0.8*100000

// Actively involved in agriculture and operational for at least 2 years.
gen findingxy_wia_req_agri = 0
replace findingxy_wia_req_agri = 1 if sector_code == 1

//Minimum annual turnover is $100,000 (using 75% of requirement)
gen findingxy_wia_req_revenues = 0
replace findingxy_wia_req_revenues = 1 if revenues_usd_numeric >= 75000

// Company operational for at least 2 years
gen findingxy_wia_req_age = 0
replace findingxy_wia_req_age = 1 if company_age >=2 

// At least 30% female ownership/management, or 50% female representation across the value chain.  --> added value chain question 8/20 only.
gen findingxy_wia_req_women = 0
replace findingxy_wia_req_women = 1 if pct_owner_women == "Between 30%-49%" | pct_owner_women == "Between 50%-69%" | pct_owner_women == "At least 70%" |  pct_mgmt_women == "Between 30%-49%" | pct_mgmt_women == "Between 50%-69%" | pct_mgmt_women == "At least 70%" | pct_all_women == "Between 50%-69%" | pct_all_women == "At least 70%"


// Operations in specific areas
gen findingxy_wia_req_ops = 0 if ops_ug_regions == 0
replace findingxy_wia_req_ops = 1 if ops_ug_regions == 1 

gen findingxy_wia_eligible = 0
replace findingxy_wia_eligible = 1 if findingxy_wia_req_ts == 1 & findingxy_wia_req_agri == 1 & findingxy_wia_req_revenues == 1 & findingxy_wia_req_age == 1 & findingxy_wia_req_women == 1 & findingxy_wia_req_ops == 1

replace findingxy_eligible = 1 if findingxy_cyk_eligible == 1 | findingxy_wia_eligible == 1



****** Inua Capital Requirements
//Goal to foster agriculture/support smallholder farmers and/or foster innovation/digitalization --> requires manual review
gen inua_req_goal = 0
replace inua_req_goal = 1 if goal_agri == 1 | goal_innovation == 1

gen inua_req_revenues = 0
replace inua_req_revenues = 1 if revenues_usd_numeric >= 75000

replace inua_eligible = 1 if inua_req_goal == 1 & inua_req_revenues == 1


****** Iungo Capital Requirements
gen iungo_req_ts = 1
replace iungo_req_ts = 0 if financing_amt_usd_numeric <= 0.7 * 100000

// BINDING REQUIREMENT
gen iungo_req_revenues = 0
replace iungo_req_revenues = 1 if revenues_usd_numeric >= 200000

replace iungo_eligible = 1 if iungo_req_ts == 1 & iungo_req_revenues == 1


****** KCB Bank Africa Requirements
//SDA
gen kcb_sda_req_ts = 0
replace kcb_sda_req_ts = 1 if financing_amt_numeric >= 5000000 

gen kcb_sda_req_purpose = 0
replace kcb_sda_req_purpose = 1 if f_purpose_wc == 1

gen kcb_sda_eligible = 0
replace kcb_sda_eligible = 1 if kcb_sda_req_purpose == 1


// Agricultural Credit Facility
gen kcb_acf_req_sector = 0
replace kcb_acf_req_sector = 1 if sector_code == 1

gen kcb_acf_eligible = 0
replace kcb_acf_eligible = 1 if kcb_acf_req_sector == 1

//General Offerings
gen kcb_gen_req = 1

replace kcb_eligible = 1 if kcb_sda_eligible == 1 | kcb_acf_eligible == 1 | kcb_gen_req == 1 // note: all will be 1 since general requirement.



****** Konnect Initiatives Requirements
// Ticket Size
gen konnect_req_ts = 1
replace konnect_req_ts = 0 if financing_amt_usd_numeric <= 0.7*500 

// Business operational for at least 2 years
gen konnect_req_age = 0
replace konnect_req_age = 1 if company_age >=2

// At least 5 employees  (to confirm if includes part time)
gen konnect_req_employees = 0
replace konnect_req_employees = 1 if ft_employees >= 5

//No outstanding debts exceeding 30% of assets
gen konnect_req_debts = 0 if outstanding_debts == "Yes, we have outstanding debts exceeding 30% of our assets"
replace konnect_req_debts = 1 if outstanding_debts == "No"

replace konnect_eligible = 1 if konnect_req_ts == 1 & konnect_req_age == 1 & konnect_req_employees == 1 & konnect_req_debts == 1


****** Nyota Capital Requirements
// Nyota Angel

// Ticket Size
gen nyota_angel_req_ts = 1
replace nyota_angel_req_ts = 0 if financing_amt_usd_numeric <= 0.7*50000

//Sector (manual check)
gen nyota_angel_req_sector = 0
replace nyota_angel_req_sector = 1 if sector_code == 1 | sector_code == 4 | sector_code == 5 | sector_code == 6 | sector_code == 7 | sector_code == 8 

gen nyota_angel_eligible = 0
replace nyota_angel_eligible = 1 if nyota_angel_req_ts == 1 & nyota_angel_req_sector == 1

// Nyota Growth
// Ticket Size
gen nyota_growth_req_ts = 1
replace nyota_growth_req_ts = 0 if financing_amt_usd_numeric <= 0.7*100000

//Sector
gen nyota_growth_req_sector = 0
replace nyota_growth_req_sector = 1 if sector_code == 1 | sector_code == 4 | sector_code == 5 | sector_code == 6 | sector_code == 7 | sector_code == 8 

//Revenues at least 300k
gen nyota_growth_req_revenues = 0
replace nyota_growth_req_revenues = 1 if revenues_usd_numeric >= 0.9*300000

gen nyota_growth_eligible = 0
replace nyota_growth_eligible = 1 if nyota_growth_req_ts == 1 & nyota_growth_req_sector == 1 & nyota_growth_req_revenues == 1

replace nyota_eligible = 1 if nyota_growth_eligible == 1 | nyota_angel_eligible == 1

****** Ortus Africa Capital Requirements
// Ticket Size
gen ortus_req_ts = 1
replace ortus_req_ts = 0 if financing_amt_usd_numeric <= 0.7 * 5000

// Underserved
gen ortus_req_underserved = 0
replace ortus_req_underserved = 1 if underserved == 1

//Female-led enterprises
gen ortus_req_women = 0
replace ortus_req_women = 1 if pct_owner_women == "Between 50%-69%" | pct_owner_women == "At least 70%" | pct_mgmt_women == "Between 50%-69%" | pct_mgmt_women == "At least 70%" 

//ESG responsible  (both positive and no negative) - need manual review
gen ortus_req_esg = 0
replace ortus_req_esg = 1 if esg_negative != 1 & esg_positive == 1

//Founded at least 2+ years ago ( IN MEETING NOTES BUT NOT PROFILE? CHECK!)
gen ortus_req_age = 0
replace ortus_req_age = 1 if company_age >= 2

replace ortus_eligible = 1 if ortus_req_ts == 1 & ortus_req_underserved == 1 & ortus_req_women == 1 & ortus_req_esg == 1 & ortus_req_age == 1

****** SHONA Capital Requirements

// PROPRIETARY FUND 
// Ticket Size
gen shona_prop_req_ts = 1
replace shona_prop_req_ts = 0 if financing_amt_usd_numeric <= 0.7*5000

// Minimum annual revenue of 36M UGX over past 12 months 
gen shona_prop_req_revenues = 0
replace shona_prop_req_revenues = 1 if revenues_numeric >= 36000000

//At least 2 employees incl. owner
gen shona_prop_req_employees = 0
replace shona_prop_req_employees = 1 if ft_employees >= 2

//In operation for at least 2 years
gen shona_prop_req_age = 0
replace shona_prop_req_age = 1 if company_age >= 2

gen shona_prop_eligible = 0
replace shona_prop_eligible = 1 if shona_prop_req_ts == 1 & shona_prop_req_revenues == 1 & shona_prop_req_employees == 1 & shona_prop_req_age == 1

// NEYCHA ACCELERATOR
// Ticket Size
gen shona_neycha_req_ts = 1
replace shona_neycha_req_ts = 0 if financing_amt_usd_numeric <= 0.7*10000

gen shona_neycha_req_agri = 0
replace shona_neycha_req_agri = 1 if sector_code == 1
 
gen shona_neycha_eligible = 0
replace shona_neycha_eligible = 1 if shona_neycha_req_ts == 1 & shona_neycha_req_agri == 1

// SEGAL FAMILY DEBT FOUNDATION
gen shona_segal_req_ts = 1
replace shona_segal_req_ts = 0 if financing_amt_usd_numeric <= 0.7*50000

gen shona_segal_req_localimpact = 0
replace shona_segal_req_localimpact = 1 if esg_positive == 1 & esg_negative != 1 & founders_nationality_ug == 1 | esg_positive == 1 & esg_negative != 1 & founders_nationality_ug == 1 & founders_nationality_ke == 1

gen shona_segal_eligible = 0
replace shona_segal_eligible = 1 if shona_segal_req_ts == 1 & shona_segal_req_localimpact == 1

replace shona_eligible = 1 if shona_prop_eligible == 1 | shona_neycha_eligible == 1 | shona_segal_eligible == 1 

// Summing across all eligibility indicators
gen tot_eligible = agdevco_eligible + dfcu_eligible + findingxy_eligible + inua_eligible + iungo_eligible + kcb_eligible + konnect_eligible + nyota_eligible + ortus_eligible + shona_eligible

// AgDevCo Requirements
label var agdevco_req_ts "Approximate Ticket Size Match for AgDevCo [0/1=Yes]"
label var agdevco_req_sector "Eligible Sector for AgDevCo [0/1=Yes]"
label var agdevco_req_negesg "No ESG Negative for AgDevCo [0/1=Yes]"

// Finding XY Requirements
label var findingxy_cyk_req_ts "Approximate Ticket Size Match for Finding XY CYK [0/1=Yes]"
label var findingxy_cyk_req_women "Majority Women-Owned for Finding XY CYK [0/1=Yes]"
label var findingxy_cyk_req_owner_ft "Owner Dedicated Full-Time for Finding XY CYK [0/1=Yes]"
label var findingxy_cyk_req_age "Business Operational for >=1 Year for Finding XY CYK [0/1=Yes]"
label var findingxy_cyk_req_esg "ESG-Responsible for Finding XY CYK [0/1=Yes]"
label var findingxy_cyk_req_location "Physical Location/Online Presence for Finding XY CYK [0/1=Yes]"
label var findingxy_cyk_eligible "Eligible for Finding XY CYK Fund"

label var findingxy_wia_req_ts "Approximate Ticket Size Match for Finding XY WIA [0/1=Yes]"
label var findingxy_wia_req_agri "Actively Involved in Agriculture for Finding XY WIA [0/1=Yes]"
label var findingxy_wia_req_revenues "Minimum Annual Turnover for Finding XY WIA [0/1=Yes]"
label var findingxy_wia_req_age "Business Operational for >=2 Years for Finding XY WIA [0/1=Yes]"
label var findingxy_wia_req_women "Female Ownership/Management for Finding XY WIA [0/1=Yes]"
label var findingxy_wia_req_ops "Operations in Specific Areas for Finding XY WIA [0/1=Yes]"
label var findingxy_wia_eligible "Eligible for Finding XY WIA Fund" 

// dfcu Requirements
label var dfcu_req_age "Company Age >= 2 Years for DFCU [0/1=Yes]"


// Inua Capital Requirements
label var inua_req_goal "Goal to Foster Agriculture/Innovation for Inua Capital [0/1=Yes]"
label var inua_req_revenues "Minimum Annual Turnover for Inua Capital [0/1=Yes]"

// Iungo Capital Requirements
label var iungo_req_ts "Approximate Ticket Size Match for Iungo Capital [0/1=Yes]"
label var iungo_req_revenues "Minimum Annual Turnover for Iungo Capital [0/1=Yes]"

// KCB Bank Requirements
label var kcb_sda_req_ts "Approximate Ticket Size Match for KCB SDA [0/1=Yes]"
label var kcb_sda_req_purpose "Working Capital Financing Purpose for KCB SDA [0/1=Yes]"
label var kcb_sda_eligible "Eligible for KCB SDA [0/1=Yes]"
label var kcb_acf_req_sector "Eligible Sector for KCB ACF [0/1=Yes]"
label var kcb_acf_eligible "Eligible for KCB ACF [0/1=Yes]"
label var kcb_gen_req "Eligible for KCB General [0/1=Yes]"

// Konnect Initiatives Requirements
label var konnect_req_ts "Approximate Ticket Size Match for Konnect Initiatives [0/1=Yes]"
label var konnect_req_age "Business Operational for >=2 Years for Konnect Initiatives [0/1=Yes]"
label var konnect_req_employees "Minimum 5 Employees for Konnect Initiatives [0/1=Yes]"
label var konnect_req_debts "Low Outstanding Debts for Konnect Initiatives [0/1=Yes]"

// Nyota Capital Requirements
label var nyota_angel_req_ts "Approximate Ticket Size Match for Nyota Angel [0/1=Yes]"
label var nyota_angel_req_sector "Eligible Sector for Nyota Angel [0/1=Yes]"
label var nyota_angel_eligible "Eligible for Nyota Angel [0/1=Yes]"

label var nyota_growth_req_ts "Approximate Ticket Size Match for Nyota Growth [0/1=Yes]"
label var nyota_growth_req_sector "Eligible Sector for Nyota Growth [0/1=Yes]"
label var nyota_growth_req_revenues "Minimum Annual Turnover for Nyota Growth [0/1=Yes]"
label var nyota_growth_eligible "Eligible for Nyota Growth [0/1=Yes]"

// Ortus Africa Capital Requirements
label var ortus_req_ts "Approximate Ticket Size Match for Ortus Africa Capital [0/1=Yes]"
label var ortus_req_underserved "Underserved Status for Ortus Africa Capital [0/1=Yes]"
label var ortus_req_women "Female-Led Enterprise for Ortus Africa Capital [0/1=Yes]"
label var ortus_req_esg "ESG-Responsible for Ortus Africa Capital [0/1=Yes]"
label var ortus_req_age "Business Operational for >=2 Years for Ortus Africa Capital [0/1=Yes]"

// SHONA Capital Requirements
label var shona_prop_req_ts "Approximate Ticket Size Match for SHONA Proprietary [0/1=Yes]"
label var shona_prop_req_revenues "Minimum Annual Revenue for SHONA Proprietary [0/1=Yes]"
label var shona_prop_req_employees "Minimum 2 Employees for SHONA Proprietary [0/1=Yes]"
label var shona_prop_req_age "Business Operational for >=2 Years for SHONA Proprietary [0/1=Yes]"
label var shona_prop_eligible "Eligible for SHONA Proprietary [0/1=Yes]"

label var shona_neycha_req_ts "Approximate Ticket Size Match for SHONA Neycha Accelerator [0/1=Yes]"
label var shona_neycha_req_agri "Eligible Sector for SHONA Neycha Accelerator [0/1=Yes]"
label var shona_neycha_eligible "Eligible for SHONA Neycha Accelerator [0/1=Yes]"

label var shona_segal_req_ts "Approximate Ticket Size Match for SHONA Segal Debt Facility [0/1=Yes]"
label var shona_segal_req_localimpact "Local Impact Met for SHONA Segal Debt Facility [0/1=Yes]"
label var shona_segal_eligible "Eligible for SHONA Segal Debt Facility [0/1=Yes]"

label var tot_eligible "\emph{Total Eligible Capital Providers [0-10]}"

// Labeling Requirements
label define req_met_l 0 "Requirement Not Met" 1 "Requirement Met"

foreach var in agdevco_req_sector agdevco_req_negesg findingxy_cyk_req_women findingxy_cyk_req_owner_ft findingxy_cyk_req_age findingxy_cyk_req_esg findingxy_cyk_req_location findingxy_wia_req_agri findingxy_wia_req_revenues findingxy_wia_req_age findingxy_wia_req_women agdevco_req_ts dfcu_req_age findingxy_cyk_req_ts findingxy_wia_req_ts findingxy_wia_req_ops inua_req_goal inua_req_revenues iungo_req_ts iungo_req_revenues kcb_sda_req_ts kcb_sda_req_purpose kcb_acf_req_sector kcb_gen_req konnect_req_ts konnect_req_age konnect_req_employees konnect_req_debts nyota_angel_req_ts nyota_angel_req_sector nyota_growth_req_ts nyota_growth_req_sector nyota_growth_req_revenues ortus_req_ts ortus_req_underserved ortus_req_women ortus_req_esg ortus_req_age shona_prop_req_ts shona_prop_req_revenues shona_prop_req_employees shona_prop_req_age shona_neycha_req_ts shona_neycha_req_agri shona_segal_req_ts shona_segal_req_localimpact {
	label val `var' req_met_l
}

foreach var in findingxy_cyk_eligible findingxy_wia_eligible kcb_sda_eligible kcb_acf_eligible nyota_angel_eligible nyota_growth_eligible shona_prop_eligible shona_neycha_eligible shona_segal_eligible {
label val `var' eligibility_l
}

order company_id company_name treat ///
excl_agdevco agdevco_eligible agdevco_req_ts agdevco_req_sector agdevco_req_negesg /// AGDEVCO
excl_findingxy findingxy_eligible findingxy_cyk_req_ts findingxy_cyk_req_women findingxy_cyk_req_owner_ft findingxy_cyk_req_age findingxy_cyk_req_esg findingxy_cyk_req_location findingxy_cyk_eligible findingxy_wia_req_ts findingxy_wia_req_agri findingxy_wia_req_revenues findingxy_wia_req_age findingxy_wia_req_women findingxy_wia_eligible /// finding XY 
excl_dfcu dfcu_eligible dfcu_req_age /// DFCU BANK
excl_inua inua_eligible inua_req_goal inua_req_revenues /// INUA CAPITAL
excl_iungo iungo_eligible iungo_req_ts iungo_req_revenues /// IUNGO CAPITAL
excl_kcb kcb_eligible kcb_sda_req_purpose kcb_sda_eligible kcb_acf_req_sector kcb_acf_eligible kcb_gen_req /// KCB BANK 
excl_konnect konnect_eligible konnect_req_ts konnect_req_age konnect_req_employees konnect_req_debts /// KONNECT INITIATIVES
excl_nyota nyota_eligible nyota_angel_req_ts nyota_angel_req_sector nyota_angel_eligible nyota_growth_req_ts nyota_growth_req_sector nyota_growth_req_revenues nyota_growth_eligible /// NYOTA GROWTH
excl_ortus ortus_eligible ortus_req_ts ortus_req_underserved ortus_req_women ortus_req_esg ortus_req_age /// ORTUS AFRICA CAPITAL
excl_shona shona_eligible shona_prop_req_ts shona_prop_req_revenues shona_prop_req_employees shona_prop_req_age shona_prop_eligible shona_neycha_req_ts shona_neycha_req_agri shona_neycha_eligible shona_segal_req_ts shona_segal_req_localimpact shona_segal_eligible /// SHONA CAPITAL


save "$data_output/financing_needs_all_eligibility.dta", replace

// Export into Test Excel Format for Manual Review

// AgDevCo Sheet
preserve 
keep company_id company_name survey_date excl_agdevco agdevco_eligible agdevco_req_ts financing_amt_usd_numeric agdevco_req_sector sector business_activity goal_agri_innovation goal_agri_oe agroprocessing agroprocessing_99_text agdevco_req_negesg esg_positive esg_positive_text esg_negative esg_negative_text  

sort survey_date 

order company_id company_name survey_date excl_agdevco agdevco_eligible agdevco_req_ts agdevco_req_sector agdevco_req_negesg financing_amt_usd_numeric  sector business_activity goal_agri_innovation goal_agri_oe agroprocessing agroprocessing_99_text esg_positive esg_positive_text esg_negative esg_negative_text 


export excel using "$eligibility/CP_Eligibility.xlsx", sheet("AgDevCo") firstrow(varlabels) replace
restore 

// dfcu Sheet
preserve 
keep company_id company_name survey_date excl_dfcu dfcu_eligible dfcu_req_age company_age 
sort survey_date 

order company_id company_name survey_date excl_dfcu dfcu_eligible dfcu_req_age company_age 

export excel using "$eligibility/CP_Eligibility.xlsx", sheet("DFCU") firstrow(varlabels) sheetreplace
restore 

// Finding XY Sheet
preserve 
keep company_id company_name survey_date excl_findingxy findingxy_eligible findingxy_cyk_req_ts findingxy_cyk_req_women findingxy_cyk_req_owner_ft findingxy_cyk_req_age findingxy_cyk_req_esg findingxy_cyk_req_location findingxy_cyk_eligible findingxy_wia_req_ts findingxy_wia_req_agri findingxy_wia_req_revenues findingxy_wia_req_age findingxy_wia_req_women findingxy_wia_eligible ///
financing_amt_usd_numeric pct_owner_women pct_mgmt_women pct_all_women owner_ft company_age esg_positive esg_positive_text esg_negative esg_negative_text ops_ug_regions sector business_activity goal_agri_innovation goal_agri_oe agroprocessing agroprocessing_99_text revenues_numeric revenues_text 

sort survey_date 

order company_id company_name survey_date excl_findingxy findingxy_eligible findingxy_cyk_req_ts findingxy_cyk_req_women findingxy_cyk_req_owner_ft findingxy_cyk_req_age findingxy_cyk_req_esg findingxy_cyk_req_location findingxy_cyk_eligible findingxy_wia_req_ts findingxy_wia_req_agri findingxy_wia_req_revenues findingxy_wia_req_age findingxy_wia_req_women findingxy_wia_eligible ///
financing_amt_usd_numeric pct_owner_women pct_mgmt_women pct_all_women owner_ft company_age esg_positive esg_positive_text esg_negative esg_negative_text ops_ug_regions sector business_activity goal_agri_innovation goal_agri_oe agroprocessing agroprocessing_99_text revenues_numeric revenues_text 

export excel using "$eligibility/CP_Eligibility.xlsx", sheet("Finding XY") firstrow(varlabels) sheetreplace
restore 

// Iungo Capital Sheet
preserve 
keep company_id company_name survey_date excl_iungo iungo_eligible iungo_req_ts iungo_req_revenues financing_amt_usd_numeric revenues_usd_numeric 

sort survey_date 

order company_id company_name survey_date excl_iungo iungo_eligible iungo_req_ts iungo_req_revenues financing_amt_usd_numeric revenues_usd_numeric

export excel using "$eligibility/CP_Eligibility.xlsx", sheet("Iungo Capital") firstrow(varlabels) sheetreplace
restore 

// Inua Capital Sheet
preserve 
keep company_id company_name survey_date excl_inua inua_eligible inua_req_goal inua_req_revenues revenues_usd_numeric goal_agri_innovation goal_agri goal_agri_oe goal_innovation goal_innovation_oe

sort survey_date 

order company_id company_name survey_date excl_inua inua_eligible inua_req_goal inua_req_revenues revenues_usd_numeric goal_agri_innovation goal_agri goal_agri_oe goal_innovation goal_innovation_oe

export excel using "$eligibility/CP_Eligibility.xlsx", sheet("Inua Capital") firstrow(varlabels) sheetreplace
restore 

// KCB Bank Sheet
preserve 
keep company_id company_name survey_date excl_kcb kcb_eligible kcb_sda_req_ts kcb_sda_req_purpose kcb_sda_eligible kcb_acf_req_sector kcb_acf_eligible kcb_gen_req financing_amt_numeric f_purpose_wc sector business_activity agroprocessing agroprocessing_99_text

sort survey_date 

order company_id company_name survey_date excl_kcb kcb_eligible kcb_sda_req_ts kcb_sda_req_purpose kcb_sda_eligible kcb_acf_req_sector kcb_acf_eligible kcb_gen_req financing_amt_numeric f_purpose_wc sector business_activity agroprocessing agroprocessing_99_text

export excel using "$eligibility/CP_Eligibility.xlsx", sheet("KCB Bank") firstrow(varlabels) sheetreplace
restore 

// Konnect Initiatives Sheet
preserve 
keep company_id company_name survey_date excl_konnect konnect_eligible konnect_req_ts konnect_req_age konnect_req_employees konnect_req_debts financing_amt_usd_numeric company_age ft_employees pt_employees outstanding_debts

sort survey_date 

order company_id company_name survey_date excl_konnect konnect_eligible konnect_req_ts konnect_req_age konnect_req_employees konnect_req_debts financing_amt_usd_numeric company_age ft_employees pt_employees outstanding_debts

export excel using "$eligibility/CP_Eligibility.xlsx", sheet("Konnect Initiatives") firstrow(varlabels) sheetreplace
restore 

// Nyota Sheet
preserve 
keep company_id company_name survey_date excl_nyota nyota_eligible nyota_angel_req_ts nyota_angel_req_sector nyota_angel_eligible nyota_growth_req_ts nyota_growth_req_sector nyota_growth_req_revenues nyota_growth_eligible financing_amt_usd_numeric sector business_activity agroprocessing agroprocessing_99_text revenues_usd_numeric 

sort survey_date 

order company_id company_name survey_date excl_nyota nyota_eligible nyota_angel_req_ts nyota_angel_req_sector nyota_angel_eligible nyota_growth_req_ts nyota_growth_req_sector nyota_growth_req_revenues nyota_growth_eligible financing_amt_usd_numeric sector business_activity agroprocessing agroprocessing_99_text revenues_usd_numeric 

export excel using "$eligibility/CP_Eligibility.xlsx", sheet("Nyota Capital") firstrow(varlabels) sheetreplace
restore 

// Ortus Sheet
preserve 
keep company_id company_name survey_date excl_ortus ortus_eligible ortus_req_ts ortus_req_underserved ortus_req_women ortus_req_esg ortus_req_age financing_amt_usd_numeric underserved underserved_text pct_owner_women pct_mgmt_women esg_positive esg_positive_text esg_negative esg_negative_text company_age 

sort survey_date 

order company_id company_name survey_date excl_ortus ortus_eligible ortus_req_ts ortus_req_underserved ortus_req_women ortus_req_esg ortus_req_age financing_amt_usd_numeric underserved underserved_text pct_owner_women pct_mgmt_women esg_positive esg_positive_text esg_negative esg_negative_text company_age 

export excel using "$eligibility/CP_Eligibility.xlsx", sheet("Ortus Africa Capital") firstrow(varlabels) sheetreplace
restore 


// SHONA Sheet
preserve 
keep company_id company_name survey_date excl_shona shona_eligible shona_prop_req_ts shona_prop_req_revenues shona_prop_req_employees shona_prop_req_age shona_prop_eligible shona_neycha_req_ts shona_neycha_req_agri shona_neycha_eligible shona_segal_req_ts shona_segal_req_localimpact shona_segal_eligible financing_amt_usd_numeric revenues_numeric revenues_text ft_employees company_age sector business_activity agroprocessing agroprocessing_99_text founders_nationality_ug founders_nationality_ke esg_positive esg_positive_text esg_negative esg_negative_text

sort survey_date 

order company_id company_name survey_date excl_shona shona_eligible shona_prop_req_ts shona_prop_req_revenues shona_prop_req_employees shona_prop_req_age shona_prop_eligible shona_neycha_req_ts shona_neycha_req_agri shona_neycha_eligible shona_segal_req_ts shona_segal_req_localimpact shona_segal_eligible financing_amt_usd_numeric revenues_numeric revenues_text ft_employees company_age sector business_activity agroprocessing agroprocessing_99_text founders_nationality_ug founders_nationality_ke esg_positive esg_positive_text esg_negative esg_negative_text

export excel using "$eligibility/CP_Eligibility.xlsx", sheet("SHONA Capital") firstrow(varlabels) sheetreplace
restore 
