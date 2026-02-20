### The layout plan of the shinny app:

server <- function(input, output) {
  #### [Figure based on 4-party composition]
  output$chmonPlot <- renderPlotly({
    
    #create the 4-party list based on selected values 
    full_build_select_party = c(input$class_variable_1, 
                                input$class_variable_2, 
                                input$class_variable_3, 
                                input$class_variable_4)
    
    #Filter out the simulation dataset for each class individually 
    class1_plot <- sim_results |>
      #Filter based on the class choice
      filter(build_name == input$class_variable_1)
    class2_plot <- sim_results |>
      #Filter based on the class choice
      filter(build_name== input$class_variable_2)
    class3_plot <- sim_results |>
      #Filter based on the class choice
      filter(build_name == input$class_variable_3)
    class4_plot <- sim_results |>
      #Filter based on the class choice
      filter(build_name == input$class_variable_4)
    
    #Create title
    title <- glue("Monster challenge rating based on 4-party total damage output over 5 rounds")
    
    #### [Create the total party damage prediction graph based on the selected class variables ]
    ##filter out these builds from  from the simulation data 
    
    only_party_sim <- sim_results |> 
      filter(build_name %in% full_build_select_party)
    
    #for each target_ac, add up all the damage from EACH encounter across the whole party 
    ## groupby by encounter number, than sum all the 'total damage'
    
    party_combo_sim <- only_party_sim |> 
      group_by(target_ac, encounter_num) |> 
      summarise(total_party_damage= sum(total_dmg), 
                .groups = "drop")
    
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
    
    #update dataframe for table widget with challenge rating 
    monster_challenge <- mon_party_challenge |> relocate(challenge_rate) |> rename("challenge rating"= challenge_rate) 
    
    monster_challenge <- monster_challenge|> select(-c(min_val, max_val, q25, median, q75)) |> rename("AC" = target_ac)

    #create a color scale for the graphing
    color_dict= c('easy'="forestgreen", 'moderate'="blue", 'hard'='red', 'impossible'='darkorange')

    # Graph where total_damage and target_ac is on y and x axis, and shows total distribtuion across all encounters

    main_plot_interact <-
      ggplot(data = party_combo_sim, aes(x=target_ac,
                                         y= total_party_damage))  +
      geom_point(alpha = 1/10) +
      geom_smooth(method='loess', aes(label= "Total party damage"), se=TRUE, color= "darkgoldenrod1") +
      #add geom_ribbon() for predictive ranges


      # #add in a lineplot for each class individually
      # #class 1
      # geom_smooth(data = class1_plot, aes(label= "Character 1", x=target_ac, y=total_dmg), color="aquamarine", alpha=0.5,
      #             method='lm',
      #             se=TRUE) +
      # # #class 2
      # geom_smooth(data = class2_plot, aes(label= "Character 2", x=target_ac, y=total_dmg), color="blueviolet", alpha=0.5,
      #             method='lm',
      #             se=TRUE) +
      # # #class 3
      # geom_smooth(data = class3_plot, aes(label= "Character 3", x=target_ac, y=total_dmg), color="chartreuse2", alpha=0.5,
      #             method='lm',
      #             se=TRUE) +
      # # #class 4
      # geom_smooth(data = class4_plot, aes(label= "Character 4", x=target_ac, y=total_dmg), color="turquoise1" , alpha=0.5,
      #             method='lm',
      #             se=TRUE) +
      #apply monster information to the plot -> ADD that the color is equal to the CHALLENGE RATING, and that the shape is equal to the level
      geom_point(data=mon_party_challenge,
                 aes(label= Name, 
                     x=AC,
                     y=HP,
                     shape=challenge_rate,
                     alpha=0.5,
                     size=Level, 
                     color= challenge_rate 
                      )) +
                     #fill= challenge_rate)) + size= Level,
      scale_shape_manual(name= '', values=c(8, 8, 8, 8)) + 
      scale_color_manual(name="Challenge rating & level", values = color_dict) +
      labs(title= title,
           x='target ac',
           y= 'target hit points')

    ### Launch the plotly plot
    ggplotly(main_plot_interact,
             source = "chmon"
    )

  }) #closing out the code for the figure plot block of code
  
  #########################################################

  ### [Create data table on the main page]
  output$selectedTable <- renderDataTable({
    #default table
    selected_data <- mon_party_challenge

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
  }) #Datatable section
  
} #Close server page 