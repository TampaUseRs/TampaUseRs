library(grid)
library(RConics)

plusGrob <- function(x, y, angle, length, size, linetype=1, colour = "black") {
  
  sinA <- sin(angle)
  cosA <- cos(angle)
  
  l <- 0.5*length
  
  x0 = c( x - l, x )
  y0 = c( y, y - l )
  x1 = c( x + l, x )
  y1 = c( y, y + l )

  segmentsGrob(
    x0 = x0,
    y0 = y0,
    x1 = x1,
    y1 = y1,
    default.units =  "native",
    gp = gpar(col = colour, lwd = size*ggplot2:::.pt, lty=linetype, lineend = "butt")
  )
}

lineArrowGrob <- function(xc, yc, length, width, angle, linetype=1, colour = "blue", size = 1) {
  
  sinA <- sin(angle)
  cosA <- cos(angle)

  l <- 0.5*length
  w <- 0.5*width
  
  x = c(xc - l*cosA, xc + l*cosA)
  y = c(yc - l*sinA, yc + l*sinA)

  linesGrob(
    x = x, 
    y = y,
    default.units =  "native",
    gp = gpar(col = colour, lwd = size*ggplot2:::.pt, lty=linetype, arrow = arrow(45, type = "closed"), lineend = "butt")
  )
  
}

g4 <- lineArrowGrob(0.5, 0.5, 0.5, 0.25, 0.0, colour = "yellow")
g5 <- lineArrowGrob(0.5, 0.5, 0.5, 0.25, pi/4, colour = "yellow")

vp <- viewport(
  x = unit(0.5, "npc"), 
  y = unit(0.5, "npc"), 
  width = unit(0.5, "npc"), 
  height = unit(0.5, "npc"), 
  gp = gpar(fill = "red"))
pushViewport(vp)
grid.rect(width = 1, height = 1, gp = gpar(col = "black", fill = "green"))
grid.draw(g4)
grid.draw(g5)
popViewport()
