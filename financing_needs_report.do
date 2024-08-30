********************************************************************************
****** Financing Needs: Generate Sample Report Test 					********
****** Date: Aug 2024													********
****** Author: Olivia													********
******                         										    ********
********************************************************************************

clear all
set more off
capture log close

gl user = c(username)

global data_input "/Users/$user/Dropbox/Corporate Transparency/Data/04_UGANDA RCT/01_Intermediary Data/Financing Needs"
global reports "/Users/$user/Dropbox/Corporate Transparency/Data/04_UGANDA RCT/01_Intermediary Data/Financing Needs/Reports"

use "$data_input/financing_needs_all_REPORT.dta", clear

rename founding_my_4 founding_month
replace founding_month = "July" if founding_month == "July 21"
replace founding_month = "October" if founding_month == "OCTOBER"
replace founding_month = "September" if founding_month == "SEPTEMBER" | founding_month == "September "
replace founding_month = "June" if founding_month == "june"
replace founding_month = "November" if founding_month == "November "

replace revenues_1 = "1700000000" if revenues_2 == "One Billion Seven Hundred Million uganda shillings"
replace revenues_1 = "500000000" if revenues_2 == "Five hundred million"

replace underserved = "Yes" if underserved == "Yes (please explain):"

destring financing_amt_1, gen(financing_amt_numeric)
format financing_amt_numeric %18.0gc

// Report Generation

local N = _N

forvalues i = 1/`N' {

local company_id = company_id[`i']

