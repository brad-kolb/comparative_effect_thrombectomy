# Comparative effect of thrombectomy


# Abstract

## Importance

The influence of stroke type and baseline prognosis on the chance
functional independence following mechanical thrombectomy is unclear.

## Objective

To use information from all existing randomized trials to estimate the
relative and absolute treatment effect of thrombectomy on the chances of
favorable outcome at 90 days for clinically relevant types of stroke.

## Data sources

Pubmed and EMBASE was searched through May 2024.

## Study selection

All randomized trials of best medical management versus best medical
management plus modern mechanical thrombectomy were included.

## Data extraction and synthesis

Data extraction by the first author was independently confirmed by the
second. A varying-slopes varying-intercepts Bayesian multilevel logistic
regression was fit to the extracted data.

## Main outcomes and measures

The main estimands were the relative risk ratio (chance of functional
independence in treatment group / chance of functional independence in
control group) and the absolute risk difference (chance of functional
independence in treatment group - chance of functional independence in
control group), each adjusted for stroke types. Functional independence
was defined as a score of 0 to 2 on the modified Rankin scale at 90
days. Results were presented as posterior median and 95% posterior
intervals (PI).

## Results

A total of 22 studies were included, with 5 examining outcomes for large
core stroke patients, 9 for small core stroke, 4 for late window stroke,
and 4 for basilar stroke. The adjusted risk ratio (aRR) was highest for
large core stroke (aRR 2.11, 95% PI 1.8-2.52), followed in order by
basilar (aRR 1.85, 95% PI 1.6-2.18), late (aRR 1.74, 95% PI 1.52-2.04),
and small (aRR 1.67, 95% PI 1.49-1.9). The adjusted risk difference
(aRD) showed a reverse pattern, with small core stroke the highest (aRD
20.2%, 95% PI 15.6% -25.0%), followed by late (aRR 19.0%, 95% PI 14.1%
-24.5%), basilar (aRR 16.9%, 95% PI 12.0%-22.3%), and large (aRD 9.31%,
95% PI 6.09%-13.8%).

## Conclusions and relevance

The results of this analysis suggest that considering the relative
treatment effect alone can be misleading when assessing the efficacy of
modern mechanical thrombectomy for different types of ischemic stroke.
By also considering the absolute treatment effect, more useful
assessments can be made.

# Introduction

Clinicians should address four fundamental questions when engaging in an
informed consent discussion with patients or family members:

1\. What are the chances of experiencing the desired outcome without
treatment?

2\. What is the benefit of the treatment being offered to improve those
chances?

3\. What are the chances of experiencing the desired outcome with
treatment?

4\. What are the chances of harm due to the treatment, and what are the
burdens of the treatment?

While randomized control trials contain information useful for
estimating answers to all 4 of these questions, standard meta-analytic
models applied to RCTs by most researchers generally only address 2.
This is a problem, since only focusing on the relative treatment effect
of an intervention can obscure the actual impact of the treatment on
individual patients. Here, we extend the standard model so that 1 and 3
can also be addressed, and show how this reveals new insights useful for
clinical decision making.

# Methods

This systematic review was conducted according to the preferred
reporting items for systematic reviews and meta-analysis (PRISMA)
guidelines. The initial analysis plan was preregistered on the open
science framework. The regression model was written in the probabilistic
programming language Stan and fit in R using cmdstanr. Posterior draws
were processed using Posterior. Figures were produced in base R.
Convergence and model diagnostics were assessed according to expert
recommendations, and this information is fully reported in the appendix.
Point estimates are presented using the median of the posterior
distribution. 95% posterior intervals (PI), the Bayesian analogue to
frequentist confidence intervals, are presented using the 2.5% and 97.5%
quantiles of the posterior distribution. The full statistical model as
well as computer code to reproduce all analyses and figures is available
at github.

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

The observed fraction of patients achieving functional independence at
90 days in the control and treatment groups of each trial are shown
below. The observed relative risk ratio (rr) and absolute risk
difference (rd) are also shown. FInally, the observed number needed to
treat, defined as 1/rr, is shown.

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

    # A tibble: 1 × 7
      trials  size   f_c   f_t    rr    rd   nnt
       <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    1     22  5513 0.214 0.365  1.70 0.150  6.65

The pooled data by category are shown in the following table.

    # A tibble: 4 × 8
      category trials  size    f_c   f_t    rr    rd   nnt
      <chr>     <int> <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>
    1 large         5  1548 0.0809 0.207  2.56 0.126  7.92
    2 early         9  2057 0.296  0.464  1.57 0.168  5.95
    3 late          4   920 0.262  0.431  1.64 0.169  5.93
    4 basilar       4   988 0.206  0.349  1.69 0.143  7.00

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

Numerous meta-analyses of stroke thrombectomy have been published. All
have presented results in terms of the relative or absolute effect of
treatment on outcomes of interest, without consideration of the baseline
rate of the outcome without treatment, and how this rate varies
according to the type of stroke being treated. Here, we show how
incorporating this information into a meta-analysis of randomized trial
data reveals new insights useful for clinical decision making.
