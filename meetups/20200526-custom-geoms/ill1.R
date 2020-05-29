library(ggplot2)

#most basic plot - mtcars, mpg vs wt with size varying with hp
ggplot( data = mtcars, aes(wt, mpg, size=hp)) +
  geom_point()

#slightly fancier plot - mtcars, mpg vs wt with size varying with hp, color = cylinder
ggplot( data = mtcars, aes(wt, mpg, col = cyl, size=hp)) +
  geom_point()

#even slightly fancier plot - mtcars, mpg vs wt with size varying with hp, color = cylinder
# with an overridden aesthetic to set the 
ggplot( data = mtcars, aes(wt, mpg, col = cyl, size=hp)) +
  geom_point(alpha = 0.4)

ggplot( data = mtcars, aes(wt, mpg, col = cyl)) +
  geom_point() +
  geom_line()

ggplot( data = mtcars, aes(wt, mpg, col = cyl, size=hp)) +
  geom_point() +
  geom_line()

ggplot( data = mtcars, aes(wt, mpg, col = cyl, size=hp)) +
  geom_point() +
  geom_line(alpha = 0.4)

#even slightly fancier plot - mtcars, mpg vs wt with size varying with hp, color = cylinder
# with an overridden aesthetic to set the 
ggplot( data = mtcars, aes(wt, mpg, col = cyl, size=hp)) +
  geom_point() +
  geom_line(alpha = 0.4, size = 0.5)

ggplot( data = mtcars, aes(wt, mpg, col = cyl, size=hp)) +
  geom_point() +
  geom_line(aes(alpha=cyl), size = 0.5)
