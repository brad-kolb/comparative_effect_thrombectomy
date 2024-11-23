# Comparative effect of thrombectomy: a bayesian analysis


## Abstract

### Importance

22 randomized clinical trials of mechanical thrombectomy for ischemic
stroke have been performed, but the implications of the results for
patients treated outside these trials are unclear.

### Objective

To use information from existing randomized trials to infer the range of
plausible patient-level outcomes in a hypothetical future trial of
thrombectomy for various types of stroke, and to present this
information in easy to understand terms that can be readily employed in
real-world clinical scenarios.

### Data sources

Pubmed was searched through May 2024.

### Study selection

All randomized trials of best medical management versus best medical
management plus modern mechanical thrombectomy were included.

### Data extraction and synthesis

Data was extracted from 22 randomized trials. A varying-slopes
varying-intercepts multilevel logistic regression was fit to the
extracted data. Posterior predictive distributions for model parameters
were used to calculate the range of plausible absolute treatment effects
in a future trial, adjusted for stroke type.

### Main outcomes and measures

The main outcome was the expected absolute difference in the probability
of functional independence in the treatment versus control arm of a new
hypothetical trial of mechanical thrombectomy, adjusted for stroke type.

### Results

Conditional on data from 22 previous trials and the model used to
analyze the data, thrombectomy is predicted to increase the probability
of functional independence by 19.0% (5.7% - 33.2%) in a new trial of
small strokes treated in an early time window, compared to 17.9% (5.0 -
32.5%) in a new trial of small strokes treated in a late time window,
15.9% (4.2 - 30.7%), in a new trial of basilar strokes, and 8.9% (2.0 -
21.6%) in a new trial of large strokes treated in an early time window.

### Conclusions and relevance

The absolute treatment effect of thrombectomy in a future trial is
predicted to be positive with at least 95% confidence across all stroke
types, but the magnitude of the predicted effect is uncertain and varies
substantially according to the type of stroke being treated.

## Introduction

The effectiveness of mechanical thrombectomy for stroke has been
evaluated in multiple clinical trials and meta-analyses. However,
traditional meta-analyses, focused on estimating average treatment
effects across past trials, can be difficult to translate into guidance
for individual patient care in new situations. Clinicians and patients
need practical answers to questions like: “what range of outcomes might
I expect with this treatment?” and “how certain can I be that this
treatment will make a meaningful difference in my chances for a good
outcome?”

In this paper, we address these questions directly using a Bayesian
meta-analysis of all existing thrombectomy trials. Rather than
estimating the average effect in past trials, we use the information
embedded in the outcomes of these trials to predict the range of
plausible outcomes for future patients. By focusing on prediction rather
than estimation and absolute rather than relative effects, we move
beyond statistical significance to a rigorous quantification of clinical
importance, providing evidence-based probability estimates that
clinicians can use when discussing treatment decisions with patients and
families.

# Methods

This meta-analysis was conducted according to the preferred reporting
items for systematic reviews and meta-analysis (PRISMA) guidelines. The
initial analysis plan was preregistered on the Open Science Framework.
We categorized all thrombectomy trials into four clinically distinct
categories: early-window small core strokes (EW-SC), late-window small
core strokes (LW-SC), early-window large core strokes (EW-LC), and
basilar artery strokes (BS). This classification reflects key
differences in patient populations that could influence treatment
effectiveness. The primary outcome was functional independence at 6
months followup in the intention-to-treat population. To analyze
outcomes across these stroke types, we used a multilevel logistic
regression model with varying slopes and varying intercepts. This model
accounts for both within-trial and between-trial variation in baseline
risk and treatment effect, adjusting outcomes according to stroke
category. The model was implemented in Stan, a probabilistic programming
language designed for rigorous uncertainty quantification. Convergence
and model diagnostics were assessed according to expert recommendations,
and this information is fully reported in the appendix. Sensitivity
checks for the priors and the likelihood were performed. Treatment
effects are reported as the median of posterior predictive distribution
for the corresponding quantity in the model. Uncertainty for this
estimate is expressed with the 95% posterior interval - a range that can
be interpreted as including the “true” parameter value with 95%
probability, conditional on the model and its underlying assumptions.
The full statistical model as well as computer code to reproduce all
analyses and figures is available on-line.

## Results

### Search Results

