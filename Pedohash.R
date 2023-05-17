#####                   A REPLICABLE METHOD FOR SOIL DATA UNIQUE IDENTIFICATION SYSTEM                                     #####
#####         GENERATING GEOHASH TO USE AS SITE SERIAL IDENTIFICATION (SSID)                                               #####

# Call required packages
library(geohashTools)
library(jsonlite)
library(digest)

# Read soil data from csv file  
Soil_data <- read.csv("/Users/tegbaru/Documents/Publish@UoG/Pedohsh/Data_and_Visualization/Cleaned_OSIS_Data_for_Pedohash.csv", header = TRUE) # This is a data from the openly accessible National Pedon Database

# Generate (encode) geohash using the function package GeohashTools
SSID <- sapply(1:nrow(Soil_data), function(i) gh_encode(Soil_data$Latitude[i], Soil_data$Longitude[i], precision = 12))

# Add the encoded Geohash as SSID to the original data
Soil_data$SSID <- SSID

# Get the distinct SSIDs to get count of the profile locations
SSID_count <- length(unique(Soil_data$SSID))

#####                                    NESTED PEDOHASH                                                                    #####


# Select desired columns and reorder
soil_layer_info <- Soil_data[, c("SSID", "Year", "Upper", "Lower", "Sand", "Silt", "Clay", "Organic_C")] #The list of soil properties are examples  

# Loop through each row and create a JSON string of soil profile layers properties (SPLP)
SPLP <- list()
for (i in 1:nrow(soil_layer_info)) {
  SPLP[[i]] <- toJSON(soil_layer_info[i, 2:8])
}

GSPLP <- sapply(1:nrow(soil_layer_info), function(i) paste0(soil_layer_info[i,"SSID"], "|", SPLP[[i]])) #GSPLP stands for Geohash linked with SPLP 

Soil_data$GSPLP <- GSPLP

# Hash the GSPLP values using SHA256 algorithm - this is to create a cryptographically unique digital ID 
Pedohashes <- sapply(Soil_data$GSPLP, digest, algo = "sha256")

# Add the Pedohashes (nested) as a new column to the soil_data data frame
Soil_data$Pedohash_Nested <- Pedohashes

#Check the Pedohash format
Check_Pedohashes_Nested<- Soil_data[, c(16,17, 18)]

#Check uniqueness of Pedohashes
duplicated_Pedohashes <- duplicated(Soil_data$Pedohash_Nested)

# Get the duplicated JSON strings
duplicated_Pedohashes <- Soil_data$Pedohash_Nested[duplicated_Pedohashes]

# Print the duplicated values, if any
if (length(duplicated_Pedohashes) > 0) {
  cat("The following JSON strings are duplicated:\n")
  print(duplicated_Pedohashes)
} else {
  cat("No duplicated JSON strings were found.\n")
}

#####                                    CUSTOM PEDOHASH                                                                    #####

#################################### Create SPLP1 JSON file without linking the SSID with the SPLP ############################################

# Loop through each row and create a JSON string of soil profile layers properties (SPLP)
SPLP1 <- list()
for (i in 1:nrow(soil_layer_info)) {
  SPLP1[[i]] <- toJSON(soil_layer_info[i, 2:8])
}

# Add the SPLP1 list to the soil_data data frame as a new column
Soil_data$SPLP1 <- SPLP1

# Check if any SPLP1 strings are duplicated
duplicated_SPLP1 <- duplicated(Soil_data$SPLP1)

# Get the duplicated JSON strings
duplicated_SPLP1 <- Soil_data$SPLP1[duplicated_SPLP1]

# Print the duplicated values, if any
if (length(duplicated_SPLP1) > 0) {
  cat("The following JSON strings are duplicated:\n")
  print(duplicated_SPLP1)
} else {
  cat("No duplicated JSON strings were found.\n")
}

# Hash the SPLP1 values using SHA256 algorithm
Pedohashes1 <- sapply(Soil_data$SPLP1, digest, algo = "sha256")

Pedohash_Custom <- sapply(1:nrow(soil_layer_info), function(i) paste0(soil_layer_info[i,"SSID"], "|", Pedohashes1[[i]])) #GSPLP1 stands for Geohash linked with soil profile layers properties and created using the custom approach

# Add the Pedohashes (custom) as a new column to the soil_data data frame
Soil_data$Pedohash_Custom <- Pedohash_Custom

# Select the columns of interest in the soil_data
Check_Pedohash_Custom<- Soil_data[, c(16,19, 20)]

# Save the Soil_data object as an RDS (R Data Serialization) file 
saveRDS(Soil_data, file = "/Users/tegbaru/Documents/Publish@UoG/Pedohsh/Data_and_Visualization/OSIS_Data_Pedohash.rds")

#####                           The portion of the Soil_data with Pedohashes  (for visualization)                       #####

#Sort the Soil_data 
Soil_data_sorted <- Soil_data[order(Soil_data$SSID, Soil_data$CSSC_Order, Soil_data$Horizon_Number),]

# Select rows and columns to export
Soil_data_selected <- Soil_data_sorted[1:20, c("SSID", "CSSC_Order", "Latitude", "Longitude", "Upper", "Lower", "GSPLP", "Pedohash_Nested", "SPLP1", "Pedohash_Custom")] 

# Convert any list columns to character strings
for (i in 1:ncol(Soil_data_selected)) {
  if (is.list(Soil_data_selected[[i]])) {
    Soil_data_selected[[i]] <- sapply(Soil_data_selected[[i]], paste, collapse = "; ")
  }
}

# Export the selected portion of the Soil_data with Pedohashes as a csv file 
write.csv(Soil_data_selected, file = "/Users/tegbaru/Documents/Publish@UoG/Pedohsh/Data_and_Visualization/OSIS_Data_Pedohash_Selected.csv", row.names = FALSE)

#####                                           END                                                                     #####