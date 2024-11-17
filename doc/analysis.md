# Comparative effect of thrombectomy: a bayesian analysis


# Abstract

## Importance

22 randomized clinical trials of mechanical thrombectomy for ischemic
stroke have been performed, but the implications of the results for
patients treated outside these trials are unclear.

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

Data was extracted from 22 randomized trials. A varying-slopes
varying-intercepts multilevel logistic regression was fit to the
extracted data. Posterior predictive distributions for model parameters
were used to calculate the range of plausible absolute treatment effects
in a future trial, adjusted for stroke type.

## Main outcomes and measures

The main outcome was the expected absolute difference in the probability
of functional independence in the treatment versus control arm of a new
hypothetical trial of mechanical thrombectomy, adjusted for stroke type.

## Results

Conditional on data from 22 previous trials and the model used to
analyze the data, the expected difference in the probability of
functional independence between the treatment and control arms of a new
hypothetical trial of mechanical thrombectomy is greatest for small
strokes treated in an early time window (19.0%, 5.7 % - 33.2%), followed
by small strokes treated in a late time window (17.9%, 5.0 - 32.5%),
basilar strokes (15.9%, 4.2 - 30.7%), and large strokes treated in an
early time window (8.9%, 2.0 - 21.6%).

## Conclusions and relevance

The absolute treatment effect of thrombectomy in a future trial is
predicted to be positive with at least 95% confidence across all stroke
types, but the magnitude of the predicted effect is uncertain and varies
substantially according to the type of stroke being treated.

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
initial analysis plan was preregistered on the Open Science Framework.
The regression model was written in the probabilistic programming
language Stan and fit to data using R. Convergence and model diagnostics
were assessed according to expert recommendations, and this information
is fully reported in the appendix. Sensitivity checks for the priors and
the likelihood were performed. Point estimates are presented using the
median of the posterior predictive distribution. 95% posterior intervals
(PI), the Bayesian analogue to frequentist confidence intervals, are
presented using the 2.5% and 97.5% quantiles of the posterior predictive
distribution. The full statistical model as well as computer code to
reproduce all analyses and figures is available on-line.

# Results

## Search Results

The initial database and registry search yielded 224 studies. Following
title and abstract screening, 22 were retained, with the same amount
remaining after full-text review.

## Risk of Bias

We concluded that all included studies had low risk of bias.

## Study and Population Characteristics

The intention to treat population included 5513 participants across 22
randomized control trials. 2687 were assigned to medical management,
while 2826 were assigned to thrombectomy plus medical management. Each
trial was assigned to one of 4 categories according to the type of
stroke patients enrolled. Category 1 (“large”) was anterior circulation
strokes with a large core treated in an early time window. Category 2
(“small”) was anterior circulation strokes with small to medium sized
cores treated in an early time window. Category 3 (“late”) was anterior
circulation strokes with small to medium sized cores treated in an
extended time window. Category 4 (“basilar”) was strokes due to large
vessel occlusion of the vertebobasilar artery complex. Table 1 contains
further information on study design and population characteristics.

## Descriptive Results

Observed outcomes in the intention-to-treat cohors of each trial are
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
    1 large         5  1548 0.0809 0.207  2.56 0.126  7.92
    2 early         9  2057 0.296  0.464  1.57 0.168  5.95
    3 late          4   920 0.262  0.431  1.64 0.169  5.93
    4 basilar       4   988 0.206  0.349  1.69 0.143  7.00

## Treatment effect estimation

The expected probabilities of functional independence for a patient
enrolled in the control arm of a new stroke trial are, in descending
order, 30% (95% PI 16.7% - 47.9%) for small stroke, 26% (95% PI 13.2% -
44.9%) for late stroke, 20% (95% PI 10.0 - 36.0%) for basilar stroke,
and 8% (95% PI 3.9% - 17.5%) for large stroke (figure 2).

Thrombectomy is expected to increase the probability of a favorable
outcome in a new trial by 19% (95% PI 5.7% - 33.2%) for small stroke,
18% (95% PI 5.0% - 32.5%) for late srokes, 16% (95% PI 4.2 - 30.7%) for
basilar strokes, and 9% (95% PI 2.0% - 21.6%) for large strokes.

## Heterogeneity estimation

The Bayesian I-squared statistic, defined as the percent portion of
variation in the estimated treatment effect due to between-trial
heterogeneity and not sampling variation was 46.6% (95% PI 29.3% -
60.2%). In contrast to frequentist analyses, the I-squared statistic is
of less relevance in this Bayesian analysis, since the reported
treatment effects themselves are derived from the posterior predictive
distributions, which intrinsically incorporate the estimated
between-trial heterogeneity.

# Discussion

Experts recommend that treatment effects should be communicated to a
patient in a three stage process. First, the clinician should determine
what outcome the patient values most. Second, the clinician should
describe the best estimate of the patient’s chances of achieving that
outcome without the treatment. Third, the clinician should describe the
best estimate of how the treatment changes the patient’s chances of
achieving the outcome.

Although there are numerous meta-analyses of randomized trial data from
stroke thrombectomy, none have utilized this patient-centered, common
language approach to analyzing the data from these trials. In this
paper, we aimed to adapt the traditional statistical model underlying
most meta-analyses in order to analyze the outcomes from all 22 trials
of stroke thrombectomy from this patient-centered perspective.

We found that the expected probability of functional independence for a
hypothetical patient enrolled in the control arm of a new thrombectomy
trial — the number we would quote as the one best estimate of this
idealized patient’s chances of a “good outcome” without treatment —
varied considerably by stroke type, ranging from just 8% for a trial of
large stroke, 20% for basilar occlusion, 26% for late-window, to 30% for
small stroke in early window.

