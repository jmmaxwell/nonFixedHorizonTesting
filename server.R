library(shiny)
library(dplyr)

server <- function(input, output) {
  
  tao = reactive({input$tao})
  test.sample.size = reactive({input$test.sample.size})
  control.sample.size = reactive({input$control.sample.size})
  test.conversions = reactive({input$test.conversions})
  control.conversions = reactive({input$control.conversions})
  
  sample.mean.control = reactive({control.conversions()/control.sample.size()})
  sample.mean.test = reactive({test.conversions()/test.sample.size()})
  
  total.sample.size = reactive({control.sample.size() + test.sample.size()})
  
  effect.variance = reactive({
    
    2 * (
      (sample.mean.control() * (1 - sample.mean.control())) + 
        (sample.mean.test() * (1 - sample.mean.test()))
    ) / total.sample.size()
    
  })
  
  
  pValueCalculator = reactive({ 
    
    distance.finder = function(alpha, Tao, VarianceN, sampleMeanControl, sampleMeanTest){
      decisionBound = sqrt( 
        (2 * log(1/alpha) - 
           log( VarianceN/(VarianceN + Tao) )) * 
          (VarianceN * (VarianceN + Tao) / Tao) 
      )
      
      distanceFromBound = abs(sampleMeanControl - sampleMeanTest) - decisionBound
      
      return(distanceFromBound)
    }
    
    vals = seq(.0001, 1, .0001)

    alpha.results = data.frame(pvalue = vals, distance = sapply(vals, distance.finder, 
                                                                VarianceN = effect.variance(), 
                                                                Tao = tao(),
                                                                sampleMeanControl = sample.mean.control(),
                                                                sampleMeanTest = sample.mean.test()))
    
    results.over.threshold = alpha.results %>%
      filter(distance > 0)
    
    if (nrow(results.over.threshold) == 0){
      p.value = "Never Crossed Threshold"
    } else {
      p.value = results.over.threshold %>%
        summarise(min(pvalue))
    }
    
    unlist(p.value)

  })
  
 output$pvalue <- renderText({ pValueCalculator() })

}
