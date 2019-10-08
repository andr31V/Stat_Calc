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
#ss <- 312

ss <- reactive({sample(input$confidence,input$margin,input$bad,input$pop)})

output$text <- renderText({ss()})

output$propPlot <- renderPlot({
  
  df <- data.frame(
    x=c(seq(0,1,by=.01)),
    y=sapply(c(seq(0,100,by=1)),sample,conf=input$confidence,marg=input$margin,popu=input$pop)
    ) %>% 
    ggplot(aes(x,y,colour=y)) +
    geom_point() +
    geom_line() +
    labs(x="Expected Proportion",y="Sample Size") +
    theme_minimal() +
    scale_color_continuous(name="SS") 
  
    point <- df$data %>% 
      filter(y==ss()) 
    
    df_prop <- df +
      geom_point(data=point,aes(x,y),colour="red",size=5)
    
#plot(df_prop)
    
    df_prop
})
  
output$confPlot <- renderPlot({
  
  df <- data.frame(
    x=c(seq(.9,.99,by=.0005)),
    y=sapply(c(seq(90,99,by=.05)),sample,prop=input$bad,marg=input$margin,popu=input$pop) 
  ) %>% 
    ggplot(aes(x,y,colour=y)) +
    geom_point() +
    geom_line() +
    labs(x="Level of Confidence",y="Sample Size") +
    theme_minimal() +
    scale_color_continuous(name="SS")
  
  point <- df$data %>% 
    filter(y==ss()) 
  
  df_conf <- df +
    geom_point(data=point,aes(x,y),colour="red",size=5)

  df_conf  
})

output$margPlot <- renderPlot({
  
  df  <- data.frame(
    x=c(seq(.01,.05,by=.001)),
    y=sapply(c(seq(1,5,by=.1)),sample,prop=input$bad,conf=input$confidence,popu=input$pop) 
  ) %>% 
    ggplot(aes(x,y,colour=y)) +
    geom_point() +
    geom_line() +
    labs(x="Margin of Error",y="Sample Size") +
    theme_minimal() +
    scale_color_continuous(name="SS") 
  
  point <- df$data %>% 
    filter(y==ss()) 
  
  df_err <- df +
    geom_point(data=point,aes(x,y),colour="red",size=5)
  
  df_err
})

}