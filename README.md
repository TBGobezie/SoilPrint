# SoilPrint

A Unique Identification System for Preserving Privacy of Soil Data

## Definitions
1.	SoilPrint is a mathematical algorithmic approach that effectively integrates Soil profile layers' properties (SPLP) with Geohash, providing an efficient means of uniquely identify soil data, liken to a fingerprint, to preserve data privacy in the digital realm. 
2.	Geohash is a system for encoding two-dimensional geographic coordinates, latitude and longitude, into a single dimensional alphanumeric string.

## General Description
This code contains four major parts that enabled Site Serial Identification (SSID), Soil Profile Layers' Properties (SPLPs) and SoilPrints generation, and organizing the original soil data and their corresponding SoilPrints for input into relational database:
1.	SSID is a Geohash of a given site and it is generated using the geohashTools package to encode the latitude and longitude of profile/ soil sampling location.
2.	SPLP is a javaScript Object Notation (JSON) string of soil profile layers encompassing physical and chemical, morphological characteristics,  and/or biological properties.
3.	The SoilPrint Generation; Nested and Custom Approaches: Nested SoilPrint is created by hashing the Geohash linked with SPLP. Custom SoilPrint is generated without linking the SSID of soil data with the SPLP. In the latter, the the SoilPrint is generated first and the SSID is concatenated/ appended to it afterwards.
4. Organizing and Structuring Original Soil Data and Corresponding Soilprints: The original soil data and their corresponding soilprints are organized and structured for input into relational database. 
The code requires the following R packages: geohashTools, jsonlite, digest

## SSID Generation
The code reads soil data from a CSV file and generates Geohash codes using the geohashTools function. The resulting four string character long Geohash are added to the original data as a new column.

## Nested SoilPrint Generation
The desired columns from the soil data are selected and reordered to create SPLP as JSON strings. The SPLP strings are combined with their corresponding Geohash and hashed using secured hash algorithm with 265 bits (SHA-256) to create a unique SoilPrint. The SoilPrint are added to the soil data as a new column.

## Custom SoilPrint Generation
SPLP strings are created as described in the Nested SoiPrint generation process. However, in this case, the SSID is not linked with the SPLP (referred to as SPLP1 string). The SPLP1 strings are hashed using SHA-256 algorithm to create a unique SoilPrint1, which is then combined with their corresponding Geohash.
The code includes checks for duplicated SoilPrints and duplicated SPLP1 strings to confirm uniqueness of the identification system.

## Organizing and Structuring Output Data
The output of this code is an organized and structured original soil data, along with their corresponding SoilPrints, exported in csv format for input into relational database. Specifically, for the database from which this data is extracted - the Ontario Soil Information System (OSIS) - SQL queries are employed. 

## Original Soil Data Source
**Note**: The input soil data used in this code is a cleaned and customized version of the openly accessible National Pedon Database (https://sis.agr.gc.ca/cansis/nsdb/npdb/index.html)
