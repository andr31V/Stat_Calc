library(shiny)
library(ggplot2)
library(tidyverse)

  server <- function(input, output, session) {
  
    # conf <- 90
    # marg <- 2
    # prop <- 5
    #popu <- 10000
    
sample <- function(conf,marg,prop,popu) {
    
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
  ss
  
}

#sample(90,2,5,10000)
  
  df <- data.frame(
    x=c(seq(0,1,by=.01)),
    y=sapply(c(seq(0,100,by=1)),sample,conf=conf,marg=marg,popu=popu)
    )
  
  ggplot(df,aes(x,y,colour=y)) +
    geom_point() +
    geom_line() +
    labs(x="Expected Proportion",y="Sample Size") +
    theme_minimal() +
    scale_color_continuous(name="SS") +
    geom_point(data=subset(df,y==1447),aes(x,y),colour="red",size=5)
  
}