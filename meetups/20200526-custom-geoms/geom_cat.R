library(ggplot2)
library(grid)
library(png)

#grobMaker function - takes aesthetics and generates a "grob" that grid graphics knows how to render.
kittyGrob <- function(x, y) {
  img <- readPNG("cat-alt-32.png")
  g <- rasterGrob(img, x, y, width = 0.05, height = 0.05, interpolate=TRUE)
}

#draw_panel function that takes the input dataframe and some context info and transforms it for use by the
#grobMaker
kitty_DrawPanel <- function(data, panel_scales, coord, na.rm = FALSE) {
  coords <- coord$transform(data, panel_scales)
  ggplot2:::ggname("geom_myKitty", kittyGrob(coords$x, coords$y))
}

#ggproto call that sets up linkages between geom_myGeom and the draw panel function
kittyGeom <- ggproto( 
  "kittyGeom", 
  Geom, 
  draw_panel = kitty_DrawPanel, 
  non_missing_aes = c("x", "y"),
  default_aes = aes(),
  icon = function(.) {}, 
  desc_params = list(), 
  seealso = list(), 
  examples = function(.) {})

#ggplot2 entry point for geom
geom_myKitty <- function(mapping = NULL, data = NULL, stat = "identity", position = "identity", na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...) {
  layer(
    data = data, 
    mapping = mapping, 
    stat = stat, 
    geom = kittyGeom,                        #reference to result of above ggproto call
    position = position, 
    show.legend = show.legend, 
    inherit.aes = inherit.aes, 
    params = list(na.rm = na.rm, ...)
  )
}

ggplot( mtcars, aes(wt, mpg, fill = qsec)) +
  geom_myKitty()


