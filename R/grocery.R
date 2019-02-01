
groc.repo <- "https://raw.githubusercontent.com/thebigez8/grocery/master/"

clean_data <- function(x)
{
  x %>%
    grep(pattern = "^(Store|Item)", value = TRUE) %>%
    gsub(pattern = "(\\D)\\s(\\D)", replacement = "\\1\\2") %>%
    gsub(pattern = "\\s+", replacement = " ") %>%
    gsub(pattern = "< 2e-16", replacement = "2e-16") %>%
    read.delim(header = FALSE, text = ., sep = " ") %>%
    setNames(c("term", "estimate", "std.error", if(ncol(.) == 6) "df", "t", "p")) %>%
    dplyr::mutate(
      estimate = round(exp(estimate), 2),
      p = ifelse(p < 0.001, "p < 0.001", paste0("p = ", round(p, 3)))
    )
}

groc.df <- groc.repo %>%
  paste0("results.md") %>%
  readLines() %>%
  clean_data()

html(
  class = "finance theme-bg",
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
      "I ran a linear model to predict the (natural log of) price per month per item based ",
      "on store and item (taking advantage of the factorial design). The full results are ",
      a("here", href = paste0(groc.repo, "results.md")), ", but I'll summarize them here:",
      as.html = TRUE
    ),
    ol(
      li("Aldi is the cheapest"),
      map(c("Costco", "Target", "Walmart", "Hy-Vee"), function(store, trm = paste0("Store", store))
        li(paste0(
          store, " is on average ",
          groc.df$estimate[groc.df$term == trm],
          " times more expensive per month per item than Aldi (",
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
      "cheapest. Costco traded spots with Target in 4/27 models, and Walmart traded spots with ",
      "Hy-Vee in 5/27 models."
    ),
    p("So what did we learn?"),
    ol(
      li("Aldi is cheap. Yikes."),
      li(paste0(
        "Costco might live up to its reputation (but is the membership cost-effective? That's ",
        "a question for another day...)."
      )),
      li(paste0(
        "For all food that Aldi doesn't sell (or for emergency grocery runs), we'll go to Target, ",
        "which is the closest to our home anyway."
      )),
      li("Walmart and Hy-Vee are just too expensive.")
    )
  )
) %>%
  write2file(file = "docs/finance/grocery_stores.html")




groc.df2 <- groc.repo %>%
  paste0("results2.md") %>%
  readLines() %>%
  head(grep("^Correlation ", .)) %>%
  clean_data()

html(
  class = "finance theme-bg",
  HTMLhead(
    titl = "Grocery Store Analysis, Revisited", js = c("overlay", "overlay_only"),
    keywords = paste0("Aldi,Target,Costco,Walmart,Hy-Vee,Cub,Trader Joe's,Kwik Trip,",
                      "Groceries,Linear Model,Linear Mixed Effects Model"),
    desc = "An analysis of 45 grocery items to determine the cheapest of 8 grocery stores",
    date = "2019-01-31"
  ),
  body(
    navbar(),
    disclaimer(
      "This page may not generalize to all family consumptions or geographic areas, ",
      "nor does the analysis presented consider all possible items or stores."
    ),
    h2("Which Grocery Store is Cheapest, Revisited"),
    p0(
      "In a ", a("previous article", href = "grocery_stores.html"), ", I spent three days ",
      "searching groceries stores for various items to figure out, on average, which of the ",
      "stores we shop at was the cheapest. Since that article, friends and family alike have ",
      "suggested a similar exercise for other stores. So like a true penny-pincher, I spent ",
      "7 hours on a Saturday tracking down prices (with only a few dirty looks from employees). ",
      "This time, I selected 45 common items and 5 stores. Once again, where possible, I tried to ",
      "find comparable items across the stores (which was still harder than I thought), and I'd ",
      "usually pick the cheapest version of an item if there were multiple choices. ",
      "This is an important qualification of this analysis: the ",
      "prices here aren't necessarily for the highest quality item.", as.html = TRUE
    ),
    p0(
      "Using R, I normalized the data to calculate a price per unit. I then calculated the price ",
      "per item per month (since if I only have to buy an expensive item once per year at a store but ",
      "everything else is cheap, I'll still want to go there). This is the second important ",
      "qualification of this analysis: I had to estimate how many times per month we bought each ",
      "item. I guarantee that no one else has the same grocery purchase profile as the one I used."
    ),
    p("The results shook out like this (visit #1 on the left, #2 on the right):"),
    overlay.img(
      id = "price-per-month-plot",
      src = paste0(groc.repo, "price_per_month2.png"),
      alt1 = "Plot of Price per Month per Item at Each Store", alt2 = "Larger Plot"
    ),
    p0(
      "I ran a linear mixed effects model to predict the (natural log of) price per month oer item, ",
      "using items and seasonality (of certain produce) as random effects and store as a fixed ",
      "effect. The full results are ", a("here", href = paste0(groc.repo, "results2.md")),
      ", but I'll summarize them here:",
      as.html = TRUE
    ),
    ol(
      li("Aldi is still the cheapest"),
      map(
        c("Costco", "Target", "Walmart", "Hy-Vee", "Cub", "Trader Joe's", "Kwik Trip"),
        function(store, trm = paste0("Store", sub(" ", "", store)))
        li(paste0(
          store, " is on average ",
          groc.df2$estimate[groc.df2$term == trm],
          " times more expensive per month per item than Aldi (",
          groc.df2$p[groc.df2$term == trm], ")"
        ))
      )
    ),
    p0(
      "Once again, Target is helped by the fact that I have the Target app and a RedCard, ",
      "which means all items are essentially already 5% off for me. At all the other stores, I ",
      "took into account my 2% cash back on my normal credit card."
    ),
    p0(
      "To make sure these results weren't driven by a single item, I ran a sensitivity analysis, ",
      "removing each item in turn and recalculating the model. Cub traded spots with Trader Joe's ",
      "in 5/45 models, but all other stores remained firm in their rankings."
    ),
    p("So what did we learn?"),
    ol(
      li("Aldi is still dirt cheap."),
      li("Costco gained some ground on Aldi with the inclusion of more items."),
      li("We didn't find a new store that was cheaper than the ones at which we previously shopped.")
    )
  )
) %>%
  write2file(file = "docs/finance/grocery_stores_revisited.html")

