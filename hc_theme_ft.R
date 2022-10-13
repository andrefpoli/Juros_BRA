# create theme

theme_DYH_2 <- hc_theme_merge(
  hc_theme_ft(),
  hc_theme(
    chart = list(style = list(fontFamily = "Droid Serif", color = "#333")),
    title = list(
      style = list(fontFamily = "Droid Serif", color = "black", fontWeight = "bold"),
      align = "center"
    ),
    subtitle = list(
      style = list(fontFamily = "Droid Serif", fontWeight = "bold"),
      align = "center"
    ),
    legend = list(align = "center", verticalAlign = "bottom"),
    xAxis = list(
      align = "center",
      gridLineDashStyle = "Dot",
      gridLineWidth      = 1,
      gridLineColor      = "##CEC6B9",
      lineColor          = "#CEC6B9",
      minorGridLineColor = "#CEC6B9",
      tickColor          = "#CEC6B9",
      tickWidth          = 1
    ),
    yAxis = list(
      align = "center",
      gridLineDashStyle = "Dot",
      gridLineColor      = "#CEC6B9",
      lineColor          = "#CEC6B9",
      minorGridLineColor = "#CEC6B9",
      tickColor          = "#CEC6B9",
      tickWidth          = 1
    )
  )
)