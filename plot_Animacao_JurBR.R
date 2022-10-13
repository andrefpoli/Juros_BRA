if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  "fixedincome",
  "rb3",
  "bizdays",
  "dplyr",
  "ggplot2",
  "highcharter"
  )

c("hc_plot_ft","hc_theme_ft") %>%
  paste0("./Juros_Brasil/", ., ".R") %>% 
  purrr::walk(~source(.x))

# Colors for the plots
colors <- c(
  blue   = "#282f6b",
  red    = "#b22200",
  yellow = "#eace3f",
  green  = "#224f20",
  purple = "#5f487c",
  orange = "#b35c1e",
  turquoise  = "#419391",
  green_two  = "#839c56",
  light_blue = "#3b89bc",
  blue_ft = "#0D7680",
  marrom_ft = "#8F223A",
  grey_ft = "#505B70"
)



# função que retorna curva spot para a data referida
get_di1_curve <- function(refdate) {
  fut <- futures_get(refdate)
  yc <- yc_get(refdate)
  df <- yc_superset(yc, fut)
  
  df_curve <- bind_rows(
    df |> slice(1) |> select(biz_days, r_252),
    df |> filter(!is.na(symbol)) |> select(biz_days, r_252)
  ) |>
    filter(!duplicated(biz_days))
  
  spotratecurve(
    df_curve$r_252, df_curve$biz_days, "discrete", "business/252", "Brazil/ANBIMA",
    refdate = refdate
  )
}

df <- futures_mget(
  first_date = "2022-10-09",
  last_date = preceding(Sys.Date() - 1, "Brazil/ANBIMA")
)

df_di1 <- df |> filter(commodity == "DI1")

df_di1_futures <- df_di1 |>
  mutate(
    maturity_date = maturity2date(maturity_code),
    fixing = following(maturity_date, "Brazil/ANBIMA"),
    business_days = bizdays(refdate, fixing, "Brazil/ANBIMA"),
    adjusted_tax = round(implied_rate("discrete", business_days / 252, 100000 / price),4)
  ) |>
  filter(business_days > 0)

df_ft <- df_di1_futures %>%
  hchart("line", hcaes(x = business_days, y = 100*adjusted_tax, group = refdate), color = colors[c("blue_ft","marrom_ft")]) %>%
  hc_plot_ft(
    title     = "CURVAS PRE",
    subtitle  = "Accumulated growth rate in 4 quarters",
    source    = "IBGE",
    range     = FALSE,
    navigator = TRUE
  )
df_ft

#debug(get_di1_curve(dates[1]))

# retorna vetor de datas
dates <- bizseq("2022-10-05", "2022-10-11", "Brazil/ANBIMA")

# aplica a funcao de curva spot para o range de datas
curves <- lapply(seq_along(dates), function(ix) get_di1_curve(dates[ix])) #aplica uma função a um vetor


# cria animação do GIF
anim <- animation::saveGIF(
  {
    g <- autoplot(curves[[1]], curve.x.axis = "terms", colour = "red") +
      autolayer(curves[[1]], curve.geom = "point", curve.x.axis = "terms", colour = "red") +
      ylim(0.11, 0.14) +
      theme_bw() +
      theme(legend.position = "none") +
      labs(
        x = "Prazos", y = NULL, title = "Curvas de Juros Prefixados DI1",
        subtitle = paste0("Entre as datas ",dates[1],"e ",dates[length(dates)]),
        caption = "Desenvolvido por Andre Ferreira / Fonte: B3"
      )
    print(g)
    
    for(curve in curves[-c(1, length(curves))]) {
      g <- g + autolayer(curve, curve.x.axis = "terms", colour = "grey") +
        autolayer(curve,
                  curve.geom = "point", curve.x.axis = "terms", colour = "grey"
        )
      print(g)
    }
    
    g <- g + autolayer(curves[[length(curves)]], curve.x.axis = "terms", colour = "blue") +
      autolayer(curves[[length(curves)]],
                curve.geom = "point", curve.x.axis = "terms", colour = "blue"
      )
    print(g)
  },
  interval = 0.8,
  ani.height = 400,
  ani.width = 750
)


# cria animação do GIF
anim <- animation::saveGIF(
  {
    for(curve in curves[-c(1, length(curves))]) {
      g <- autolayer(curve, curve.x.axis = "terms", colour = "grey") +
        autolayer(curve,
                  curve.geom = "point", curve.x.axis = "terms", colour = "grey")
      print(g)
    }
    
  },
  interval = 0.8,
  ani.height = 400,
  ani.width = 750
)



terms <- c(1, 11, 26, 27, 28)
rates <- c(0.0719, 0.056, 0.0674, 0.0687, 0.07)

curve <- spotratecurve(rates, terms, "discrete", "business/252", "Brazil/ANBIMA")

# access the term 11 days
curve[[11]]

# access the second element
curve[2]

