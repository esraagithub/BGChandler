#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

# 
# https://antismash.secondarymetabolites.org/upload/example/index.html#r1c8

library(tidyverse)
library(ggplot2)
library(vroom)
library(stringr)
library(Biostrings)
library(rBLAST)

library(reticulate)

library(shiny)

options(shiny.maxRequestSize = 10 * 1024^2)
source("deepbgc_functions.R")



#============================
# ui
#============================
ui <- fluidPage(
  fluidRow(
    h3("Deepbgc"),
    column(6,
           fileInput("bgc_tsv", "Bgc Data.tsv", buttonLabel = "Upload...")
    ),
    column(6,
           fileInput("bgc_gbk", "Bgc Data.gbk", buttonLabel = "Upload...")
    )
  ),
  
  fluidRow(
    h3("Antismash"),
    column(6,
           textInput("antismash_link", "Antismash Link.html")
    ),
    column(6,
           fileInput("antismash_genome", "Hole Genome.fasta", buttonLabel = "Upload...")
    )
  ),
  
  tabsetPanel(
    tabPanel("Deepbgc",
             fluidRow(
               splitLayout(style = "border: 1px solid silver;",
                           cellWidths = c("50%", "50%"),
                           #cellArgs = list(style = "padding: 6px"),
                           tableOutput("table1"),
                           plotOutput("graph1"))
             ),
             fluidRow(
               splitLayout(style = "border: 1px solid silver;",
                           cellWidths = c("50%", "50%"),
                           cellArgs = list(style = "padding: 6px"),
                           tableOutput("table2"),
                           plotOutput("graph2"))
             ),
             fluidRow(
               splitLayout(style = "border: 1px solid silver;",
                           cellWidths = c("50%", "50%"),
                           cellArgs = list(style = "padding: 6px"),
                           tableOutput("table3"),
                           plotOutput("graph3"))
             ),
             fluidRow(
               splitLayout(style = "border: 1px solid silver;",
                           cellWidths = c("50%", "50%"),
                           cellArgs = list(style = "padding: 6px"),
                           downloadButton('download_tables', 'Download Tables', class = "btn-block"),
                           downloadButton('download_graphs', 'Download Graphs', class = "btn-block"))
             ),
             downloadButton("fasta_download","Download bgc Fasta", class = "btn-block")
             
    ),
    
    tabPanel("Antismash",
             tableOutput("antismash_table"),
             downloadButton('download_antismash_table', 'Download Antismash Summary Table', class = "btn-block"),
             downloadButton('download_antismash_fasta', 'Download Antismash Fasta', class = "btn-block"),
             
             
    ),
    
    tabPanel("Shared BGC",
             tableOutput("shared"),
             downloadButton('download_shared_bgc', 'Download Shared BGC Table', class = "btn-block")
             
    )
    
    
  )
  
  
)
#============================
#server
#============================
server <- function(input, output, session) {
  # Upload ---------------------------------------------------------
  raw <- reactive({
    req(input$bgc_tsv)
    ext <- tools::file_ext(input$bgc_tsv$name)
    if (ext!= 'tsv') {
      validate(paste0("Enter a tsv file"))
    }
    else{
      import_bgcdata(input$bgc_tsv$datapath)
    }
  })
  
  output$table1 <- renderTable(raw()$table1)
  output$table2 <- renderTable(raw()$table2)
  output$table3 <- renderTable(raw()$table3)
  
  output$graph1 <- renderPlot(base::plot(raw()$graph1))
  output$graph2 <- renderPlot(base::plot(raw()$graph2))
  output$graph3 <- renderPlot(base::plot(raw()$graph3))
  
  
  fasta <- reactive({
    req(input$bgc_gbk)
    ext <- tools::file_ext(input$bgc_gbk$name)
    if (ext!= 'gbk') {
      validate(paste0("Enter a gbk file"))
    }
    else{
    get_bgc_fasta(input$bgc_gbk$datapath)
    }
  })
  
  antismash <- reactive({
    req(input$bgc_tsv)
    req(input$bgc_gbk)
    req(input$antismash_genome)
    
    html_to_txt(input$antismash_link)
    #write fasta file
    fileConn<-file("BGC_fasta.fasta")
    writeLines(as.character(fasta()), fileConn)
    close(fileConn)
    
    antismash_fun(file ="antismash.txt",
                  wholegenome= input$antismash_genome$datapath,
                  deepbgc_tsv=input$bgc_tsv$datapath,
                  deepbgc_fasta="BGC_fasta.fasta")
    
  })
  
  output$antismash_table <- renderTable(antismash()$antismash_summary_table)
  output$shared <- renderTable(antismash()$Shared_BGC)
  
  
  # Download bgc tables and graphs ---------------------------------------------------------
  output$download_tables <- downloadHandler(
    filename = 'deepbgc_summary_tables.zip',
    content = function(fname) {
      tmpdir <- tempdir()
      setwd(tempdir())
      print(tempdir())
      
      fs <- c("table1.csv", "table2.csv", "table3.csv")
      write.csv(raw()$table1, file = "table1.csv", sep =",")
      write.csv(raw()$table2, file = "table2.csv", sep =",")
      write.csv(raw()$table3, file = "table3.csv", sep =",")
      print (fs)
      
      zip(zipfile=fname, files=fs)
    },
    contentType = "application/zip"
  )
  
  output$download_graphs <- downloadHandler(
    filename = 'deepbgc_summary_graphs.zip',
    content = function(fname) {
      tmpdir <- tempdir()
      setwd(tempdir())
      print(tempdir())
      
      fs <- c("graph1.pdf", "graph2.pdf", "graph3.pdf")
      
      pdf("graph1.pdf")
      plot(raw()$graph1)
      dev.off()
      pdf("graph2.pdf")
      plot(raw()$graph2)
      dev.off()
      pdf("graph3.pdf")
      plot(raw()$graph3)
      dev.off()
      
      print (fs)
      
      zip(zipfile=fname, files=fs)
    },
    contentType = "application/zip"
  )
  
  # Download bgc fasta -------------------------------------------------------
  output$fasta_download <- downloadHandler(
    filename = function() {
      paste0(tools::file_path_sans_ext(input$bgc_gbk$name), ".fasta")
    },
    content = function(file) {
      writeLines(as.character(fasta()), file)
    }
  )
  
  # Download Antismash results -------------------------------------------------------
  output$download_antismash_table <- downloadHandler(
    filename = function() {
      paste0("Antismash_",tools::file_path_sans_ext(input$bgc_tsv$name), ".csv")
    },
    content = function(file) {
      write.csv(antismash()$antismash_summary_table,file)
    }
  )
  output$download_antismash_fasta <- downloadHandler(
    filename = function() {
      paste0("Antismash", ".fasta")
    },
    content = function(file) {
      writeLines(antismash()$Antismash_BGC_fasta , file)
    }
  )
  output$download_shared_bgc <- downloadHandler(
    filename = function() {
      paste0("shared_BGC", ".csv")
    },
    content = function(file) {
      write.csv(antismash()$Shared_BGC, file)
    }
  )
  
}

#============================
#shiny
#============================
shinyApp(ui, server)
