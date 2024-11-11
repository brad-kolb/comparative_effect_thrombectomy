# Comparative effect of thrombectomy


# Abstract

## Importance

22 randomized clinical trials of mechanical thrombectomy for ischemic
stroke have been performed, but the implications of the results for
patients treated outside these trials remain unclear.

## Objective

To use information from existing randomized trials to infer the range of
plausible patient-level outcomes in a hypothetical future trial of
thrombectomy for various types of stroke, and to present this
information in easy to understand terms that can be readily employed in
real-world clinical scenarios.

## Data sources

Pubmed was searched through May 2024.

## Study selection

All randomized trials of best medical management versus best medical
management plus modern mechanical thrombectomy were included.

## Data extraction and synthesis

Data was extracted from 22 randomized trials (5 examining outcomes for
large core stroke patients, 9 for small core stroke, 4 for late window
stroke, and 4 for basilar stroke). A varying-slopes varying-intercepts
multilevel logistic regression was fit to the extracted data. Posterior
predictive distributions for model parameters were used to calculate the
range of plausible absolute treatment effects in a future trial.

## Main outcomes and measures

The main estimand was the expected absolute difference in the
probability of functional independence in the treatment versus control
arm of a new hypothetical trial of mechanical thrombectomy, adjusted for
stroke type. Simulation-based methods were used to calculate number
needed to treat (NNT) thresholds in this hypothetical trial.

## Results

Conditional on data from 22 previous trials and the model used to
analyze the data, the expected difference in the probability of
functional independence between the treatment and control arms of a new
hypothetical trial of mechanical thrombectomy is greatest for small
strokes treated early (19.0%, 5.7 % - 33.2%), followed by small strokes
treated late (17.9%, 5.0 - 32.5%), basilar strokes (15.9%, 4.2 - 30.7%),
and large strokes (8.9%, 2.0 - 21.6%).

## Conclusions and relevance

The absolute treatment effect of thrombectomy in a future trial is
predicted to be positive with at least 95% confidence across all stroke
types, but the magnitude of this predicted effect is uncertain and
varies substantially according to the type of stroke being treated.

# Introduction

There are numerous meta-analyses of stroke thrombectomy, but their
results are difficult to interpret for many clinicians, which may
preclude effective communication of risk and uncertainty with patients
and family. Here, we employ a Bayesian framework to infer the range of
plausible outcomes in a hypothetical future randomized control trial of
modern stroke thrombectomy, given the observed outcomes in the 22 trials
to date. We show how this framework can be used to capture the strength
of evidence supporting this intervention, as well as the residual
uncertainty regarding individual patient outcomes.

# Methods

This meta-analysis was conducted according to the preferred reporting
items for systematic reviews and meta-analysis (PRISMA) guidelines. The
initial analysis plan was preregistered on the open science framework.
The regression model was written in the probabilistic programming
language Stan and fit in R using cmdstanr. Posterior draws were
processed using Posterior. Figures were produced in base R. Convergence
and model diagnostics were assessed according to expert recommendations,
and this information is fully reported in the appendix. Point estimates
are presented using the median of the posterior predictive distribution.
95% posterior intervals (PI), the Bayesian analogue to frequentist
confidence intervals, are presented using the 2.5% and 97.5% quantiles
of the posterior distribution. The full statistical model as well as
computer code to reproduce all analyses and figures is available at
github.

# Results

## Search Results

The initial database and registry search yielded XXX studies. Following
title and abstract screening, XXX were retained, with 22 remaining after
full-text review.

## Risk of Bias

We concluded that all included studies had low risk of bias.

## Study and Population Characteristics

The intention to treat population included 5513 participants across 22
randomized control trials. 2687 were assigned to medical management,
while 2826 were assigned to thrombectomy plus medical management. Each
trial was assigned to one of K = 4 categories according to the type of
stroke patients enrolled. Category 1 (“large”) was anterior circulation
strokes with a large core treated in an early time window. Category 2
(“small”) was anterior circulation strokes with small to medium sized
cores treated in an early time window. Category 3 (“late”) was anterior
circulation strokes with small to medium sized cores treated in an
extended time window. Category 4 (“basilar”) was strokes due to large
vessel occlusion of the vertebobasilar artery complex. Table 1 contains
further information on study design and population characteristics.

## Descriptive Results

The observed fraction of patients achieving functional independence at
90 days in the control and treatment groups of each trial are shown
below. The observed relative risk ratio (rr, frequency in treatment arm
divided by frequency in control group), absolute risk difference (rd,
frequency in treatment arm minus frequency in control group), and number
needed to treat (NNT, 1/rd) are also reported.

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

The expected probability of functional independence for a patient
enrolled in the control arm of a new large core stroke trial is 8% (95%
PI 3.9% - 17.5%) compared to 30% (95% PI 16.7% - 47.9%) for a new small
core stroke trial, 26% (95% PI 13.2% - 44.9%) for a new late window
trial, and 20% (95% PI 10.0 - 36.0%) for a new basilar thrombectomy
trial.

In absolute terms, thrombectomy is expected to increase the probability
of a favorable outcome in a new trial by 9% (95% PI 2.0% - 21.6%) for
large core, compared to 19% (95% PI 5.7% - 33.2%) for small, 18% (95% PI
5.0% - 32.5%) for late window trials, and 16% (95% PI 4.2 - 30.7%) for
basilar trials.

