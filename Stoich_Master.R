
##### Creating Master file of all Stoichiometry Data #####

# INSTALL LIBRARIES
install.packages("devtools")
install.packages("googlesheets4")
install.packages("Rtools")
install.packages("tibble")
install.packages("data.table")
install.packages("dplyr")
install.packages("tibble")
install.packages("BIEN")

# LOAD LIBRARIES
    
library("devtools")
library("tidyverse")
library("lubridate")
# devtools::install_github("tidyverse/googlesheets4")
library("googlesheets4")
library("readxl")
library("R.utils")
library("broom")
library("googledrive")
library("tibble")
library("data.table")
library("dplyr")
library("tibble")
# library("BIEN")

# trait_head <- BIEN:::.BIEN_sql("SELECT * FROM agg_traits LIMIT 10;")

# NOTE: FILES MUST BE GOOGLE SHEETS

## get all Google spreadsheets in folder 'IsotopeData'
## whose names contain the letters 'Enquist'

# Use the CNP_ENQUIST MASTER_16July2018 google sheet to compare CN file names and P file names 
# to existing files names in various google drive folders

# find Google sheet ID to read the sheet into RStudio
data <- drive_ls(path = "Lab_Mac_Backup/MASTER FILES", pattern = "CNP_ENQUIST", type = "spreadsheet")
# read the sheet into RStudio based on the ID
file <- read_sheet(data$id[1])

# put the unique file names in a data frame to later use anti_join
master.file.names <- unique(file$`CN FILE NAME`)
master.file.names <- append(master.file.names, unique(file$`P FILE NAME`))
master.file.names <- as.data.frame(master.file.names)

name <- "name"
colnames(master.file.names) <- name

# create large data frame with all available files from both Google Drive folders and subfolders
data <- drive_ls(path = "IsotopeData", pattern = "Enquist", type = "spreadsheet")
data <- rbind(data, drive_ls(path = "Lab_Mac_Backup/MASTER FILES", pattern = "CNP_ENQUIST", type = "spreadsheet"))

data <- rbind(data, drive_ls(path = "Stoich2012/PR2012/CN"         , pattern = "Enquist"))
data <- rbind(data, drive_ls(path = "Stoich2012/PR2012/P"          , pattern = "P_2012" ))
data <- rbind(data, drive_ls(path = "Stoich2012/NIWOT2012/Niwot_CN", pattern = "CN_"    ))
data <- rbind(data, drive_ls(path = "Stoich2012/NIWOT2012/Niwot_P" , pattern = "P_2012" ))
data <- rbind(data, drive_ls(path = "Stoich2012/CR2012/CR_CN_2012" , pattern = "CN_"    ))
data <- rbind(data, drive_ls(path = "Stoich2012/CR2012/CR_P_2012"  , pattern = "P_"     ))
data <- rbind(data, drive_ls(path = "Stoich2012/Co2012/Co_CN_2012" , pattern = "CN_"    ))
data <- rbind(data, drive_ls(path = "Stoich2012/Co2012/Co_P_2012"  , pattern = "P_"     ))

