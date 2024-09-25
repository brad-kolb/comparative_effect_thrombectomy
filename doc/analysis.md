# Comparative effect of thrombectomy


# Abstract

## Importance

Variation in relative and absolute treatment effect of mechanical
thrombectomy for different types of stroke has not been explored.

## Objective

To make clinically useful estimates for the relative and absolute effect
of thrombectomy on the chances of favorable outcome at 90 days for
clinically relevant types of stroke.

## Data sources

Pubmed and EMBASE was searched through May 2024.

## Study selection

All randomized trials of best medical management versus best medical
management plus modern mechanical thrombectomy were included.

## Data extraction and synthesis

The preferred reporting items for systematic reviews and meta-analysis
(PRISMA) guidelines were used. Data extraction by the first author was
independently confirmed by the second. A varying-slopes
varying-intercepts Bayesian multilevel logistic regression was fit to
the extracted data.

## Main outcomes and measures

The main outcomes were the risk ratio (chance of functional independence
in treatment group / chance of functional independence in control group)
and risk difference (chance of functional independence in treatment
group - chance of functional independence in control group). Functional
independence was defined as a score of 0 to 2 on the modified Rankin
scale at 90 days.

## Results

A total of 22 studies were included, with 5 examining outcomes for large
core stroke patients, 9 for small core stroke, 4 for late window stroke,
and 4 for basilar stroke. The estimated relative effect of thrombectomy
was highest for large core stroke (RR XXX, 95% PI XX-XX), followed in
order by basilar (RR XXX, 95% PI XX-XX), late (RR XXX, 95% PI XX-XX),
and small (RR XXX, 95% PI XX-XX). The estimated absolute effect showed a
reverse pattern, with small core stroke the highest (RD XX, 95% PI
XX-XX), followed by late (RD XX, 95% PI XX-XX), basilar (RD XX, 95% PI
XX-XX), and large (RD XX, 95% PI XX-XX).

# Methods

# Results

## Search Results

The initial database and registry search yielded XXX studies. Following
title and abstract screening, XXX were retained, with 22 remaining after
full-text review.

## Risk of Bias

We concluded that XXX% of included studies had low risk of bias, XXX%
had some risk, and XXX% had high risk.

## Study and Population Characteristics

The intention to treat population included 5513 participants across 22
randomized control trials. 2687 were assigned to medical management,
while 2826 were assigned to thrombectomy plus medical management. Each
trial was assigned to one of K = 4 categories according to the type of
stroke patients enrolled. Category 1 (“large”) was anterior circulation
strokes with a large core. Category 2 (“small”) was anterior circulation
strokes with small to medium sized cores treated in an early time
window. Category 3 (“late”) was anterior circulation strokes with small
to medium sized cores treated in an extended time window. Category 4
(“basilar”) was strokes due to large vessel occlusion of the
vertebobasilar artery complex. Table 1 contains further information on
study design and population characteristics.

## Descriptive Results

Descriptive results by trial are plotted below, with color corresponding
to stroke type and the size of the bubble to the sample size of the
trial. Bubbles above the grey dashed line denote trials in which the
frequency of good outcome at 90 days was greater for thrombectomy
patients than for those treated with best medical management only.

![](images/scatter_plot-03.png) The data for individual trials are shown
here.

    # A tibble: 22 × 8
           K name         size    f_c   f_t    rr     rd   nnt
       <dbl> <chr>       <dbl>  <dbl> <dbl> <dbl>  <dbl> <dbl>
     1     1 ANGEL         251 0.116  0.3    2.60 0.184   5.42
     2     1 RESCUE        110 0.0784 0.14   1.78 0.0616 16.2 
     3     1 SELECT2       183 0.0702 0.203  2.90 0.133   7.51
     4     1 TENSION       125 0.0246 0.169  6.89 0.145   6.91
     5     1 TESLA         159 0.0890 0.146  1.64 0.0567 17.7 
     6     2 ESCAPE        189 0.295  0.543  1.84 0.248   4.03
     7     2 EXTEND         48 0.412  0.714  1.73 0.303   3.31
     8     2 MRCLEAN       317 0.196  0.330  1.68 0.134   7.45
     9     2 PISTE          42 0.4    0.515  1.29 0.115   8.68
    10     2 RESILIENT     134 0.207  0.351  1.70 0.144   6.94
    11     2 REVASCAT      132 0.282  0.437  1.55 0.155   6.44
    12     2 SWIFT         127 0.351  0.608  1.73 0.257   3.89
    13     2 THERAPY        60 0.304  0.38   1.25 0.0757 13.2 
    14     2 THRACE        287 0.421  0.53   1.26 0.109   9.16
    15     3 DAWN          112 0.131  0.477  3.63 0.345   2.90
    16     3 DEFUSE3       105 0.154  0.440  2.86 0.286   3.5 
    17     3 MRCLEANLATE   331 0.340  0.393  1.16 0.0528 18.9 
    18     3 POSITIVE       30 0.429  0.75   1.75 0.321   3.11
    19     4 ATTENTION     126 0.105  0.332  3.15 0.227   4.41
    20     4 BAOCHE        122 0.140  0.391  2.79 0.251   3.99
    21     4 BASICS        190 0.301  0.351  1.16 0.0493 20.3 
    22     4 BEST           83 0.277  0.333  1.20 0.0564 17.7 

