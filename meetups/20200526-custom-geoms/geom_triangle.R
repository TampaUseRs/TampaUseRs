library(ggplot2)
library(grid)

tGrob <- function(xc, yc, size, angle, fill = "darkgreen", alpha = 0.2) {
  sinA = sin(angle)
  cosA = cos(angle)
  dx = c( -size/2, 0, size/2)
  dy = c( -size/2, size/2, -size/2)
  gl <- gList(
    polygonGrob(x = xc + (dx*cosA - dy*sinA), y = yc + (dx*sinA + dy*cosA), 
                gp = gpar(fill = fill, alpha = alpha, col = 0))
  )
  gl
}

tpsGrob <- function(x, y, size, angle, fill, alpha) {
  sizeMax <- max(size)
  sizeMin <- min(size)
  scaledSize <- 0.005 + 0.1 * (size - sizeMin) / (sizeMax - sizeMin)  
  listOfGrobs <- mapply(
    function(xc, yc, size, angle, fill, alpha) {
     tGrob(xc, yc, size, angle, fill, alpha)
    }, x, y, scaledSize, angle, fill, alpha)
  class(listOfGrobs) <- "gList"
  gt <- gTree(name = "triangles", children = listOfGrobs, gp = NULL)
}

triangles_DrawPanel <- function(data, panel_scales, coord, na.rm = FALSE, alpha = 0.1) {
  coords <- coord$transform(data, panel_scales)
  ggplot2:::ggname("geom_triangles", 
      tpsGrob(coords$x, coords$y, coords$size, coords$angle, coords$fill, alpha)
  )
}

gTriangles <- ggproto( 
                "gTriangles", 
                Geom, 
                draw_panel = triangles_DrawPanel, 
                non_missing_aes = c("x", "y", "size"),
                default_aes = aes(angle = 0.0, fill = "darkgreen"),
                icon = function(.) {}, 
                desc_params = list(), 
                seealso = list(), 
                extra_params = c("na.rm", "alpha"),
                examples = function(.) {}
              )

geom_triangles <- function(mapping = NULL, data = NULL, stat = "identity", 
                           position = "identity", na.rm = FALSE, show.legend = NA, 
                           inherit.aes = TRUE, alpha = 0.2) {
  layer(
    data = data, 
    mapping = mapping, 
    stat = stat, 
    geom = gTriangles, 
    position = position, 
    show.legend = show.legend, 
    inherit.aes = inherit.aes, 
    params = list(na.rm = na.rm, alpha = alpha)
  )
}

set.seed(123)

dc <- mtcars[,c("wt", "mpg", "hp", "cyl")]
angle <- runif(1:32) * 2.0*pi
dc <- cbind(dc, angle)

ggplot(dc, aes(wt, mpg, size=hp)) + 
  geom_triangles( aes(angle = angle, fill = cyl), alpha = 0.4) +
  scale_y_continuous(limits = c(0.0, 55))
