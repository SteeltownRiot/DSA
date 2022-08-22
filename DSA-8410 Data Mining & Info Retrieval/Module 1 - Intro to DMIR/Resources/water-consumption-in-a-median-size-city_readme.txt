Please ignore this two lines
#[1] "G:/M/Tesis Molina/Rdata/AguadeHermosillo/desagregada"
#AguaH<- read.csv("AguaH.csv", stringsAsFactors = FALSE, sep = ",")


Variable USO2013
Explanation: this is the type of land use
	Levels:  
		Vegetation area				"AVD" 
		Downtown				"CU"   
		Parks					"EQ" 
		Housing low density			"H1"  
		Housing mid density 			"H2"  
		Housing high density 			"H3"  
		Infrastructure				"IN"  
		High Risk Industry 			"IRA" 
		Low Risk Industry 			"IRB" 
		Medium Risk Industry 			"IRM" 
		Mixed (commerce, housing, industry) 	"MX"  
		Government Reserve 			"RG" 
		Reserve Housing Conditioned		"RHC" 
		Reserve Industry Conditioned 		"RIC"


Variable TU
Explanation: Type of user
	Levels:
		"COMERCIAL" = Commerce
		"DOMESTICO BAJA" = Low Income 
		"DOMESTICO MEDIO" = Median Income
		"DOMESTICO RESIDENCIAL" = High Income 
		"ESPECIAL"   = Big consumer of water (not industry, e.g. carwash)
		"INDUSTRIAL" = Industry
		"SOCIAL = Social Welfare

Variable:CU
Explanation: The diameter of the pipe of the house that is connected to the public grid
	levels in inches 
		"0.5"  
		"0.75" 
		"1"    
		"1.5"  
		"2"    
		"3"    
		"4"    
		"10"  


Variable: M
Explanation: type of vendor of the device that measure the consumption in the house




Variable: UL
Explanation: cubic meters of consumption in January 2016

The rest of the variables are labelled in the following manner f.1_XXX_XX. You can ignore the first fourth letters (f.1_) because it is an error
of the conversion, Im sorry. The first three X referes to the month (ENE means Enero, January in Spanish, Feb means Febrero, February in Spanish and so on).  