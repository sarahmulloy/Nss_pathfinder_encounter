
######################
##Load libraries
#####################
library(tidyverse)
library(shiny)
library(glue)
library(DT)
library(plotly)

#############################
##load and prepare datasets 
##############################


#####dataset for simulation results 
sim_results <- read.csv('../output_data/simualtion_results_ac10-30.csv')
# Replace all empty strings with NA
sim_results <- sim_results  |> 
  mutate(across(c(ancestry, class_build), na_if, ""))
####formating to fix errors
#drop ancestry na rows
sim_results<- sim_results |> drop_na(ancestry) |> drop_na(class_build)
#change ancestry value to a factor to try and resolve errors 
sim_results$ancestry <- factor(sim_results$ancestry)

#####dataset for monster information 
monster_data<- read.csv('../output_data/bestiary_stats.csv')
#filter so monster data only goes to the max AC level of simulation dataset 
max_target_ac <- sim_results |> distinct(target_ac) |> max()
monster_data_maxac <- monster_data |> filter(AC <= max_target_ac)
#drop columns not needed to clean up visual 
monster_data_maxac <- monster_data_maxac |> select(-X)

#### create list of all possible variables to chose for selected variable widgets

all_class_options <- sim_results|> distinct(class_build) |> pull()
