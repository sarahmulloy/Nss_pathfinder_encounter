# Nss_pathfinder_encounter


Tabletop roleplaying games such as Pathfinder 2e is a common hobby for adults,
but preparing for a game session is very time-intensive for the Dungeon Master
(DM). The task to create an appropriately balanced game battle (“encounter”)
requires the DM to account for several variables based on the character builds of
the party. The current resources to build a balanced encounter is not streamlined
or customizable, so creating a perfectly balanced battle encounter for the specific
game context requires intensive research and work for the DM. Therefore, the
motivation for this project is to create an accurate model to automatically
generate a customizable monster battle encounter for a given character party.
This tool will then allow the DM to spend more time focusing on the more fun
tasks to prepare a good game session.

 Using the character and monster statistics
available on Pathfinder 2e API, a model estimating the total number of combats
rounds needed to defeat each monster will create a difficulty scale based on the
exact character composition of the party. The final product will be an interactive
R shiny app that allows for user selected variables such as character class/build,
level, and desired encounter difficulty to output the resulting graphs visualizing
the difficulty ranking and estimated number of rounds until defeat for all
monsters. This will allow for the dungeon master to quickly create a well-
balanced and customizable encounter, leaving more time for other tasks to
prepare a good game session.