## Heterogeneity estimation

In this meta-analysis, the median estimate of the Bayesian I-squared
statistic, defined as the percent portion of variation in the estimated
treatment effect due to between-trial heterogeneity and not sampling
variation was 46.6% (95% PI 29.3% - 60.2%). In contrast to frequentist
analyses, the I-squared statistic is of less relevance in this Bayesian
analysis, since the reported treatment effects themselves are derived
from the posterior predictive distributions, which average over the
estimated between-trial heterogeneity.

# Discussion

## Interpretation of our results

Experts recommend that treatment effects should be communicated to
patients in terms of the clinician’s best estimate of how the treatment
is expected to change the probability of the patient experiencing the
outcome that most matters to them.

In the case of ischemic stroke, this outcome is typically functional
independence. Thus, when engaging patients and families in a discussion
over the risks and benefits of mechanical thrombectomy, the key
questions to address are, first, what is the best estimate of the
patients chance of functional independence without treatment, and two,
what is the best estimate of how these chances change, in absolute
terms, with treatment. This is the minimum amount of information a
patient needs to make an informed decision.

Although there are numerous meta-analyses of randomized trial data from
stroke thrombectomy, none have utilized this patient-centered, common
language approach to data analysis. In this paper, we aimed to adapt the
traditional statistical model underlying most meta-analyses in order to
analyze data from all 22 trials of stroke thrombectomy from this
patient-centered perspective.

We found that the expected probability of functional independence for a
hypothetical patient enrolled in the control arm of a new thrombectomy
trial — the number we would quote as the one best estimate of this
imaginary patient’s chances without treatment — varied considerably by
stroke type, ranging from just 8% for a trial of large stroke, 20% for
basilar occlusion, 26% for late-window, to 30% for small stroke in early
window.

The expected change in the probability of functional independence
associated with assignment to the treatment arm of a new trial — the
number we would quote as the one best estimate of how thrombectomy would
impact a hypothetical patient’s probability of achieving functional
independence — also showed considerable variation by stroke type, once
again ranging from a relatively low 9% for large stroke, to more than
double that for small (19%) and late window (18%), with basilar in the
middle at 16%.

The 95% intervals around each of these estimates represents the range of
changes in probability due to thrombectomy that are consistent with the
data and the model used to analyze it. Because we are working in a
Bayesian framework, the interpretation of these intervals is
straightforward — in a new trial of thrombectomy, the change in
probability with treatment has a 95% probability of being within the
stated interval. Since each of these intervals excludes zero and
negative values, we can conclude that these estimates are “statistically
significant.” Nonetheless, the width of the intervals shows that the
data would be consistent with a wide range of possible observed effects
in a new trial.

To see this more clearly, consider the following calculations.

By leveraging the Bayesian framework and converting the posterior
predictive distributions for the absolute change in probability to the
number needed to treat scale (1 over the absolute change in
probability), we find that the cumulative probability that the expected
number needed to treat in a new trial is less than 100 is nearly
identical across stroke types, 1.7% for large, compared to 98% for small
core, 98% with late window, and 98% with basilar occlusion, whereas the
cumulative probability that the expected number needed to treat in a new
trial is less than 10 diverges considerably by stroke type, with 42% for
large stroke, compared to 86% for small core, 84% with late window, and
78% with basilar occlusion.

We conclude that while thrombectomy is expected to have a substantial
positive effect on the probability of functional independence in a new
trial, this impact varies considerably by stroke type, and the absolute
probability of functional independence with treatment is still low,
especially for large core stroke.

# Limitations

Focus on absolute effects instead of relative effects. Seemingly high
uncertainty (but our model is a much more severe test). Simplified
model. Lack of patient-level data. No systematic review.

# Conclusions

In this paper, we aimed to show how an extension of the traditional
meta-analytic framework using techniques from Bayesian data analysis can
be used to derive rigorous yet easily interpretable conclusions about
what the current landscape of stroke thrombectomy trials imply for
real-world patient care scenarios. Under this analysis, thrombectomy is
expected to have a substantial positive effect on the probability of
functional independence in a new trial, but this impact varies by stroke
type, and the absolute probability of functional independence is still
low, especially for large core stroke.

# Key Points

## Question

What is the effect of thrombectomy on functional independence when
considered not from the perspective of the average effect across
existing trials (the typical measure in most meta-analyses) but instead
from the perspective of the expected effect in a hypothetical new trial
(a measure more useful for communicating risk and uncertainty to
patients and fellow clinicians).

## Findings

In a new hypothetical trial, thrombectomy is expected to improve the
chances of functional independence by 9% for large strokes, 16% for
basilar strokes, 18% for small strokes treated in the extended time
window, and 19% for small strokes treated in an early time window. These
effects are all statistically significant, in the sense that their 95%
prediction intervals exclude zero, but clinically uncertain, in the
sense that the intervals contain values ranging from negligble to
substantial.

## Meaning

Evidence from 22 randomized trials implies an uncertain positive
predicted effect for individual patients treated outside of these
trials. While patients can expect to benefit, they are still unlikely to
achieve functional independence, especially after a large stroke.
