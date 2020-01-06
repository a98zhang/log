### 1. Introduction

#### 1.1 Econometrics

* quantitative analysis of economic variables, particularly the **causal** relationship using probabilistic statistics

* not experimental, so not innately causal, but evidence-based research innately an attempt for causal relationship 

* if only interested in prediction, correlations are enough (e.g. epidemiology using search big data); however, in policy research, correlations are not enough

* econometrics should be based on economic theories.

* threats: 

  * reverse causality: e.g. income - consumption

  * confounder (a Z that affects both X and Y): e.g. returns  to schooling
    $$
    ln\ w_i = \alpha + \beta s_i + \epsilon_i
    $$

    * `w`: wage (the logarithm of which is dependent variable), `s`: year of schooling  (explanatory variable, regressor, independent variable), `alpha` and `beta` are 

    * `e`: unobservable error term / stochastic disturbance,  including all other variables that may influence the dependent variable as well as the innate randomness of human behaviors

      * Assuming true model:
        $$
        ln\ w_i = \alpha + \beta s_i + \gamma s_i^{2} + \epsilon_i
        $$
        Then the quadratic term is included in stochastic disturbance as well

      * measurement error

      * Those that cannot be measured any way, so called omitted variables, will be included into stochastic disturbance.

      * very subtle yet also very important in econometrics

    * confounder: ability, which can be positively correlated to `s` schooling; hence, `beta` can be over-estimated. 

    * solutions: to introduce as many control variables as possible, i.e. use multivariate regressions, to properly estimate parameters of interest. 

#### 1.2 Economic data

* characteristics of economic data, or economic variables
  * is *not* experimental (incapable of conducting controlled experiment)
  * is often observational (from surveys)
  * in essence random variable due to randomness of human behaviors, only such that can consider its correlation with stochastic disturbance (if fixed, then its correlation with any other random variable is 0)
* categories of economic data
  * cross-sectional data (横截面数据): all variables at one exact time, e.g. yearly GDP of all provinces of 2013
  * time series data: a variable at different time points, e.g. yearly GDP of Jiangsu from 2014 to 2019.
  * panel data: all variables at multiple time points 

### 2. Stata

* empirical cumulative distribution function: `tabulate var`
* ``gen college = (s >= 15)``

### 3. Mathematics



