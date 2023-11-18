##################################################################################################################################################################
#####                   SOILPRINT: A REPLICABLE METHOD FOR SOIL DATA UNIQUE IDENTIFICATION SYSTEM  
#####                              AUTHOR: TEGBARU B. GOBEZIE                                                                                                #####

#####   THIS SYSTEM BUILDS UP ON THE RECOMMONDATINS IN THE SOILSHAREWARD MODEL GOBEZIE ET AL., (2023): https://doi.org/10.1038/s43017-023-00439-4            #####

#####         1. GENERATE GEOHASH TO USE AS A SITE SERIAL IDENTIFICATION (SSID)                                                                              #####

##Rrequired packages
library(geohashTools)
library(jsonlite)
library(digest)

##Set Working Directory
setwd(".../SoilPrint") # Replace this with your local repository

##Read Structured and Formatted Soil Data From CSV File  
Soil_data <- read.csv("./Cleaned_OSIS_Example_Data.csv", header = TRUE) # This data is from the Canadian National Pedon Database openly accessible at https://sis.agr.gc.ca/cansis/nsdb/npdb/index.html 

##Generate (Encode) Geohash Using The 'GeohashTools' package
SSID <- sapply(1:nrow(Soil_data), function(i) gh_encode(Soil_data$Latitude[i], Soil_data$Longitude[i], precision = 4)) #Precision is the length/number of the Geohash characters

##Add The Encoded Geohash As SSID To The Original Data
Soil_data$SSID <- SSID

##Get The Distinct SSIDs For Profile Locations Count
SSID_count <- length(unique(Soil_data$SSID))

#####       2. NESTED SOILPRINT APPROACH                                                                                                                    #####

##Select Desired Columns and Reorder Them
soil_layer_info <- Soil_data[, c("SSID", "Year", "Upper", "Lower", "Sand", "Silt", "Clay", "Organic_C")] #These are example soil properties   

##Loop Through Each Row and Create a JSON String of Soil Profile Layers' Properties (SPLP)
SPLP <- list()
for (i in 1:nrow(soil_layer_info)) {
  SPLP[[i]] <- toJSON(soil_layer_info[i, 2:8])
}

GSPLP <- sapply(1:nrow(soil_layer_info), function(i) paste0(soil_layer_info[i,"SSID"], "|", SPLP[[i]])) #GSPLP represents Geohash linked with SPLP 

Soil_data$GSPLP <- GSPLP

##Hash The GSPLP Values Using Secure Hash Algorithm (SHA-256) - This Algorithm Is To Create A Cryptographically Unique Digital ID 
SoilPrints <- sapply(Soil_data$GSPLP, digest, algo = "sha256")

##Add The SoilPrints (Nested) As A New Column To The 'soil_data' Data Frame
Soil_data$SoilPrints_Nested <- SoilPrints

##Check The SoilPrint Format
Check_SoilPrints_Nested<- Soil_data[, c(16,17, 18)]

##Check Uniqueness Of SoilPrints
duplicated_SoilPrints <- duplicated(Soil_data$SoilPrints_Nested)

#Get The Duplicated JSON Strings
duplicated_SoilPrints <- Soil_data$Pedohash_Nested[duplicated_SoilPrints]

##Print The Duplicated Values, if any
if (length(duplicated_SoilPrints) > 0) {
  cat("The following JSON strings are duplicated:\n")
  print(duplicated_SoilPrints)
} else {
  cat("No duplicated JSON strings were found.\n")
}

# #####       3. CUSTOM SOILPRINT APPROACH                                                                                                                    #####
# 
# #################################### This Approach Is Used To Create SPLP1 JSON File Without Linking The SSID With The SPLP ############################################
# 
# ##Loop Through Each Row And Create A JSON String Of Soil Profile Layers' Properties (SPLP)
# SPLP1 <- list()
# for (i in 1:nrow(soil_layer_info)) {
#   SPLP1[[i]] <- toJSON(soil_layer_info[i, 2:8])
# }
# 
# ##Add The SPLP1 List To The 'soil_data' Data Frame As A New Column
# Soil_data$SPLP1 <- SPLP1
# 
# ##Check If Any SPLP1 Strings Are Duplicated
# duplicated_SPLP1 <- duplicated(Soil_data$SPLP1)
# 
# ##Get The Duplicated JSON Strings
# duplicated_SPLP1 <- Soil_data$SPLP1[duplicated_SPLP1]
# 
# ##Print The Duplicated Values, if any
# if (length(duplicated_SPLP1) > 0) {
#   cat("The following JSON strings are duplicated:\n")
#   print(duplicated_SPLP1)
# } else {
#   cat("No duplicated JSON strings were found.\n")
# }
# 
# ##Hash The SPLP1 Values Using SHA-256 Algorithm
# SoilPrint1 <- sapply(Soil_data$SPLP1, digest, algo = "sha256")
# 
# SoilPrints_Custom <- sapply(1:nrow(soil_layer_info), function(i) paste0(soil_layer_info[i,"SSID"], "|", SoilPrint1[[i]])) 
# 
# ##Add The SoilPrints (Custom) As A New Column To The 'soil_data' Data Frame
# Soil_data$SoilPrints_Custom <- SoilPrints_Custom
# 
# ##Select The Columns Of Interest In The 'soil_data'
# Check_SoilPrints_Custom<- Soil_data[, c(16,19, 20)]
# 
# ##Save The Soil_data Object As An RDS (R Data Serialization) File 
# saveRDS(Soil_data, file = "./OSIS_Data_SoilPrint.rds")

#####         4. ORGANIZING AND STRUCTURING THE SORIGINAL SOIL DATA, ALONG WITH THEIR CORRESPONDING SOILPRINTS, FOR INPUT INTO RELATIONAL DATABASE      #####

##Sort The Soil_data 
Soil_data_sorted <- Soil_data[order(Soil_data$SSID, Soil_data$CSSC_Order, Soil_data$Horizon_Number),]

##Select Rows and Columns To Export
#Soil_data_selected <- Soil_data_sorted[1:20, c("SSID", "CSSC_Order", "Latitude", "Longitude", "Upper", "Lower", "SoilPrints_Nested", "SoilPrints_Custom")] 
Soil_data_selected <- Soil_data_sorted[1:20, c("SSID", "CSSC_Order", "Latitude", "Longitude", "Upper", "Lower", "SoilPrints_Nested")] 

##Convert Any List of Columns To Character Strings
for (i in 1:ncol(Soil_data_selected)) {
  if (is.list(Soil_data_selected[[i]])) {
    Soil_data_selected[[i]] <- sapply(Soil_data_selected[[i]], paste, collapse = "; ")
  }
}

##Export The Selected Portion Of The Soil_data With SoilPrints As A CSV File 
write.csv(Soil_data_selected, file = "./Soil_Data_SoilPrints_Selected.csv", row.names = FALSE)

#####                                                     END                                                                              #####