putpdf begin
putpdf paragraph, font(,14) halign(center)
putpdf text ("Accounting and Financial Management Systems Program:"), bold linebreak(1)
putpdf text ("Financing Needs Survey"), linebreak(1)
putpdf text ("Company ID: ")
putpdf text (company_id[`i'])

putpdf paragraph
putpdf text ("Company Name:"), bold linebreak(1)
putpdf text (company_name[`i'])

putpdf paragraph
putpdf text ("Physical company address (primary office or production space):"), bold linebreak(1)
putpdf text (address[`i'])

putpdf paragraph
putpdf text ("Are you seeking financing for your business, and would you like to participate in the investor matchmaking opportunity?"), bold linebreak(1)
putpdf text (financing[`i'])

putpdf paragraph
putpdf text ("Thank you for expressing interest in the investor matchmaking opportunity. To proceed, we require your consent to handle your application materials."), bold linebreak(1)
putpdf text ("By agreeing, you allow Imuka Access to share these materials exclusively with capital providers who may be interested in supporting your business. We guarantee the confidentiality of your information and will not distribute it to any other third parties without your explicit approval."), bold linebreak(1)
putpdf text (consent[`i'])

putpdf paragraph
putpdf text ("In what sector does your firm operate?"), bold linebreak(1)
putpdf text (sector[`i'])

putpdf paragraph
putpdf text ("Please describe your firm's main business activities in a few sentences, including the main products or services offered."), bold linebreak(1)
putpdf text (business_activity[`i'])

putpdf paragraph
putpdf text ("Does your firm operate in agroprocessing, which includes the processing of agricultural products into food items or other value-added products?"), bold linebreak(1)
putpdf text (agroprocessing[`i'])

if agroprocessing == "Uncertain (please explain):" {
	putpdf paragraph
	putpdf text ("Please explain if you are uncertain."), bold linebreak(1)
	putpdf text (agroprocessing_3_text[`i'])
}

putpdf paragraph
putpdf text ("Is one of the primary goals of your company to: i) Foster agriculture and support smallholder farmers? ii) Foster innovation, digitalization, and/or create jobs?"), bold linebreak(1)
putpdf text (goal_agri_innovation[`i'])

if goal_agri_innovation[`i'] == "Yes, to foster agriculture and support smallholder farmers." | goal_agri_innovation[`i'] == "Yes, both." {
	putpdf paragraph
	putpdf text ("Please describe in detail how your company contributes to agriculture or supports smallholder farmers as a core business objective. Include specific actions, programs, or strategies your company employs to promote sustainable agriculture, increase farmer productivity, improve access to markets, or provide essential resources and training to smallholder farmers. Include any significant projects or achievements that demonstrate your company's dedication to these areas."), bold linebreak(1)
	putpdf text (goal_agri_oe[`i'])
}

if goal_agri_innovation[`i'] == "Yes, both." | goal_agri_innovation[`i'] == "Yes, to foster innovation, digitalization, and/or create jobs." {
	putpdf paragraph
	putpdf text ("Please describe in detail how your company prioritizes innovation, digitalization, and/or job creation as a central business goal. Outline the specific initiatives, technologies, or processes your company uses to drive innovation or digital transformation. Additionally, explain how these efforts contribute to job creation, detailing the types of jobs created and the impact on the community or industry. Include any significant projects or achievements that demonstrate your company's dedication to these areas."), bold linebreak(1)
	putpdf text (goal_innovation_oe[`i'])
}

putpdf paragraph
putpdf text ("What month and year was your firm founded?"), bold linebreak(1)
putpdf text (founding_month[`i'])
putpdf text (" ")
putpdf text (founding_my_5[`i'])

if ops_ug_regions[`i'] != "" {
	putpdf paragraph
	putpdf text ("Does your business have operations in any of the following areas: South Western Region: Isingiro, Bushenyi, Sheema, Ntungamo, Mbarara, Rubanda, Kabale, Kisoro, Kanungu, Mitooma, Rubirizi, Buhweju, Ibanda, Kasese. Northern Uganda: Lamwo, Amuru, Gulu, Nwoya, Omoro, Oyam, Kole, Lira Mount. Elgon area/Eastern Region: Kapchorwa, Bulambuli, Sironko, Bududa, Mbale, Manafwa, Tororo. Karamoja Sub Region: Kabong, Kotido, Abim, Napak, Moroto, Nakapiripirit, Amudat."), bold linebreak(1)
	putpdf text (ops_ug_regions[`i'])
}

putpdf paragraph
putpdf text ("How many full-time employees does your business have? Please include the owners in your response if they are involved full-time in the business' operations."), bold linebreak(1)
putpdf text (ft_employees[`i'])

putpdf paragraph
putpdf text ("How many part-time employees does your business have?"), bold linebreak(1)
putpdf text (pt_employees[`i'])

putpdf paragraph
putpdf text ("Is at least one of your company's founders Ugandan or Kenyan? Please check all that apply."), bold linebreak(1)
if founders_nationality_1[`i'] != "" {
	putpdf text (founders_nationality_1[`i']) 
}
if founders_nationality_4[`i'] != "" {
	putpdf text (founders_nationality_4[`i']) 
}
if founders_nationality_5[`i'] != "" {
	putpdf text (founders_nationality_5[`i']) 
}

putpdf paragraph
putpdf text ("How many owners does your business have?"), bold linebreak(1)
putpdf text (n_owners[`i'])

putpdf paragraph
putpdf text ("What percentage of the business' owners are women?"), bold linebreak(1)
putpdf text (pct_owner_women[`i'])
putpdf text ("%")

putpdf paragraph
putpdf text ("What percentage of the business' senior management (i.e., key decision-makers) are women (including owners)?"), bold linebreak(1)
putpdf text (pct_mgmt_women[`i'])
putpdf text ("%")

if pct_all_women != "" {
	putpdf paragraph
	putpdf text ("What percentage of the business' senior management (i.e., key decision-makers) are women (including owners)?"), bold linebreak(1)
	putpdf text (pct_all_women[`i'])
	putpdf text ("%")
}

putpdf paragraph
putpdf text ("Is the owner or at least one of the owners dedicated to running the business full time?"), bold linebreak(1)
putpdf text (owner_ft[`i'])

putpdf paragraph
putpdf text ("Does your business have a physical location/outlet and an online presence (i.e., Linkedin, Instagram, Facebook) ? Please check all that apply."), bold linebreak(1)
if business_physical_1[`i'] != "" {
	putpdf text (business_physical_1[`i']) 
}
if business_physical_4[`i'] != "" {
	putpdf text (business_physical_4[`i']) 
}
if business_physical_5[`i'] != "" {
	putpdf text (business_physical_5[`i']) 
}

putpdf paragraph
putpdf text ("What were your business' annual revenues over the past 12 months? (in UGX)"), bold linebreak(1)
putpdf paragraph, indent(left,.25)
putpdf text ("Annual revenues (in UGX): "), bold
putpdf text (revenues_1[`i']), nformat(%15.0gc) linebreak(1)
putpdf text ("Please write the amount in words: "), bold
putpdf text (revenues_2[`i'])


putpdf paragraph
putpdf text ("Has the business been profitable over the last financial year?"), bold linebreak(1)
putpdf text (profitable[`i'])

if outstanding_debts[`i'] != "" {
	putpdf paragraph
	putpdf text ("Does your business have outstanding debts that exceed 30% of your business' total assets?"), bold linebreak(1)
	putpdf text (outstanding_debts[`i'])
}

putpdf paragraph
putpdf text ("Would you consider your business to be an underserved enterprise? An underserved enterprise is one that has limited access to traditional financing options such as businesses in rural areas, startups, or those in sectors that are typically overlooked by conventional lenders."), bold linebreak(1)
putpdf text (underserved[`i']), linebreak(1)
if underserved[`i'] == "Yes"{
	putpdf text ("Please explain why you consider your business to be an underserved enterprise: "), bold
	putpdf text (underserved_1_text[`i'])
}

putpdf paragraph
putpdf text ("Does your business have a positive environmental and/or social impact focus? This includes businesses that have environmentally friendly practices, promote social good, or have strong governance structures."), bold linebreak(1)
putpdf text (esg_positive[`i']), linebreak(1)


if esg_positive[`i'] == "Yes"{
	putpdf paragraph
	putpdf text ("Please describe in detail how your business emphasizes environmental and/or social impact. Outline the specific initiatives, sustainability practices, community involvement, or other projects aimed at promoting positive outcomes for the environment or society that your business engages in. Include any significant projects or achievements that demonstrate your company's dedication to these areas."), bold linebreak(1)
	putpdf text (esg_positive_oe[`i'])
}

putpdf paragraph
putpdf text ("Does your business engage in any activities that could potentially cause harm to people or the environment, such as selling harmful products (e.g., tobacco) or practices that may have negative environmental or social impacts?"), bold linebreak(1)
putpdf text (esg_negative[`i']), linebreak(1)


if esg_negative[`i'] == "Yes"{
	putpdf paragraph
	putpdf text ("Please specify:"), bold
	putpdf text (esg_negative_1_text[`i'])
}

if bank_1[`i'] != "" | bank_2[`i'] != "" | bank_3[`i'] != "" | bank_4[`i'] != "" | bank_5[`i'] != "" | bank_6[`i'] != "" | bank_7[`i'] != "" | bank_8[`i'] != "" {
	putpdf paragraph
	putpdf text ("In which bank do you have a business account?"), bold linebreak(1)
	if bank_1[`i'] != "" {
		putpdf text (bank_1[`i']), linebreak(1)
	}

	if bank_2[`i'] != "" {
		putpdf text (bank_2[`i']), linebreak(1)
	}

	if bank_3[`i'] != "" {
		putpdf text (bank_3[`i']), linebreak(1)
	}

	if bank_4[`i'] != "" {
		putpdf text (bank_4[`i']), linebreak(1)
	}
	if bank_5[`i'] != "" {
		putpdf text (bank_5[`i']), linebreak(1)
	}
	if bank_6[`i'] != "" {
		putpdf text (bank_6[`i']), linebreak(1)
	}
	if bank_8[`i'] != "" {
		putpdf text (bank_8[`i']), linebreak(1)
	}

	if bank_7[`i'] != "" {
		putpdf text (bank_7[`i']), linebreak(1)
		putpdf text (bank_7_text[`i'])
	}
}

if bank_usd[`i'] != "" {
	putpdf paragraph
	putpdf text ("Do you have a USD bank account? In other words, would you be able to receive financing in USD?"), bold linebreak(1)
	putpdf text (bank_usd[`i'])
}

putpdf paragraph, font(,14) halign(center)
putpdf text ("Financing Preferences"), linebreak(1)

putpdf paragraph
putpdf text ("What is the approximate amount of financing you are seeking? (UGX)"), bold linebreak(1)
putpdf paragraph, indent(left,.25)
putpdf text ("Numeric value (UGX): "), bold
putpdf text (financing_amt_numeric[`i']), nformat(%15.0gc) linebreak(1)
putpdf text ("Please write the amount in words: "), bold
putpdf text (financing_amt_9[`i'])

// putpdf paragraph
// putpdf text ("What is the MINIMUM amount of financing you are seeking? (UGX)"), bold linebreak(1)
// putpdf text ("Numeric value (UGX): ")
// putpdf text (financing_amt_min_1), linebreak(1)
// putpdf text ("Please write the amount in words: ")
// putpdf text (financing_amt_min_9)

putpdf paragraph
putpdf text ("What are the primary purposes for the financing? (Select all that apply)"), bold linebreak(1)

if financing_purpose_1[`i'] != "" {
	putpdf text (financing_purpose_1[`i']), linebreak(1)
}

if financing_purpose_2[`i'] != "" {
	putpdf text (financing_purpose_2[`i']), linebreak(1)
}

if financing_purpose_3[`i'] != "" {
	putpdf text (financing_purpose_3[`i']), linebreak(1)
}

if financing_purpose_4[`i'] != "" {
	putpdf text (financing_purpose_4[`i']), linebreak(1)
}
if financing_purpose_5[`i'] != "" {
	putpdf text (financing_purpose_5[`i']), linebreak(1)
}
if financing_purpose_6[`i'] != "" {
	putpdf text (financing_purpose_6[`i']), linebreak(1)
}
if financing_purpose_7[`i'] != "" {
	putpdf text (financing_purpose_7[`i']), linebreak(1)
}

if financing_purpose_8[`i'] != "" {
	putpdf text (financing_purpose_8[`i']), linebreak(1)
	putpdf text (financing_purpose_8_text[`i'])
}


putpdf save "$reports/`company_id'_FinancingNeedsSurvey.pdf", replace

}
