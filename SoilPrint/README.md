# SoilPrint

## A Unique Identification System for Preserving Privacy of Soil Data

This code and example dataset is associated with the manuscript titled "Preserving Soil Data Privacy with SoilPrint: A Unique Soil Identification System for Soil Data Sharing" by Gobezie and Biswas, 2023 (Revision requested).   

Manuscript citation: Gobezie, T.B. and Biswas, A., 2023. Preserving Soil Data Privacy with SoilPrint: A Unique Soil Identification System for Soil Data Sharing. Geoderma. GEODER-D-23-01338 (Revision requested).               

## Definitions
1.    SoilPrint is a mathematical algorithmic approach that effectively integrates Soil profile layers' properties (SPLP) with Geohash, providing an efficient means of uniquely identifying soil data, liken to a fingerprint, to preserve data privacy in the digital realm. 
2.    Geohash is a system for encoding two-dimensional geographic coordinates, latitude and longitude, into a single dimensional alphanumeric string.

## General Description
This code contains four major parts that enabled the development of Site Serial Identification (SSID), Soil Profile Layers' Properties (SPLPs) and SoilPrints as well as the organization of anonymized data and their corresponding SoilPrints for input into relational database:
1.    SSID represents a Geohash of a given site generated using the geohashTools package to encode the latitude and longitude of the profile/ soil sampling location.
2.    SPLP is a javaScript Object Notation (JSON) string containing soil profile layers with physical and chemical, morphological characteristics,  and/or biological properties, as well as their corresponding SSID.
3.    The SoilPrint Generation; Nested and Custom Approaches: The (SSID) Geohash coupled with SPLP, expressed as GSPLP is hashed to construct the Nested SoilPrint. Custom SoilPrint (deprecated) is generated without linking the SSID of the soil data with SPLP. In the latter, the the SoilPrint is generated first, and the SSID is concatenated/ appended to it afterwards.
4. Organizing and Structuring Anonymized Data and Corresponding Soilprints: The anonymized data or the original Soil Data associated with their corresponding soilprints (depending on specific needs) are organized and structured in JSON schema for entry into relational database. 

The code requires the following R packages: geohashTools, jsonlite, digest

## SSID Generation
The code reads soil data from a CSV file and generates Geohash codes using the geohashTools function. The resulting four string character long Geohash are added to the original data as a new column.

## Nested SoilPrint Generation
Desired columns are selected from the soil data, concatenated with the corresponding SSID, and sorted to create JSON strings that produce the SPLP. The GSPLP strings representing each block of 'Geohash' and 'SPLP' of the sorted JSON are hashed to create a unique SoilPrint using secured hash with 265 bits (SHA-256). The SoilPrint is included as a new column in the soil data.

## Custom SoilPrint Generation (Deprecated) 
SPLP strings are created as described in the Nested SoiPrint generation process. However, in this case, the SSID is not linked with the SPLP (referred to as SPLP1 string). The SPLP1 strings are hashed using SHA-256 algorithm to create a unique SoilPrint1, which is then combined with their corresponding Geohash.
The code includes checks for duplicated SoilPrints and duplicated SPLP1 strings to confirm uniqueness of the identification system.

## Organizing and Structuring Output Data
This code produce structured, organized, anonymized soil data (or original soil data and corresponding SoilPrints, depending on specific requirements) that can be entered into a relational database in JSON format. 

## Original Soil Data Source
**Note**: The input soil data used in this code is a cleaned and customized version of the openly accessible National Pedon Database (https://sis.agr.gc.ca/cansis/nsdb/npdb/index.html)