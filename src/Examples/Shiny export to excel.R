install.packages("shiny")
install.packages("openxlsx")
library(shiny)
library(openxlsx)

# create some example data to download
my_table <- data.frame(
  Name = letters[1:4],
  Age = seq(20, 26, 2),
  Occupation = LETTERS[15:18],
  Income = c(50000, 20000, 30000, 45000)
)

# add a totals row
my_table <- rbind(
  my_table,
  data.frame(
    Name = "Total",
    Age = NA_integer_,
    Occupation = "",
    Income = sum(my_table$Income)
  )
)

# minimal Shiny UI
ui <- fluidRow(
  column(
    width = 12,
    align = "center",
    tableOutput("table_out"),
    br(),
    downloadButton(
      "download_excel", 
      "Download Data to Excel"
    )
  )
)

# minimal Shiny server
server <- function(input, output) {
  output$table_out <- renderTable({
    my_table
  })
  
  
  output$download_excel <- downloadHandler(
    filename = function() {
      "employee_data.xlsx"
    },
    content = function(file) {
      my_workbook <- createWorkbook()
      
      addWorksheet(
        wb = my_workbook,
        sheetName = "Employee Data"
      )
      
      setColWidths(
        my_workbook,
        1,
        cols = 1:4,
        widths = c(6, 6, 10, 10)
      )
      
      writeData(
        my_workbook,
        sheet = 1,
        c(
          "Company Name",
          "Employee Data"
        ),
        startRow = 1,
        startCol = 1
      )
      
      addStyle(
        my_workbook,
        sheet = 1,
        style = createStyle(
          fontSize = 24,
          textDecoration = "bold"
        ),
        rows = 1:2,
        cols = 1
      )
      
      writeData(
        my_workbook,
        sheet = 1,
        my_table,
        startRow = 5,
        startCol = 1
      )
      
      addStyle(
        my_workbook,
        sheet = 1,
        style = createStyle(
          fgFill = "#1a5bc4",
          halign = "center",
          fontColour = "#ffffff"
        ),
        rows = 5,
        cols = 1:4,
        gridExpand = TRUE
      )
      
      addStyle(
        my_workbook,
        sheet = 1,
        style = createStyle(
          fgFill = "#7dafff",
          numFmt = "comma"
        ),
        rows = 6:10,
        cols = 1:4,
        gridExpand = TRUE
      )
      
      saveWorkbook(my_workbook, file)
    }
  )
  
  
}

shinyApp(ui, server)
