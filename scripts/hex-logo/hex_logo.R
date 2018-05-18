# ---- Load Packages ----
if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh("GuangchuangYu/hexSticker")
pacman::p_load("showtext")

# ---- Fonts ----
sysfonts::font_add_google("New Rocker")
sysfonts::font_add_google("Trade Winds")
sysfonts::font_add_google("Stint Ultra Expanded")
showtext::showtext_auto()

# ---- Colors ----
flag_red       <- rgb(176,  30,  52, max = 255)
r_grey         <- rgb(144, 144, 151, max = 255)
r_grey_light   <- rgb(180, 180, 188, max = 255)
r_grey_exlight <- rgb(250, 250, 255, max = 255)
r_blue         <- rgb(23,   93, 171, max = 255)

# ---- Set Hex Sticker Parameters ----
fill_color    <- r_blue
border_color  <- r_grey
name_color    <- r_grey_exlight
twitter_color <- r_grey_light

# ---- Set base sticker defaults ----
sticker_fun <- function(...) {
  function(filename, url = "") {
    sysfonts::font_add_google("Trade Winds")
    sysfonts::font_add_google("Stint Ultra Expanded")
    # showtext_begin()
    sticker(..., filename = filename, url = url)
    # showtext_end()
  }
}

make_sticker <- sticker_fun(
  subplot = "rrr_logo.png", 
  package = "Tampa Bay", 
  s_x = 0.96,
  s_y = 1 + 0.05,
  s_width = 0.7,
  h_color = border_color,
  h_fill = fill_color,
  p_color = name_color,
  p_x = 0.99,
  p_y = 0.6 + 0.05,
  p_size = 7.5,
  p_family = "Trade Winds",
  u_color = twitter_color,
  u_family = "Stint Ultra Expanded"
)

# ---- Fancy TRUG Hex Stickers! ----

# Without Twitter Handle
make_sticker("trug-hex.png")

# With Twitter Handle
make_sticker("trug-hex-twitter.png", "@UserRTampa")