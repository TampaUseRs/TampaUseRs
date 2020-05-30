library(ggplot2)
library(grid)

##############################################################################
#circles geom
##############################################################################
scale_Values <- function(values, vFloor, vCeil) {
  vMin = min(values)
  vMax = max(values)
  vFloor + vCeil * (values - vMin) / (vMax - vMin)
}

myGeomGrob <- function(x, y, size, fill, alpha, colour) {
  scaledSize <- scale_Values(size, 0.005, 0.02)
  gp = gpar(fill = fill, alpha = alpha, col = colour)
  circleGrob(x = x, y = y, r = scaledSize, gp = gp, default.units = "npc")
}

myGeom_DrawPanel <- function(data, panel_scales, coord, na.rm = FALSE) {
  coords <- coord$transform(data, panel_scales)
  ggplot2:::ggname("geom_myGeom", myGeomGrob(coords$x, coords$y, coords$size, coords$fill, coords$alpha, coords$colour))
}

myGeom <- ggproto( 
  "myGeom", 
  Geom, 
  draw_panel = myGeom_DrawPanel, 
  non_missing_aes = c("x", "y", "alpha", "size"),
  default_aes = aes(size = 0.03, fill = "white", alpha = 1.0, colour = "darkgreen"),
  icon = function(.) {}, 
  desc_params = list(), 
  seealso = list(), 
  examples = function(.) {})

geom_myGeom <- function(mapping = NULL, data = NULL, stat = "identity", position = "identity", na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...) {
  layer(
    data = data, 
    mapping = mapping, 
    stat = stat, 
    geom = myGeom, 
    position = position, 
    show.legend = show.legend, 
    inherit.aes = inherit.aes, 
    params = list(na.rm = na.rm, ...)
  )
}

ggplot( mtcars, aes(wt, mpg, fill = cyl, size = qsec, alpha = drat)) +
  geom_myGeom()

