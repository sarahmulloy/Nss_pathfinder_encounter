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


###### version 2 2/17/26 interactive plot 

server <- function(input, output) {
  ### [ figure based on single party member composition]
  # output$chmonPlot <- renderPlotly({
  #   
  #   #filter graph generated based on the character build CLASS selected
  #   plot_data <- sim_results |>
  #     #Filter based on the class choice
  #     filter(class_build == input$class_variable_1)
  #   #Create title
  #   title <- glue(
  #     "{input$class_variable_1} Total damage output during 5-round encounter") #default title
  #   
  #   ####
  #   # default graph without aditional conditional selections
  #   ####
  #   #visualize the total_dmg output for each class split by ancestry
  #   #Add in monster stat as scatter plot ontop of it
  #   main_plot_interact <- plot_data  |> 
  #     ggplot(aes(x=target_ac, 
  #                y=total_dmg)
  #     )+
  #     geom_smooth(aes(group=ancestry, 
  #                     color=ancestry), 
  #                 method='lm', 
  #                 se=TRUE) +
  #     geom_point(data = monster_data_maxac, 
  #                aes( key = Name, shape=Level, x=AC, 
  #                     y=HP)
  #     ) +
  #     scale_shape_binned() +
  #     labs(title=title,
  #          x='target ac',
  #          y= 'target hit points')
  #   
  #   ### Launch the plotly plot
  #   ggplotly(main_plot_interact,
  #            source = "chmon"
  #   )
  #   
  #   #fig.update_traces(mode="markers+lines", hovertemplate=None)
  # }) #closing out the code for the figure plot block of code
  
  
  #### [Figure based on 4-party composition]
  output$chmonPlot <- renderPlotly({
    
    #create the 4-party list based on selected values 
    full_build_select_party = c(input$class_variable_1, 
                                input$class_variable_2, 
                                input$class_variable_3, 
                                input$class_variable_4)
    #Create title
    title <- glue(
      "Monster challenge based on 4-party total damage output over 5 combat rounds")
    
    #### [Create the total party damage prediction graph based on the selected class variables ]
    ##filter out these builds from  from the simulation data 
    
    only_party_sim <- sim_results |> 
      filter(build_name %in% full_build_select_party)
    
    #for each target_ac, add up all the damage from EACH encounter across the whole party 
    ## groupby by encounter number, than sum all the 'total damage'
    
    party_combo_sim <- only_party_sim |> 
      group_by(target_ac, encounter_num) |> 
      summarize(total_party_damage= sum(total_dmg))
    
    ## Create summary dataframe based on summary statistics
    total_dmg_dist <- party_combo_sim |> 
      group_by(target_ac) |> 
      summarize(min_val = min(total_party_damage), 
                max_val = max(total_party_damage), 
                q25= quantile(total_party_damage, 0.25), 
                median= median(total_party_damage), 
                q75= quantile(total_party_damage, 0.75))
    
    ### Create monster challenge rating based on where the HP falls on the total_damage distribution 
    #rename monster column for easier merging 
    monster_data_merge <- monster_data_maxac |> 
      rename(target_ac = AC)
    
    #merge the summary stats with monster info based on AC
    mon_with_party_stat <- left_join(monster_data_merge, 
                                     total_dmg_dist, 
                                     by = "target_ac")
    #rename AC column for easier graphing 
    mon_with_party_stat <- mon_with_party_stat |> rename(AC= target_ac)
    
    #create a challenge rating using case_when based on the summary statistics 
    mon_party_challenge <- mon_with_party_stat |> 
      mutate(challenge_rate = case_when (HP<q25 ~ 'easy', 
                                         HP >=q25 & HP <= q75 ~ 'moderate',
                                         HP > q75 & HP <= (2*max_val)~ 'hard', 
                                         HP >= (2*max_val) ~'impossible')
      )
    
    #convert challenge rating to a factor value 
    mon_party_challenge <- mon_party_challenge|> 
      mutate (challenge_rate= as.factor(challenge_rate))
    
    #create a color scale for the graphing 
    color_dict= c('easy'='green', 'moderate'='blue', 'hard'='red', 'impossible'='orange')
    
    ## Graph where total_damage and target_ac is on y and x axis, and shows total distribtuion across all encounters
    
    main_plot_interact <- party_combo_sim |> 
      ggplot(aes(x=target_ac, 
                 y=total_party_damage))  + 
      geom_point(alpha = 1/10) + 
      geom_smooth(method='lm', se=TRUE) + #add geom_ribbon() for predictive ranges 
      #apply monster information to the plot -> ADD that the color is equal to the CHALLENGE RATING, and that the shape is equal to the level
      geom_point(data=mon_party_challenge, 
                 aes(x=AC, 
                     y=HP, 
                     shape= Level, 
                     color= challenge_rate, 
                     alpha = 0.5)) + 
      scale_shape_binned() + 
      scale_color_manual(values = color_dict) +
      labs(title=title,
           x='target ac',
           y= 'target hit points')  

    ### Launch the plotly plot
    ggplotly(main_plot_interact,
             source = "chmon"
    )
    
  }) #closing out the code for the figure plot block of code
  
  ##########################################################
  
  ### [Create data table on the main page]
  output$selectedTable <- renderDataTable({
    #default table
    selected_data <- monster_data_maxac
    
    # ## update displayed data table based on plotly selection
    # selected_data <- reactive({
    #   # Get the selected points' keys from plot with source "A"
    #   event_data_selected <- event_data(event = "plotly_selected",
    #                                     source = "chmon")
    #   
    #   #Create a condition to filter data table based on ggplot selection
    #   if (is.null(event_data_selected)) {
    #     # Return all data if nothing is selected or the selection is cleared
    #     return(monster_data_maxac)
    #   } 
    #   else {
    #     selected_keys <- event_data_selected$key
    #     # Filter the original data frame to keep only selected rows
    #     monster_data_maxac |> 
    #       filter(Name %in% selected_keys)
    #   }
    # })
    
    #view table based on previous conditionals
    selected_data
  }) #Datatable secion 
  
} #Close server page 