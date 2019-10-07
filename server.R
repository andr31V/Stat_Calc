library(shiny)
library(ggplot2)
library(tidyverse)

  server <- function(input, output, session) {
  
    conf <- 90
    marg <- 2
    prop <- 5
    popu <- 10000
    
    
#derive alpha and zscore
  z_score <- conf %>%
    "/"(-100) %>% 
    +1 %>% 
    "/"(-2) %>% #get 2 tail alpha
    +1 %>% 
    qnorm()
#derive sample size: p(1-p) * (zscore/moe)^2
  p <- prop/100  
  moe <- marg/100
  ss <- p %>% 
    "*"(1-p) %>% 
    "*"((z_score/moe)^2)
  ss <- ss %>% #finite population correction (fpc) embedded
    "/"(1+ss/popu) %>% 
    ceiling()
  
  
}