The expected improvement in the probability of functional independence
associated with assignment to the treatment arm of a new trial — the
number we would quote as the one best estimate of the expected
“treatment effect” of thrombectomy — also showed considerable variation
by stroke type, once again ranging from a relatively low 9% for large
stroke (number needed to treat of 11), to more than double that for
small (19%, number needed to treat 6) and late window (18%, number
needed 6), with basilar in the middle at 16% (number needed to treat 7).

Because we are working in a Bayesian framework, the interpretation of
the 95% intervals associated with each of these estimates is
straightforward — in a new trial of thrombectomy, the actual effect size
has a 95% probability of being within the stated interval. Since all of
the intervals exclude zero or negative numbers, we can say that the
expected effect of thrombectomy in a new trial is “statistically
significant,” in the sense of excluding no or negative effects with at
least 97.5% probability. In fact, for each stroke type, the predicted
effect of thrombectomy in a new trial is positive with 99% probability
regardless of stroke type (figure 3).

But statistical significance, even from the simplified Bayesian
perspective, is not important to patients and families, since what they
really care about is not necessarily whether a treatment works at all —
essentially, what statistical significance is supposed to tell us — but
rather in how well the treatment works — how it will change their
overall prognosis. This is where our Bayesian framework shines, because
it also allows us to reason rigorously but in clear terms about the
clinical significance of our treatment effect estimates.

To see how, compare the information content of figure 3, which focuses
on a binary partition of the distribution of predicted effects into
“positive” and “negative” effects, together with their associated
probabilities, with the content of figure 4, which instead partitions
the distributions of predicted effects into intervals corresponding to
clinically significant thresholds, and displays the probability that the
predicted effect in a new trial falls between each clinically
significant interval. We can see that the effect estimates, which from
the binary perspective of statistical significance appeared basically
identical, in fact are quite different.

For instance, a very permissive clinician might consider an absolute
effect greater than 1% — corresponding to a number needed to treat of
less than 100 — as clinically significant. From this perspective, the
probability of a clinically insignificant effect in a new trial is about
equal across all stroke types, 3% for large, compared to 2% for small
core, 2% with late window, and 2% with basilar occlusion.

On the other hand, a more hardline clinician might have a more severe
threshold for clinical significance, such as an absolute effect of
greater than 20%, corresponding to a number needed to treat of less than
5. In this scenario, as shown in figure 3, our results diverge
dramatically, with small strokes treated in the early or late windows
having comparatively high probability of clinical significance (45% and
41% respectively), in comparison to large strokes, in which the
probability of a clinical significance is just 7%.

We conclude that while thrombectomy is expected to have a positive
effect on the probability of functional independence in a new trial, the
size of the effect is uncertain and varies considerably by stroke type,
with thrombectomy for large core stroke expected to perform
substantially worse than other types in a new trial. Perhaps more
importantly, the absolute probability of functional independence with or
without treatment is still low, and, in the case of large stroke,
exceedingly low.

# Limitations

Although we focus on predicting the expected treatment effect in a new
trial of thrombectomy, it is well known that real world clinical
scenarios rarely mirror those seen in clinical trials, both from the
standpoint that real-world patients rarerly match patients treated in
trials, and from that the standpoint that real-world care, both before,
during, and after hospitalization, rarely matches what occurs in trials.
For patients that do not closely match the enrollment criteria for
clinical trials, or for clinicians treating patients in clinical
contexts substantially different from what was seen in clinical trials,
the estimates presented here should be used a starting point, describing
what an idealized patient in an idealized scenario can expect. This can
then serve as a useful jumping off point for a discussion of the
specific ways in which the patient or the clinical context diverge from
these ideals.

That being said, we have found in our own practice that some care
scenarios may closely mimic exact trial conditions. For example, as an
enrolling center for both DAWN and Select 2 trial, we sometimes treat
patients that would have met enrollment criteria for these trials. In
this case, we find that the treatment effect estimates reported above
may in fact overestimate our uncertainty for how these patient will do
at our hospital. In cases like these, it can make more sense to use our
models per-trial treatment effect estimates, which, instead of reporting
the estimated treatment effect in a hypothetical new trial, describe the
estimated treatment effect in a replication of each specific trial.

Although we focus on the patient-centered perspective, we leave
unadressed the possible risks associated with the treatment.

Finally, like all statistical models, our conclusions depend on the
assumptions underlying the model itself. As in the case of all Bayesian
models, this includes assumptions about prior distributions for each of
the models parameters. In the supplementary appendix, we show that the
key model estimates reported here are not sensitive to a range of prior
distributions, and we also use so-called prior predictive checks to
demonstrate the implications of the priors used in the analysis.

# Conclusions

In this paper, we aimed to show how an extension of the traditional
meta-analytic framework using techniques from Bayesian data analysis can
be used to derive rigorous yet easily interpretable conclusions about
what the current landscape of stroke thrombectomy trials imply for
real-world patient care scenarios. Under this analysis, thrombectomy is
expected to have a positive effect on the probability of functional
independence in a new trial, but the clinical impact of this effect
varies by stroke type, and the absolute probability of functional
independence is still low, especially for large core stroke.

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
substantial effects, especially for large core stroke.

## Meaning

Evidence from 22 randomized trials implies a positive predicted effect
with a clinically uncertain magnitude for individual patients treated
outside of these trials, regardless of stroke type.
