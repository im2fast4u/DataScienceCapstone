library(shiny)
library(markdown)

shinyUI(
        fluidPage(
                titlePanel("Coursera Data Science Specialization Capstone Project"),
                sidebarLayout(
                        sidebarPanel(
                                textInput("inputText", "Enter a word",value = ""),
                                hr()
                                ),
                mainPanel(
                        h2("Next Word Prediction"),
                        verbatimTextOutput("prediction")
                        )
                )
        )
)