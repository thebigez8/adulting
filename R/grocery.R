
groc.repo <- "https://raw.githubusercontent.com/thebigez8/grocery/master/"
groc.df <- groc.repo %>%
  paste0("results.md") %>%
  readLines() %>%
  grep(pattern = "^Store", value = TRUE) %>%
  gsub(pattern = "\\s+", replacement = " ") %>%
  read.delim(header = FALSE, text = ., sep = " ") %>%
  setNames(c("term", "estimate", "std.error", "t", "p")) %>%
  dplyr::mutate(
    estimate = round(estimate, 2),
    p = ifelse(p < 0.01, "p < 0.01", paste0("p = ", round(p, 2)))
  )
html(
  class = "finance",
  HTMLhead(
    titl = "Grocery Store Analysis", js = c("overlay", "overlay_only"),
    keywords = "Aldi,Target,Costco,Walmart,Hy-Vee,Groceries,Linear Model",
    desc = "An analysis of 27 grocery items to determine the cheapest of 5 grocery stores",
    date = "2018-11-21"
  ),
  body(
    navbar(),
    disclaimer(
      "This page may not generalize to all family consumptions or geographic areas, ",
      "nor does the analysis presented consider all possible items or stores."
    ),
    h2("Which Grocery Store is Cheapest?"),
    p0(
      "I like saving money, which led me to a natural question: how can I save money on groceries? ",
      "To answer this question, I selected 27 common items and 5 stores, and over the span of 3 days ",
      "visited each store to record the price (and size) of each item. Where possible, I tried to ",
      "find comparable items across the stores (which ended up being harder than I thought). Some ",
      "items I simply couldn't find (Where does Hy-Vee keep its olive oil? Why was Target out of ",
      "chicken strips? Can I petition Aldi to carry Annie's Mac and Cheese?). Where more than one ",
      "choice existed for a certain item, I'd usually pick the cheapest (which almost always ended ",
      "up being the store's own brand). This is an important qualification of this analysis: the ",
      "prices here aren't necessarily for the highest quality item."
    ),
    p0(
      "Using R, I normalized the data to calculate a price per unit (thanks to Costco for selling ",
      "things in far more enormous quantities than I need). I then calculated the price per item ",
      "per month (since if I only have to buy an expensive item once per year at a store but ",
      "everything else is cheap, I'll still want to go there). This is the second important ",
      "qualification of this analysis: I had to estimate how many times per month we bought each ",
      "item. Turns out we (I) eat a lot of Annie's mac and cheese and chicken strips. I guarantee ",
      "that no one else has the same grocery purchase profile as the one I settled on."
    ),
    p("The results shook out like this:"),
    overlay.img(
      id = "price-per-month-plot",
      src = paste0(groc.repo, "price_per_month.png"),
      alt1 = "Plot of Price per Month per Item at Each Store", alt2 = "Larger Plot"
    ),
    p0(
      "I ran a linear model to predict the price per month per item based on store and item ",
      "(taking advantage of the factorial design). The full results are ",
      a("here", href = paste0(groc.repo, "results.md")), ", but I'll summarize them here:",
      as.html = TRUE
    ),
    ol(
      li("Aldi is the cheapest"),
      map(c("Target", "Costco", "Walmart", "Hy-Vee"), function(store, trm = paste0("Store", store))
        li(paste0(
          store, " is on average $",
          groc.df$estimate[groc.df$term == trm],
          " more expensive per month per item than Aldi (",
          groc.df$p[groc.df$term == trm], ")"
        ))
      )
    ),
    p0(
      "To be fair, Target is helped by the fact that I have the Target app and a RedCard, ",
      "which means all items are essentially already 5% off for me. At all the other stores, I ",
      "took into account my 2% cash back on my normal credit card."
    ),
    p0(
      "To make sure these results weren't driven by a single item, I ran a sensitivity analysis, ",
      "removing each item in turn and recalculating the model. In all models, Aldi remained the ",
      "cheapest, and Hy-Vee remained the most expensive, but there was a small amount of variability ",
      "in the second through fourth place spots, suggesting that a few items are unusually ",
      "expensive at Costco and Walmart."
    ),
    p("So what did we learn?"),
    ol(
      li("Aldi is cheap. Yikes."),
      li(paste0(
        "For all food that Aldi doesn't sell (or for emergency grocery runs), we'll go to Target, ",
        "which is the closest to our home anyway."
      )),
      li("My wife's impression that Hy-Vee was too expensive was correct.")
    )
  )
) %>%
  write2file(file = "docs/finance/grocery_stores.html")


