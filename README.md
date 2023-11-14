# SoilPrint 

A Unique Identification System for preserving Soil Data privacy

## Definitions
1.	Pedohash is a blend word of the Greek word Pedon', meaning soil, and "hash", referring to a fixed alphanumeric value that represent different lengths of data in the computer world.
2.	Geohash is a system for encoding two dimensional geographic coordinates into a single dimensional alphanumeric string.

## General Description
This code contains three major parts that generates Site Serial Identification (SSID), Soil Profile Layers Properties (SPLPs), and Pedohash for soil data:
1.	SSID is a Geohash of a given site and it is generated using the geohashTools package to encode the latitude and longitude of soil sampling points.
2.	SPLP is a javaScript Object Notation (JSON) string of soil profile layers and the properties could be morphoogical characteristics, physical, chamical and biological properties.
3.	Nested and Custom Pedohash generation. Nested Pedohash is created by hashing the Geohash linked with SPLP that contain information about soil profile layers (or horizons). Custom Pedohash, on the otherhand, is created without linking the SSID of soil data with the SPLP. The SSID is linking with the Pedohash generated from SPLP and the SSID is appended to the Pedohash afterwards.
The code requires the following R packages: geohashTools, jsonlite, digest

## SSID Generation
The code reads soil data from a CSV file and generates Geohash codes using the geohashTools function. The Geohash codes are added to the original data as a new column.

## Nested Pedohash Generation
The desired columns from the soil data are selected and reordered to create SPLP using JSON strings. The SPLP strings are combined with their corresponding Geohash codes and hashed using secured hash algorithm with 265 bits (SHA-256) to create a unique Pedohash. The Pedohashes are added to the soil data as a new column.

## Custom Pedohash Generation
SPLP strings are created as described in the Nested Pedohash generation process. However, in this case, the SSID is not linked with the SPLP referred to as SPLP1 string. The SPLP1 strings are hashed using SHA-256 algorithm to create a unique Pedohash1, and then combined with their corresponding Geohash codes.
The code checks for duplicated Pedohashes and duplicated SPLP1 strings to confirm uniqueness of the identification system.

**Note**: The data used for this code is a cleaned and customized version of the openly accessible National Pedon Database (https://sis.agr.gc.ca/cansis/nsdb/npdb/index.html)