The initial database and registry search yielded 224 studies. Following
title and abstract screening, 22 were retained, with the same amount
remaining after full-text review.

### Risk of Bias

We concluded that all included studies had low risk of bias.

### Study and Population Characteristics

The intention to treat population included 5513 participants across 22
randomized control trials. 2687 were assigned to medical management,
while 2826 were assigned to thrombectomy plus medical management.

### Descriptive Results

Observed outcomes in the intention-to-treat cohorts of each trial are
reported below.

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
    1 EW-LC         5  1548 0.0809 0.207  2.56 0.126  7.92
    2 EW-SC         9  2057 0.296  0.464  1.57 0.168  5.95
    3 LW-SC         4   920 0.262  0.431  1.64 0.169  5.93
    4 BS            4   988 0.206  0.349  1.69 0.143  7.00

### Treatment effect estimation

Thrombectomy is expected to increase the probability of a favorable
outcome in a new trial by 19% (95% PI 5.7% - 33.2%) for small stroke
treated in an early time window, 18% (95% PI 5.0% - 32.5%) for small
strokes treated in an late time window, 16% (95% PI 4.2 - 30.7%) for
basilar strokes, and 9% (95% PI 2.0% - 21.6%) for large strokes treated
in an early time window (figure 1).

### Clinical importance

What counts as a clinically important effect size will vary by
clinician. We consider three reasonable treatment effect thresholds, and
their associated predictive probabilities (figure 2).

#### Greater than 1% absolute improvement in predicted probability of functional independence

The predicted probability of an effect size greater than 1% in a new
trial is about equal across all stroke types, 97% for large strokes
treated in an early time window, compared to 98% for small strokes
treated in an early time window, 98% for small strokes treated in a late
time window, and 98% for basilar strokes. A 1% effect size corresponds
to a number needed to treat of 100.

#### Greater than 10% absolute improvement in predicted probability of functional independence

The predicted probability of an effect size greater than 10% in a new
trial is still very likely for small strokes treated in an early or late
time window and for basilar strokes (86%, 84%, and 78%, respectively),
but a little less than a coin flip for large strokes treated in an early
time window (42%). A 10% effect size corresponds to a number needed to
treat of 10.

#### Greater than 20% absolute improvement in predicted probability of functional independence

The predicted probability of an effect size greater than 20% in a new
trial is a little less than a coin flip for small stroke treated in an
early or late time window (45%, 41%, respectively), and less likely but
still within the realm of possibility for basilar stroke (32%). However,
the probability for large strokes treated in an early time window is
highly unlikely (7%). A 20% effect size corresponds to a number needed
to treat of 5.

### Baseline risk

Baseline risk – the predicted probability of achieving the outcome
without treatment – is a key metric that further clarifies the clinical
significance of our effect size estimates, but is left out of most
meta-analyses. The baseline risk for a patient enrolled in the control
arm of a new stroke trial varies widely. In descending order, the
probabilities are 30% (95% PI 16.7% - 47.9%) for small strokes treated
in an early time window, 26% (95% PI 13.2% - 44.9%) for small strokes
treated in a late time window, 20% (95% PI 10.0 - 36.0%) for basilar
strokes, and 8% (95% PI 3.9% - 17.5%) for large strokes treated in an
early time window (figure 3).

### Heterogeneity estimation

Estimated treatment effect heterogeneity is an important but often
overlooked component of meta-analysis. The Bayesian I-squared statistic,
defined as the percent portion of variation in the estimated treatment
effect due to between-trial heterogeneity and not sampling variation was
46.6% (95% PI 29.3% - 60.2%). In contrast to frequentist analyses, the
I-squared statistic is of less relevance in this Bayesian analysis,
since the reported treatment effects themselves are derived from the
posterior predictive distributions, which intrinsically incorporate the
estimated between-trial heterogeneity. In this sense, and unlike simple
average treatment effect estimates from standard meta-analyses, the main
results of our model already incorporate the uncertainty deriving from
between-trial heterogeneity.

## Discussion

Experts recommend that treatment decisions should be communicated to
patients in three steps: establish what outcome matters to the patient,
explain their chances without treatment, and describe how treatment
changes those chances in absolute terms. Traditional meta-analyses,
while statistically rigorous, often fail to provide information in this
patient-centered format.

### Importance over signfificance

