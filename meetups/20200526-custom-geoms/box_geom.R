library(ggplot2)
library(grid)

scale_Values <- function(values, vFloor, vCeil) {
  vMin = min(values)
  vMax = max(values)
  vFloor + vCeil * (values - vMin) / (vMax - vMin)
}

myBoxesGrob <- function(x, y, width, height, fill, alpha) {
  scaledWidth <- scale_Values(width, 0.005, 0.1)
  scaledHeight <- scale_Values(height, 0.005, 0.1)
  gp = gpar(fill = fill, alpha = alpha)
  rectGrob(x, y, scaledWidth, scaledHeight, gp = gp)
}

boxes_DrawPanel <- function(data, panel_scales, coord, na.rm = FALSE) {
  coords <- coord$transform(data, panel_scales)
  ggplot2:::ggname("geom_boxes", 
      myBoxesGrob(coords$x, coords$y, coords$width, coords$height, coords$fill, coords$alpha))
}

geom_boxes <- function(mapping = NULL, data = NULL, stat = "identity", 
                        position = "identity", na.rm = FALSE, show.legend = NA, 
                        inherit.aes = TRUE, ...) {
  layer(
    data = data, 
    mapping = mapping, 
    stat = stat, 
    geom = gBoxes, 
    position = position, 
    show.legend = show.legend, 
    inherit.aes = inherit.aes, 
    params = list(na.rm = na.rm, ...)
  )
}

gBoxes <- ggproto( "gBoxes", 
                    Geom, 
                    draw_panel = boxes_DrawPanel, 
                    non_missing_aes = c("x", "y", "width", "height"),
                    default_aes = aes(fill = "lightgreen", alpha = "0.5", size = 1),
                    icon = function(.) {}, 
                    desc_params = list(), 
                    seealso = list(), 
                    examples = function(.) {})

dc <- mtcars[,c("wt", "mpg", "drat", "qsec", "carb", "cyl")]

ggplot(dc, aes(x=wt, y=mpg, width=drat, height=qsec)) +
  geom_boxes(aes(alpha = carb, fill = cyl))
