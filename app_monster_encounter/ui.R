### The layout plan of the shinny app:
#TAB OPTIONS: character build, monster encounter (single), monster encounter (multiple)

#####monster encounter (single):

#### Single tab with interactive plots

fluidPage(
  titlePanel("Generate monster encounter for party"),
  # Sidebar with dropdown menus to select build class and level
  
  ###[ SIDEBAR LAYOUT] ###
  sidebarLayout(
    sidebarPanel(
      ## Create a FLuid Row for EACH class option in a 4-class party 
      
      ### Character choice 1
      fluidRow(
        column(12,
               selectInput(
                 "class_variable_1",
                 "class 1:",
                 #Automatically fill option based on unique class column variables
                 choices = c(sim_results |>
                               distinct(build_name) |>
                               pull() |>
                               sort())
               )) #, #column 1,
        # column(6,  
        #        selectInput(
        #          "anc_variable_1",
        #          "ancestry 1",
        #          #Automatically fill option based on unique class column variables
        #          choices = c(sim_results |>
        #                        distinct(ancestry) |>
        #                        pull() |>
        #                        sort())
        #)) #column 2
      ), #char1 row
      
      ### character choice 2
      fluidRow(
        column(12, 
               selectInput(
                 "class_variable_2",
                 "Class 2:",
                 #Automatically fill option based on unique class column variables
                 choices = c(sim_results |>
                               distinct(build_name) |>
                               pull() |>
                               sort())
               )) #, #column 1,
        # column(6,  
        #        selectInput(
        #          "anc_variable_2",
        #          "ancestry 2",
        #          #Automatically fill option based on unique class column variables
        #          choices = c(sim_results |>
        #                        distinct(ancestry) |>
        #                        pull() |>
        #                        sort())
               #)) #column 2
      ), #char2 row
      
      ### character choice 3
      fluidRow(
        column(12, 
               selectInput(
                 "class_variable_3",
                 "Class 3:",
                 #Automatically fill option based on unique class column variables
                 choices = c(sim_results |>
                               distinct(build_name) |>
                               pull() |>
                               sort())
               )) #, #column 1,
        # column(6,  
        #        selectInput(
        #          "anc_variable_3",
        #          "ancestry 3",
        #          #Automatically fill option based on unique class column variables
        #          choices = c(sim_results |>
        #                        distinct(ancestry) |>
        #                        pull() |>
        #                        sort())
               #)) #column 2
      ), #char3 row
      
      ##character choice 4
      fluidRow(
        column(12, 
               selectInput(
                 "class_variable_4",
                 "Class 4:",
                 #Automatically fill option based on unique class column variables
                 choices = c(sim_results |>
                               distinct(build_name) |>
                               pull() |>
                               sort())
               )) #, #column 1,
        # column(6,  
        #        selectInput(
        #          "anc_variable_4",
        #          "ancestry 4",
        #          #Automatically fill option based on unique class column variables
        #          choices = c(sim_results |>
        #                        distinct(ancestry) |>
        #                        pull() |>
        #                        sort())
               #)) #column 2
      ), #char4 row
      
      ## slide panel based on CHARACTER level
      sliderInput(
        "chlevel_variable",
        "Party level:",
        min = 1,
        max = 5,
        value = 1
      ), #close slider widget
    ), #close side bar panel
    #### [ CLOSE SIDE PANEL]#####
    
    ###[ MAIN PAGE LAYOUT] ###
    mainPanel(
      ### main section -> fill with plots
      fluidRow(
        column(
          width = 12,
          
          ##[ PLOT: scatter graph]
          plotlyOutput(
            "chmonPlot"
          ),
        ),
        ### [ display monster info from click]
        verbatimTextOutput("monsterinfo")
      ),
      #fluidrow
      
      #Display full monster table information
      fluidRow(dataTableOutput("selectedTable")
      ) #fluidrow
    ) #mainpanel
  ))#fluidpage
