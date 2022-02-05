# 1. Prepare environment

## 1.1 Install required packages

list.of.packages <- c("rjson","dplyr","plyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) {
  install.packages(new.packages)
} else {
  print("[info] No new packages are required.")
}

## 1.2 Initialize required libraries

library("plyr")
library("rjson")
library("dplyr")

## 1.3 Download required data-sets

## From URL: https://github.com/mitre-attack/attack-stix-data/raw/master/enterprise-attack/enterprise-attack.json

if(!file.exists("enterprise-attack.json")){

  download.file("https://github.com/mitre-attack/attack-stix-data/raw/master/enterprise-attack/enterprise-attack.json",
                "enterprise-attack.json")
} else
{print("[info] File already exists, skipping download")}


## 1.4 Transform json data to df

origin <- fromJSON(file = "enterprise-attack.json" )

# 2 Clean data

raw_object <- origin$objects
print(paste("[info] The number of elements is:",length(raw_object)))



## 3 Work with project data

### Create lists with information about rows
headers_rows <- llply(raw_object, function(x) {x = names(x)})
headers_list <- unique(unlist(llply(raw_object, function(x) {x = names(x)})))
names(headers_list) <- unique(unlist(llply(raw_object, function(x) {x = names(x)})))

### Count and order this metadata
ocurrences <- llply(headers_list, function(y) sum(laply(headers_rows,function(x) {x = y %in% x})))
ocurrences <- ocurrences[order(unlist(ocurrences),decreasing=TRUE)]

### Show relevant information
print(ocurrences)
