library(stringr)
library(shiny)
library(tm)

bg <- readRDS("bigram.RData")
tg <- readRDS("trigram.RData")
qd <- readRDS("quadgram.RData")

message <- ""

predictWord <- function(the_word) {
        word_add <- stripWhitespace(removeNumbers(removePunctuation(tolower(the_word),preserve_intra_word_dashes = TRUE)))
        the_word <- strsplit(word_add, " ")[[1]]
        n <- length(the_word)
        if (n == 1) {the_word <- as.character(tail(the_word,1)); functionBigram(the_word)}
        else if (n == 2) {the_word <- as.character(tail(the_word,2)); functionTrigram(the_word)}
        else if (n >= 3) {the_word <- as.character(tail(the_word,3)); functionQuadgram(the_word)}
}

functionBigram <- function(the_word) {
        if (identical(character(0),as.character(head(bg[bg$word1 == the_word[1], 2], 1)))) {
                message<<-"" 
                as.character(head("it",1))
        }
        else {
                message <<- ""
                as.character(head(bg[bg$word1 == the_word[1],2], 1))
        }
}

functionTrigram <- function(the_word) {
        if (identical(character(0),as.character(head(tg[tg$word1 == the_word[1]
                                                        & tg$word2 == the_word[2], 3], 1)))) {
                as.character(predictWord(the_word[2]))
        }
        else {
                message<<- ""
                as.character(head(tg[tg$word1 == the_word[1]
                                     & tg$word2 == the_word[2], 3], 1))
        }
}

functionQuadgram <- function(the_word) {
        if (identical(character(0),as.character(head(qd[qd$word1 == the_word[1]
                                                        & qd$word2 == the_word[2]
                                                        & qd$word3 == the_word[3], 4], 1)))) {
                as.character(predictWord(paste(the_word[2],the_word[3],sep=" ")))
        }
        else {
                message <<- ""
                as.character(head(qd[qd$word1 == the_word[1] 
                                     & qd$word2 == the_word[2]
                                     & qd$word3 == the_word[3], 4], 1))
        }       
}

shinyServer(function(input, output) {
        output$prediction <- renderPrint({
                result <- predictWord(input$inputText)
                output$sentence2 <- renderText({message})
                result
                });
        output$sentence1 <- renderText({
                input$inputText});
}
)