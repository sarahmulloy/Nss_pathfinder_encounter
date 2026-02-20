### The layout plan of the shinny app:

### TAB: 4-party monster challenge
## sidepanel: drop-down options for selecting character build 
## main panel: interactive plot with projected total party damage with monster stats + challenge rating 
## main panel: datatable with monster informaiton and stats based on filter on the figure 

### TAB: single character build monster challenge 
## Same figure as whole party tab, but only one character build projected total damage, and new calculation of monster challenge rating 
## table updated with new rating 

### TAB: character build exploration 
## Visuals from the 3 read-outs for each character build: rate of sucess (1 and 2), rate of critical attack, and total damage output
## these 4 figures update based on the selected character build 
## OR the 4 figures change based on the class chosen, and demonstrates the distribution by ancestry for that build 
#---------------------------------------

page_navbar(
  #Heading format
  title= "Pathfinder 2e monster encounters by party build", 
  bg = "#460e06", 
  inverse= TRUE, 
  
  ########
  #Tab 1: full party modeling 
  #######
  nav_panel(
    title="Full party",  
    fluidRow(
      #Panel: Sidebar for character selection -----
      column(
        width = 4,
        h2("Select party build"), 
        
        #character 1-------
        fluidRow(
          column(12,
                 selectInput(
                   "class_variable_1",
                   "Character build 1:",
                   #Automatically fill option based on unique class column variables
                   choices = c(sim_results |>
                                 distinct(build_name) |>
                                 pull() |>
                                 sort()),
                   #set a default value to generate base figure
                   selected = "dwarf barbarian strength"
                 ))), #close character 1
        #character 2-------
        fluidRow(
          column(12,
                 selectInput(
                   "class_variable_2",
                   "Character build 2:",
                   #Automatically fill option based on unique class column variables
                   choices = c(sim_results |>
                                 distinct(build_name) |>
                                 pull() |>
                                 sort()),
                   #set a default value to generate base figure
                   selected = "human-str fighter strength"
                 ))), #close character 2
        #character 3-------
        fluidRow(
          column(12,
                 selectInput(
                   "class_variable_3",
                   "Character build 3:",
                   #Automatically fill option based on unique class column variables
                   choices = c(sim_results |>
                                 distinct(build_name) |>
                                 pull() |>
                                 sort()),
                   #set a default value to generate base figure
                   selected = "halfling rogue dexterity"
                 ))), #close character 3
        #character 4-------
        fluidRow(
          column(12,
                 selectInput(
                   "class_variable_4",
                   "Character build 4:",
                   #Automatically fill option based on unique class column variables
                   choices = c(sim_results |>
                                 distinct(build_name) |>
                                 pull() |>
                                 sort()),
                   #set a default value to generate base figure
                   selected = "elf sorcerer charisma"
                 ))), #close character 4
        
      ), #close sidebar column
      
      #Mainpanel: model figure and monster scatter plot -----
      column(
        width= 5, 
        plotlyOutput(
          "chmonPlot"
        ),
        ### [ display monster info from click]
        verbatimTextOutput("monsterinfo"), 
        dataTableOutput("selectedTable")
        
      ), #close main panel column 
    ), #close full page fluid row
  ), #close nav_panel
  
  ########
  #Tab 2: Single character modeling
  #######
  
  nav_panel(title="Single character", 
            p("Second page content")), 
  
  ########
  #Tab 3: Character build modeling 
  #######
  nav_panel(title="Modeling character builds", 
            p("Thrid page content.")), 
  nav_spacer())