Our analysis addresses this gap by predicting outcomes for future trials
rather than summarizing past ones. By switching the inferential focus to
prediction, we are able to uncover important clinical insights
heretofore not noted. Despite a statistically significant positive
predicted effect in future trials regardless of stroke type, the
probability that the predicted effect is clinically important varies
substantially (figure 4). This distinction matters for patient care:
knowing that thrombectomy ‘works’ (statistical significance) tells us
little about how well it works (clinical importance).

For example, our analysis finds that in a new trial of small strokes
treated in an early time window, there’s about a coin flips chance of
achieving a remarkably substantial clinical benefit (\>20% absolute
improvement, or a number needed to treat of 5 or fewer), while the
chances of achieving a smaller but still quite large benefit (\>10%
absolute improvement, number needed to treat of 10) is about 90%. In
contrast, for large strokes, while any positive effect remains highly
likely, the chance of a “clinically important effect”, in the sense
defined above, are considerably lower.

These probability statements provide a more nuanced framework for
discussing treatment decisions than simply saying the treatment is
“proven effective” - they help clinicians communicate both the promise
and limitations of thrombectomy across different stroke types. For
example, when counseling a patient with a large stroke, rather than just
noting that thrombectomy is “evidence-based”, a clinician can explain
that while some improvement is very likely, the chance of dramatic
benefit is small. This more complete picture helps set appropriate
expectations while still supporting the treatment’s role.

### Absolute over relative effects

In addition to emphasizing clinical importance over statistical
significance, we also stress absolute effect sizes over relative effect
sizes, which is reflective of a broader commitment to transparent risk
communication in our framework. While relative measures can make
treatments seem more dramatic, especially when baseline risks are low,
absolute probabilities give patients and families a clearer picture of
likely outcomes both with and without treatment. This focus on absolute
effects is equally important for clinicians, who might otherwise develop
inflated expectations based on impressive-sounding relative effects from
trials and meta-analyses. When most patients still have poor outcomes
despite treatment - as is often the case with stroke, and especially so
for basilar and large core stroke - clinicians might question the trial
results or their own practice. Absolute probabilities help avoid this
disconnect by keeping both success and failure in proper perspective:
even a genuinely effective treatment can leave most patients with poor
outcomes when baseline prognosis is poor.

## Limitations

One important potential objection to our approach has to do with our
emphasis on prediction. A sophisticated reader might question whether
trial-based predictions can guide real-world decisions, since both
patients and hospitals outside of trials differ in numerous dimensions
from patients and hospitals in trials. We agree, and this observation
uncovers the true utility of our approach, which is to use prediction
not to forecast specific outcomes, but to understand uncertainty. By
focusing on hypothetical future trials, we create a rigorous baseline
for discussing how individual patient characteristics might alter
expectations. The predicted probabilities aren’t precise forecasts, but
rather carefully quantified statements about treatment effects under
ideal conditions. No actual patients or real hospitals will match these
ideal conditions, but they nonetheless provide an excellent baseline.

Our analyis has three additional important limitations. First, like all
Bayesian analyses, our results depend on prior assumptions about model
parameters. We addressed this by using clinically informed priors -
verified through prior predictive simulation - and checking sensitivity
to alternative specifications. These checks, detailed in the
supplementary appendix, show our key findings are robust to alternative
prior choices. Second, we focused solely on functional independence
rather than other outcomes. While a fuller picture of thrombectomy’s
effects would consider multiple outcomes, functional independence is
often most relevant for patient decision-making. Third, we simplified
the modified Rankin Scale’s six-point gradation of disability into a
binary outcome: functionally independent or not. While a more complex
model could capture finer distinctions, this simplification makes our
results more interpretable for clinical discussions. This reflects our
broader approach: managing complexity to produce clear, actionable
insights for patient care.

## Conclusions

In this paper, we aimed to show how an extension of the traditional
meta-analytic framework using techniques from Bayesian data analysis can
be used to derive rigorous yet easily interpretable conclusions about
what the current landscape of stroke thrombectomy trials imply for
real-world patient care scenarios. Thrombectomy is expected to have a
positive effect on the probability of functional independence in a new
trial, but the clinical importance of this effect varies by stroke type,
and the absolute probability of functional independence is still low –
at best about a coin flip, and in the case of large strokes treated in
an early time window, much worse than a coin flip. This information
helps calibrate both patient and clinician expectations while supporting
thrombectomy’s role across stroke types.
