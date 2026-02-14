### The layout plan of the shinny app:
#TAB OPTIONS: character build, monster encounter (single), monster encounter (multiple)

#####monster encounter (single):
#Drop down select: class, ancestry, and level 
#style option 2: slider for level, etc 
#visual: line trend of total damage vs ac for selected build
#visaul: overlay monster HP/AC scatterpoints over the character damage level 
#color code monster marks based on difficulty: easy = under curve, moderate = at curve or within CI, hard= above curve  

#slider option: monster selection for level, features, and difficulty 
#visual: shows graph of the filtered dataset depending on input features 

####

### class example
# Define server logic required to draw a histogram
function(input, output, session) {
  #Try to add the level slider as a range widget 
  #output$range <- renderPrint({ input$level_variable })

  ### First block of code- creating a graph on the shiny App, connected to distPlot location on ui.R
  output$distPlot <- renderPlot({

    plot_data <-sim_results
    #filter graph generated based on the character build CLASS selected
    plot_data <- sim_results |> 
      #Filter based on the class choice
      filter(class_build == input$class_variable) 
    
    #Create title
    title <- glue("{input$class_variable} Total damage output during 5-round encounter for {input$class_variable} character") #default title

    # ###
    # ##Graph based on selected color/group conditional variable
    # ###
    # #
    # if(input$color_variable != "All"){
    #   #Adjust the title of the plot
    #   title <- glue("Distribution of {input$hist_variable} in Oscar movies by {input$color_variable}")
    #   #Create a plot with a 'color/fill' argument for the histogram
    #   movie_data |>
    #     ggplot(aes(x = .data[[input$hist_variable]],
    #                fill= Winner
    #     )) +
    #     geom_histogram(bins= input$bins) +
    #     labs(title= title)
    # } else if(input$color_variable == "All"){
    #   #adjust title of the plot
    #   title <- glue("Distribution of {input$hist_variable} in Oscar movies")
    #   #Create a plot WITHOUT a 'color/fill' argument for the histogram
    #   movie_data |>
    #     ggplot(aes(x = .data[[input$hist_variable]]
    #     )) +
    #     geom_histogram(bins= input$bins) +
    #     labs(title= title)
    # }

    ###
    #Default graph code without conditional filters
    ###
    
    # #graph results from only one class ### figure out how to automate this process later 
    # class_select_sim <- sim_results |> filter(class_build == 'barbarian')
    
    ####
    # default graph without aditional conditional selections
    ####
    #visualize the total_dmg output for each class split by ancestry 
    #Add in monster stat as scatter plot ontop of it 
    plot_data  |> ggplot(aes(x=target_ac, y=total_dmg)) + #, color= ancestry 
      geom_smooth(aes(group=ancestry, color=ancestry), method='lm', se=TRUE) +
      geom_point(data = monster_data_maxac, aes(x=AC, y=HP, shape=Level, size= Level, alpha=0.4)) + 
      scale_shape_binned() +
      labs(title=title, 
           x='target ac', 
           y= 'target hit points')


  }) #closing out the code for the figure plot block of code

  # ### Create boxplot graph with (variable) over year between winner/loser
  # output$yearboxPlot <- renderPlot({
  # 
  #   plot_data <-movie_data
  #   title <- glue("Distribution of {input$hist_variable} in Oscar movies across years") #default title
  # 
  #   ###
  #   # Graph based on selected color/group conditional variable
  #   ###
  #   # #
  #   if(input$color_variable != "All"){
  #     #Adjust the title of the plot
  #     title <- glue("Distribution of {input$hist_variable} in Oscar movies by {input$color_variable} across years")
  # 
  #     #Create a plot with a 'color/fill' argument
  #     movie_data |>
  #       ggplot(aes(x = Year,
  #                  y = .data[[input$hist_variable]],
  #                  color=Winner
  #       )) +
  #       geom_boxplot(position=position_dodge()) +
  #       labs(title= title)
  #   } else if(input$color_variable == "All"){
  #     #adjust title of the plot
  #     title <- glue("Distribution of {input$hist_variable} in Oscar movies across years")
  #     #Create a plot WITHOUT a 'color/fill' argument
  #     movie_data |>
  #       ggplot(aes(x = Year,
  #                  y = .data[[input$hist_variable]]
  #       )) +
  #       geom_boxplot()+
  #       labs(title= title)
  #   }
  # 
  #   # ###
  #   # #Default graph code without conditional filters
  #   # ###
  #   #   #Create a plot with a 'color/fill' argument
  #   #   plot_data |>
  #   #   ggplot(aes(x = Year,
  #   #              y = .data[[input$hist_variable]],
  #   #              color= Winner
  #   #   )) +
  #   #   geom_boxplot(position=position_dodge()) +
  #   #   labs(title= title)
  # 
  # }) #closing out the code for the histogram plot block of code
  
  ### New block of code- creating a TABLE on the shiny App, connected to selectedTable location on ui.R
  output$selectedTable <- renderDataTable({
    
    selected_data <- monster_data_maxac
    
    ### filter table based on selected challenge variable 
    #Input$challenge_variable
    # 
    # if(input$island != "All"){
    #   selected_data <- selected_data |> 
    #     filter(island == input$island)
    # } else if(input$island == "All"){
    #   selected_data <- penguins
    # }
    # 
    selected_data
    
  }) #closing out table block of code 

}#curly bracket to close out the whole function code block for the server.R


### instructions on how to get an interactive plot 
# server <- function(input, output) {
#   output$plot1 <- renderPlot({
#     plot(mtcars$wt, mtcars$mpg)
#   })
#   
#   output$info <- renderText({
#     xy_str <- function(e) {
#       if(is.null(e)) return("NULL\n")
#       paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
#     }
#     xy_range_str <- function(e) {
#       if(is.null(e)) return("NULL\n")
#       paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1), 
#              " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
#     }
#     
#     paste0(
#       "click: ", xy_str(input$plot_click),
#       "dblclick: ", xy_str(input$plot_dblclick),
#       "hover: ", xy_str(input$plot_hover),
#       "brush: ", xy_range_str(input$plot_brush)
#     )
#   })
# }