The overall pooled data are shown in the following table.

    # A tibble: 1 × 6
      trials  size   f_c   f_t    rr    rd
       <int> <dbl> <dbl> <dbl> <dbl> <dbl>
    1     22  5513 0.214 0.365  1.70 0.150

The pooled data by category are shown in the following table.

    # A tibble: 4 × 7
      category trials  size    f_c   f_t    rr    rd
      <chr>     <int> <dbl>  <dbl> <dbl> <dbl> <dbl>
    1 large         5  1548 0.0809 0.207  2.56 0.126
    2 early         9  2057 0.296  0.464  1.57 0.168
    3 late          4   920 0.262  0.431  1.64 0.169
    4 basilar       4   988 0.206  0.349  1.69 0.143

## Treatment effect estimation

### Estimated chance of favorable outcome across existing trials

The estimated chance of functional independence for a patient enrolled
in the medical arm of a large core stroke trial was 8% (95% PI 5.59% -
12.5%) compared to 30% (95% PI 23.8% - 36.8%) for small core trials, 26%
(95% PI 17.6% - 36.2%) for late window trials, and 20% (95% PI 13.1 -
28.5%) for basilar trials.

The estimated chance of functional independence for a patient enrolled
in the treatment arm of a large core stroke trial was 18% (95% PI
12.1% - 25.5%) compared to 50% (95% PI 42.0% - 58.9%) for small core
trials, 45% (95% PI 33.4% - 57.7%) for late window trials, and 37% (95%
PI 26.5 - 48.6%) for basilar trials.

### Estimated effect of thrombectomy on chances of favorable outcome across existing trials

In relative terms, thrombectomy increased the chances of a favorable
outcome by 111% (aRR 2.11, 95% PI 1.8 - 2.52) in large core stroke
trials, compared to 67% in small core trials (aRR 1.67, 95% PI 1.49 -
1.9), 74% in late window trials (aRR 1.74, 95% PI 1.52 - 2.04), and 85%
in basilar occlusion trials (aRR 1.85, 95% PI 1.6 - 2.18).

In absolute terms, thrombectomy increased the chances of a favorable
outcome by 9% (aRD 9.31, 95% PI 6.09 - 13.8) in large core stroke
trials, compared to 20% in small core trials (aRD 20.2, 95% PI 15.6 -
25.0), 19% in late window trials (aRD 19.0, 95% PI 14.1 - 24.5), and 17%
in basilar occlusion trials (aRD 16.9, 95% PI 12.0 - 22.3).

## Heterogeneity estimation

The median estimate of the Bayesian I-squared statistic, defined as the
percent portion of variation in estimated treatment effect due to
between-trial heterogeneity and not sampling variation was 46.7% (95% PI
30.3% - 59.9%).

### Projected impact of thrombectomy in a new trial

After accounting for uncertainty in all model parameters, the projected
probability of a positive impact on patient-level outcomes in a new
randomized trial of thrombectomy for large core stroke is 93%, with a
45% probability of NNT between 100 and 10 and a 48% probability of NNT
10 or lower. The projected probability of a positive impact in a new
small core stroke trial is 97%, with a 14% probability of NNT between
100 and 10 and a 83% probability of NNT 10 or less. The projected
probability of a positive impact in a new late window trial is 96%, with
a 16% probability of a NNT between 100 and 10 and a 80% probability of
NNT 10 or less. The projected probability of a positive impact in a new
basilar stroke trial is 96%, with a 20% probability of NNT between 100
and 10 and a 75% probability of NNT 10 or less.

# Discussion