data <- rbind(data, drive_ls(path = "Lisa_Peru Stoich 2013_2014_2015_2016_2017/CN_2013_2014_2015/CN Results"  , pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Lisa_Peru Stoich 2013_2014_2015_2016_2017/Phosphorus_2013_2014_2015_2016", pattern = "P_" ))

data <- rbind(data, drive_ls(path = "Stoich 2016_2017/CN/CN_Peru"        , pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Stoich 2016_2017/P/P_Peru"          , pattern = "P_" ))
data <- rbind(data, drive_ls(path = "Stoich 2016_2017/CN/CN_Macrosystems", pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Stoich 2016_2017/P/P_Macrosystems"  , pattern = "P_" ))

data <- rbind(data, drive_ls(path = "Michaletz-Blonder2016_2017", pattern = "CN_"))

data <- rbind(data, drive_ls(path = "Stoich 2017-2018/COLORADO/CN_Colorado" , pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Stoich 2017-2018/COLORADO/P_Colorado"  , pattern = "P_" ))
data <- rbind(data, drive_ls(path = "Stoich 2017-2018/CHINA/CN_China"       , pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Stoich 2017-2018/CHINA/P_China"        , pattern = "P_" ))
data <- rbind(data, drive_ls(path = "Stoich 2017-2018/Biosphere2/Stoich_Biosphere/CN_Biosphere" , pattern = "CN_"   ))
data <- rbind(data, drive_ls(path = "Stoich 2017-2018/Biosphere2/Stoich_Biosphere/P_Biosphere"  , pattern = "P_2018"))
data <- rbind(data, drive_ls(path = "Stoich 2017-2018/Biosphere2/d180_Macrosystems"))

data <- rbind(data, drive_ls(path = "Stoich 2018-2019/Peru"  , pattern = "P_" ))
data <- rbind(data, drive_ls(path = "Stoich 2018-2019/Peru"  , pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Stoich 2018-2019/Norway", pattern = "P_" ))
data <- rbind(data, drive_ls(path = "Stoich 2018-2019/Norway", pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Stoich 2018-2019/China" , pattern = "P_" ))
data <- rbind(data, drive_ls(path = "Stoich 2018-2019/China" , pattern = "CN_"))

data <- rbind(data, drive_ls(path = "Stoich 2019-2020/William", pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Stoich 2019-2020/RMBL"   , pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Stoich 2019-2020/Peru"   , pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Stoich 2019-2020/Peru"   , pattern = "P_" ))
data <- rbind(data, drive_ls(path = "Stoich 2019-2020/Norway" , pattern = "CN_"))
data <- rbind(data, drive_ls(path = "Stoich 2019-2020/Norway" , pattern = "P_" ))

# remove .xslx or .xls from data[,name]
# data$name <- as.character(sub(".xlsx", "", data$name))
# data$name <- as.character(sub(".xls" , "", data$name))

# missing <- anti_join(master.file.names, data, by = name)
missing <- anti_join(data, master.file.names, by = name)

# identify files that do not have final data in them
missing.ignore <- which(missing$name %like% "emplate" | 
                        missing$name %like% "Test Run"|
                        missing$name %like% "Species ")

# remove template files and Test files etc. from the names in the list that are missing
# from the most current master and are in the Google Drive folders
missing <- missing[-c(missing.ignore),]

# separate the file names into CN, P, etc.
# Each have similar file formats

#### PHOSPHORUS DATA #####
p.files <- missing[ which(missing$name %like% "P_"  ),]
p.files <- p.files[-which(p.files$name %like% "CNP_"),]

p_out <- NULL
# cor.fact <- tibble(correction.factor = 0, problem = "NA", file.name = "NA")
# testing
# sub.p.files <- p.files[c(56:94),]
sub.p.files <- p.files

cor.fact <- matrix(nrow = length(sub.p.files$name), ncol = 3)
names <- c("correction.factor", "problem", "file.name")
colnames(cor.fact) <- names
cor.fact <- as.data.frame(cor.fact)
# 

for(i in 1:max(length(sub.p.files$name))){
  file <- read_sheet(sub.p.files$id[i])
  
  if (dim(file)[1] == 90){
    
    if(is.na(file[[89,16]])){
       cor.fact[i,2] <- "File has no data"
       cor.fact[i,3] <- sub.p.files$name[i]
    } else{
     
    cor.fact[i,1] <- file[[89,16]]
    cor.fact[i,3] <- sub.p.files$name[i]
    
      if(cor.fact[i,1] > 1.50){
         cor.fact[i,2] <- "Greater than 1.50"
      } else{}
    
      if(cor.fact[i,1] < 0.85){
         cor.fact[i,2] <- "Less than 0.85"
      } else{}
    
    }
    
    file <- file[10:90, c(1:2, 5, 15:18)]
    colnames(file) <- file[2,]
    
    colnames(file)  <- c("site", "sample.id", "column", "corrected", "P", "P.Std.Dev", "P.Co.Var")
    file <- file[which(file$column == "C"),]
    file <- file[-which(file$site == "Hard Red Spring Wheat Flour"),]
    
    file <- file[,-c(3:4)]
    
    file$year.p <- rep(str_extract(string = sub.p.files$name[i], pattern = "20[0-9]+"), length(file$sample.id))
    file$P.filename <- rep(sub.p.files$name[i])
    
    file$correction.factor <- rep(cor.fact[i,1], length(file$sample.id))
    file$problem <- rep(cor.fact[i,2], length(file$sample.id))
    
    p_out <- rbind(p_out, file)
  }  else{} 
  
}

# change variable types to double
p_out$sample.id <- as.character(p_out$sample.id)
p_out$P <- as.double(as.character(p_out$P))
p_out$P.Std.Dev <- as.double(as.character(p_out$P.Std.Dev))
p_out$P.Co.Var  <- as.double(as.character(p_out$P.Co.Var))


p_out$P.filename <- as.factor(p_out$P.filename)
p.names.loop <- NULL
p.names.loop$name <- as.character(unique(p_out$P.filename))

p.names.loop <- as.data.frame(p.names.loop)
p.names.loop$nbr <- seq(1:88)
p.names.loop$nbr <- seq(1:89)
p.names.loop <- p.names.loop[1:94,]

# p.names.loop <- p.names.loop[1:94,]
# p.names.loop <- as.character(p.names.loop)
# test <- cbind(p.files$name, p.names.loop)

#### keep working on this part to figure out the three missing file names
p.missing <- anti_join(p.files, p.names.loop, by = name)
i=1

p.missing$name[i]
file <- read_sheet(p.missing$id[i])
sub.p.files <- p.missing

for(i in 1:max(length(p.missing$name))){
  file <- read_sheet(p.missing$id[i])
  
  if (dim(file)[1] == 90){
    
    if(is.na(file[[89,16]])){
      cor.fact[i,2] <- "File has no data"
      cor.fact[i,3] <- sub.p.files$name[i]
    } else{
      
      cor.fact[i,1] <- file[[89,16]]
      cor.fact[i,3] <- sub.p.files$name[i]
      
      if(cor.fact[i,1] > 1.50){
        cor.fact[i,2] <- "Greater than 1.50"
      } else{}
      
      if(cor.fact[i,1] < 0.85){
        cor.fact[i,2] <- "Less than 0.85"
      } else{}
      
    }
    
    file <- file[10:90, c(1:2, 5, 15:18)]
    colnames(file) <- file[2,]
    
    colnames(file)  <- c("site", "sample.id", "column", "corrected", "P", "P.Std.Dev", "P.Co.Var")
    file <- file[which(file$column == "C"),]
  
    file <- file[-which(file$site == "Hard Red Spring Wheat Flour"),]
    
    file <- file[,-c(3:4)]
    
    file$year.p <- rep(str_extract(string = sub.p.files$name[i], pattern = "20[0-9]+"), length(file$sample.id))
    file$P.filename <- rep(sub.p.files$name[i])
    
    file$correction.factor <- rep(cor.fact[i,1], length(file$sample.id))
    file$problem <- rep(cor.fact[i,2], length(file$sample.id))
    
    p_out <- rbind(p_out, file)
  }  else{} 
  
}
###### END OF PHOSPHORUS DATA ######

#### CN DATA #####

cn.files <- missing[which(missing$name %like% "CN_"),]

cn.files <- cn.files[-which(cn.files$name %like% ".xls"),]
cn.files <- cn.files[-which(cn.files$name == "CN_Michaletz2016.2"),]

cn.info <- matrix(nrow = length(cn.files$name), ncol = 4)
names <- c("file.name", "id", "row.length", "column.length")
colnames(cn.info) <- names
cn.info <- as.data.frame(cn.info)

# cn_out <- tibble(sample.id = "NA", year = 0, site = "NA",
#                  taxon = "NA",  C = 0,  N = 0, CN.ratio = 0, 
#                  d15N = 0, d13C = 0, date.processed = "NA", 
#                  file.name = "NA")

cn_out <- tibble(sample.id = "NA", site = "NA",
                 C = 0,  N = 0,   CN.ratio = 0, 
                 d15N = 0, d13C = 0, year.cn = "NA", cn.file.name = "NA")

cn_out.1 <- tibble(sample.id = "NA", site = "NA", year.cn = "NA", cn.file.name = "NA")
cn.sub <- NULL


cn.files.sub <- cn.files


for(i in 1:max(length(cn.files.sub$name))){
  file <- read_sheet(cn.files.sub$id[i])
 
  if(length(which(file[,5] %like% "CN Worksheet")) != 0){
     file <- file[c(which(file[,2] == "ID"):dim(file)[1]), c(2:3)]
     colnames(file) <- file[1,]
     file <- file[-1,]
     
     if(length(which(file[,1] == "NULL")) != 0){
        file <- file[-c(which(file[,1] == "NULL")),]
     } else{
        file <- file[-c(which(is.na(file[,1]))),]
     }
     
     file.names <- c("sample.id", "site")
     colnames(file) <- file.names
     
     # extract year from file name
     file$year.cn <- rep(str_extract(string = cn.files.sub$name[i], pattern = "20[0-9]+"), length(file$sample.id))
     file$cn.file.name <- rep("Need results from Isotope Lab", length(file$sample.id))
     
     cn_out.1 <- rbind(cn_out.1, file)
  }
  
  if(length(which(file[,1] %like% "REPORT OF ANALYSES")) != 0){
     # sub.date.1 <- substr(file[[6,9]], 1,  3)
     # sub.date.2 <- substr(file[[6,9]], 10, 17)
     # sub.date.2 <- paste(sub.date.1, sub.date.2)
     # cn.date <- as.Date(sub.date.2, format = "%B %d, %Y")
     
     file <- file[c(which(file[,1] == "Sample" | file[,2] == "Sample ID"):dim(file)[1]), c(1:14)]
     colnames(file) <- file[1,]
     
     file <- file[-c(which(file[,1] == "NULL")),]
     file <- file[!grepl("NA", names(file))]
     
     if(colnames(file[,1]) == "list(NULL)"){
        file.names <- c("remove.1", "sample.id", "site", "remove.2", "remove.3", "C", "N", "CN.ratio",
                        "d15N", "d13C")
        colnames(file) <- file.names
        file <- file[!grepl("remove", names(file))]
        
     }
     
     if(length(which(file[,1] == "Sample")) != 0){
        file <- file[-c(which(file[,1] == "Sample")),]
       
       # Testing if first column is only numbers 1-96 for the samples or the sample code
       if(file[[5,1]] == 5){
          file.names <- c("remove.1", "sample.id", "site", "remove.2", "remove.3", "C", "N", "CN.ratio",
                          "d15N", "d13C")
          colnames(file) <- file.names
          file <- file[!grepl("remove", names(file))]
       }
     }
     
     if(length(which(file[,2] == "Sample ID")) != 0){
        file <- file[-c(which(file[,2] == "Sample ID")),]
     }
     
     file <- file[, 1:7]
     file <- file[-c(which(is.na(file[,1]))),]
     
     # extract year from file name
     file$year.cn <- rep(str_extract(string = cn.files.sub$name[i], pattern = "20[0-9]+"), length(file$sample.id))
     file$cn.file.name <- rep(cn.files.sub$name[i], length(file$sample.id))
     
     cn_out <- rbind(cn_out, file) 
  }
}


cn_out$sample.id <- as.character(cn_out$sample.id)
cn_out$C <- as.double(as.character(cn_out$C))
cn_out$N <- as.double(as.character(cn_out$N))
cn_out$CN.ratio <- as.double(as.character(cn_out$CN.ratio))
cn_out$d15N <- as.double(as.character(cn_out$d15N))
cn_out$d13C <- as.double(as.character(cn_out$d13C))

cn_out.1$sample.id <- as.character(cn_out.1$sample.id)


##### end CN ######

##### start other master ######

# add Stoich2012_CNP_25July2017
# add Peru_CNP_Data_7April2017
master.files <- missing[which(missing$name %like% "CNP_"),]
master.files <- master.files[-which(master.files$name %like% ".xls"),]

file.1 <- read_sheet(master.files$id[1])
file.2 <- read_sheet(master.files$id[2])

p_out$sample.id <- as.character(p_out$sample.id)

test <- inner_join(cn_out, p_out, by = c("sample.id", "site"))

# renaming first master file
colnames.file.1  <- c("sample.id", "year", "site",        "taxon", "C", "N", 
                      "CN.ratio" , "d15N", "d13C", "cn.file.name", "P", "P.Std.Dev",
                      "P.Co.Var" , "P.filename", "Notes") 
colnames(file.1) <- colnames.file.1

# renaming second master file
colnames.file.2  <- c("site", "sample.id", "C", "N", "CN.ratio", "d15N", "d13C",
                      "cn.file.name", "P", "P.Std.Dev", "P.Co.Var","P.filename",  "Notes")
colnames(file.2) <- colnames.file.2

file.2$taxon <- "NA"

file.1$sample.id <- as.character(file.1$sample.id)
file.1$C <- as.double(as.character(file.1$C))
file.1$N <- as.double(as.character(file.1$N))
file.1$CN.ratio <- as.double(as.character(file.1$CN.ratio))
file.1$d15N <- as.double(as.character(file.1$d15N))
file.1$d13C <- as.double(as.character(file.1$d13C))
file.1$P <- as.double(as.character(file.1$P))
file.1$P.Std.Dev <- as.double(as.character(file.1$P.Std.Dev))
file.1$P.Co.Var  <- as.double(as.character(file.1$P.Co.Var))

file.2$sample.id <- as.character(file.2$sample.id)
file.2$C <- as.double(as.character(file.2$C))
file.2$N <- as.double(as.character(file.2$N))
file.2$CN.ratio <- as.double(as.character(file.2$CN.ratio))
file.2$d15N <- as.double(as.character(file.2$d15N))
file.2$d13C <- as.double(as.character(file.2$d13C))
file.2$P <- as.double(as.character(file.2$P))
file.2$P.Std.Dev <- as.double(as.character(file.2$P.Std.Dev))
file.2$P.Co.Var  <- as.double(as.character(file.2$P.Co.Var))
# file.2 <- file.2[,c(1:3, 14, 4:13)]


test.2 <- full_join(file.2, file.1, by = c("sample.id", "site", "taxon",   "C", "N", 
                                           "CN.ratio" , "d15N",  "d13C", "cn.file.name", "P", 
                                           "P.Std.Dev", "P.Co.Var", "P.filename", "Notes"))

test.3 <- full_join(test.2, test, by = c("sample.id",  "site",    "C", "N", 
                                         "CN.ratio" , "d15N", "d13C", "cn.file.name", "P", 
                                         "P.Std.Dev", "P.Co.Var", "P.filename"))

###
# put the unique file names in a data frame to later use anti_join
test.3.names <- unique(test.3$cn.file.name)
test.3.names <- append(test.3.names, unique(test.3$P.filename))
test.3.names <- as.data.frame(test.3.names)

name <- "name"
colnames(test.3.names) <- name

# missing <- anti_join(master.file.names, data, by = name)
missing.total <- anti_join(test.3.names, master.file.names,  by = name)


#### find duplicates #####
dup <- duplicated(test.3, by = key("site", "sample.id"))
which(dup == TRUE)

dups <- test.3[which(dup == TRUE),]
dupdup <- NULL

for(i in 1:max(length(dups$sample.id))){
  # if(length(dups$sample.id[i] == dups$sample.id[i-1]) != 0){
    # dups$sample.id[i] == dups$sample.id[i-1]
  # }else (duplic <- test.3[which(test.3$sample.id == dups$sample.id[i]),])
  duplic <- test.3[which(test.3$sample.id == dups$sample.id[i]),]
  dupdup <- rbind(duplic, dupdup)
}

duplicates <- dups[which(dups$sample.id == dups$sample.id[i]),]
which(dups$sample.id == i)

dupdup <- dupdup[-c(9:13),]
dupdup[i,]



#### make a list of projects represented in the newest master file ####
report <- as_tibble(cbind(test.3$cn.file.name, test.3$year.cn, test.3$P.filename, test.3$year.p))
names <- c("cn.file.name","year.cn", "p.filename", "year.p")
colnames(report) <- names
cn   <- unique(report$cn.file.name)
phos <- unique(report$p.filename)

cn.report <- matrix(nrow = length(cn[which(cn %like% "PE")]), ncol = 2)
cn.rep.name <- c("project.name", "year.cn")
colnames(cn.report) <- cn.rep.name

for(i in 1:1){
  # PERU
    names <- cn[which(cn %like% "PE")]
    for(i in 1:length(names)){
        cn.report[i,1] <- "Peru"
        cn.report[i,2] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
  # Peru
    names <- cn[which(cn %like% "Pe")]
    site <- rep("Peru", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    # cn.report <- append(cn.report, output, after = length(cn.report))
    cn.report <- rbind(cn.report, output)
  
  # BRYANT
    names <- cn[which(cn %like% "BRY")]
    site <- rep("Bryant", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
    
  # MACROSYSTEMS  
    names <- cn[which(cn %like% "MAC")]
    site <- rep("Macrosystems", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
    
  # CHINA  
    names <- cn[which(cn %like% "CHI")]
    site <- rep("China", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
  # Costa Rica
    names <- cn[which(cn %like% "cr")]
    site <- rep("Costa Rica", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
    
  # NIWOT
    names <- cn[which(cn %like% "NIW")]
    site <- rep("Niwot", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
    
  # BS2
    names <- cn[which(cn %like% "BS")]
    site <- rep("Biosphere2", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
  
  # Enquist
    names <- cn[which(cn %like% "Enqui")]
    site <- rep("Enquist", length(names))
    year <- rep("2012", length(names))
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
    
  # COWEETA
    names <- cn[which(cn %like% "COW")]
    site <- rep("Coweeta", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
  
  # LUQILLO
    names <- cn[which(cn %like% "LUQ")]
    site <- rep("Luqillo", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
  
  # Julie
    names <- cn[which(cn %like% "JUL")]
    site <- rep("Julie", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
  
  # BCI
    names <- cn[which(cn %like% "BCI")]
    site <- rep("BCI", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
 
  # MTB
    names <- cn[which(cn %like% "MTB")]
    site <- rep("MTB", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
  
  # Harvard
    names <- cn[which(cn %like% "HAR")]
    site <- rep("Harvard", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
 
  # Colorado
    names <- cn[which(cn %like% "Col")]
    site <- rep("Colorado", length(names))
    year <- rep("NA", length(names))
    for(i in 1:length(names)){
      year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
    }
    output <- cbind(site, year)
    cn.report <- rbind(cn.report, output)
  
  # cn.report[i,1] <- str_extract(string = cn[i], pattern %like% "Nor")
  # cn.report[i,2] <- str_extract(string = cn[i], pattern = "20[0-9]+")
}

cn.report <- as.data.frame(cn.report)
cn.report$complete <- paste(cn.report$project.name, cn.report$year.cn)

report.cn <- unique(cn.report$complete)

# PHOSPHORUS
phos.report <- matrix(nrow = length(phos[which(phos %like% "PE")]), ncol = 2)
phos.rep.name <- c("project.name", "year.phos")
colnames(phos.report) <- phos.rep.name

for(i in 1:1){
  # PERU
  names <- phos[which(phos %like% "PE")]
  for(i in 1:length(names)){
    phos.report[i,1] <- "Peru"
    phos.report[i,2] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  # Peru
  names <- phos[which(phos %like% "Pe")]
  site <- rep("Peru", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # BRYANT
  names <- phos[which(phos %like% "BRY")]
  site <- rep("Bryant", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # CHINA
  names <- phos[which(phos %like% "CHI")]
  site <- rep("China", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # China
  names <- phos[which(phos %like% "Chi")]
  site <- rep("China", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # Julie
  names <- phos[which(phos %like% "Ju")]
  site <- rep("Julie", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # Julie
  names <- phos[which(phos %like% "ju")]
  site <- rep("Julie", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # Costa Rica
  names <- phos[which(phos %like% "2CR")]
  site <- rep("Costa Rica", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # Hawaii
  names <- phos[which(phos %like% "Haw")]
  site <- rep("Hawaii", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # Puerto Rico
  names <- phos[which(phos %like% "PR")]
  site <- rep("Puerto Rico", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # Niwot
  names <- phos[which(phos %like% "Niw")]
  site <- rep("Niwot", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # MT BIGELOW
  names <- phos[which(phos %like% "MT B")]
  site <- rep("Mt Bigelow", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # BCI
  names <- phos[which(phos %like% "BCI")]
  site <- rep("BCI", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # LUQUILLO
  names <- phos[which(phos %like% "LUQ")]
  site <- rep("Luquillo", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # MACROSYSTEMS
  names <- phos[which(phos %like% "MAC")]
  site <- rep("Macrosystems", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # COWEETA
  names <- phos[which(phos %like% "COW")]
  site <- rep("Coweeta", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # HARVARD
  names <- phos[which(phos %like% "HAR")]
  site <- rep("Harvard", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # MTB
  names <- phos[which(phos %like% "MTB")]
  site <- rep("MTB", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # Colorado
  names <- phos[which(phos %like% "Col")]
  site <- rep("Colorado", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
  # BS2
  names <- phos[which(phos %like% "BS2")]
  site <- rep("Biosphere2", length(names))
  year <- rep("NA", length(names))
  for(i in 1:length(names)){
    year[i] <- str_extract(string = names[i], pattern = "20[0-9]+")
  }
  output <- cbind(site, year)
  phos.report <- rbind(phos.report, output)
  
}

phos.report <- as.data.frame(phos.report)
phos.report$complete <- paste(phos.report$project.name, phos.report$year.phos)

report.phos <- unique(phos.report$complete)


# SCIENTIFIC NAMES FOR THE SAMPLE IDs
# some are located in: Plot Data Dry masses from Peru Crew - Esperanza and Wayquecha, the others for Peru do not have species data

# https://stackoverflow.com/questions/47851761/r-how-to-read-a-file-from-google-drive-using-r

# - Change XLSX files to Google Sheets (all)
#     - try to avoid this, keep searching for another way
# - Make a function that extracts CN data then another function to extract P data
# - put checks in the functions to make sure when run again, duplication does not happen
# - use join to combine the two data sets where there are the same site and sample ID
