### The layout plan of the shinny app:
#TAB OPTIONS: character build, monster encounter (single), monster encounter (multiple)

#####monster encounter (single):
#Drop down select: class, ancestry, and level 
### class drop-down = input$class_variable
### level drop-down = input$level_variable
### toggle option -> split by ancestry, split by level 
#style option 2: slider for level, etc 

#visual: line trend of total damage vs ac for selected build
#visual: overlay monster HP/AC scatterpoints over the character damage level 
#color code monster marks based on difficulty: easy = under curve, moderate = at curve or within CI, hard= above curve  

#slider option: monster selection for level, features, and difficulty 
#visual: shows graph of the filtered dataset depending on input features 

####


#### class example
# Define UI for application that draws a histogram
fluidPage(

  # Application title
  titlePanel("Monster encounter generator by character build"),

  # Sidebar with dropdown menus to select build class and level
  sidebarLayout(
    sidebarPanel(
      selectInput("class_variable",
                  "Filter by character class:",
                  choices= c(sim_results|> 
                               distinct(class_build) |> 
                               pull() |> 
                               sort())
                  ), 
      selectInput("challenge_variable",
                  "Select encounter challenge level:",
                  choices= c('All', 
                             'easy', 
                             'moderate', 
                             'hard', 
                             'impossible')
                  ),
      ),#sidebar panel close
    

    mainPanel(
      fluidRow(
        column(
          width=12,
          plotOutput("distPlot"), 
          # #move the bin slider input code to be in the same column space as the plot
          sliderInput("chlevel_variable",
                      "character level:",
                      min = 1,
                      max = 5,
                      value = 1), 
          sliderInput("monlevel_variable",
                      "monster level:",
                      min = 1,
                      max = 10,
                      value = 1)
        )
        # column(
        #   width = 8,
        #   plotOutput("yearboxPlot")
        # )
      ),#fluidrow
      
      fluidRow(
        dataTableOutput("selectedTable")
      ) #fluidrow
    ) #mainpanel
  ))#fluidpage


### instructions on how to get an interactive plot on Shiny
# ui <- basicPage(
#   plotOutput("plot1",
#              click = "plot_click",
#              dblclick = "plot_dblclick",
#              hover = "plot_hover",
#              brush = "plot_brush"
#   ),
#   verbatimTextOutput("info")
# )
