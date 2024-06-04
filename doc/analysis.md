# Comparative effect of thrombectomy


## Observed Data

There were a total of N = 5,513 patients enrolled in J = 22 trials.
2,687 were randomized to best medical management. 2,826 were randomized
to best medical management plus mechanical thrombectomy. Each trial was
categorized into one of K = 4 categories according to the type of stroke
patients enrolled. Category 1 was large anterior circulation strokes.
Category 2 was small to medium sized anterior circulation strokes
treated in an early time window. Category 3 was small to medium sized
anterior circulation strokes treated in a late time window. Category 4
was strokes involving the basilar artery. The primary endpoint was
functional independence at 90 days (modified Rankin score of 0 to 2).

Results from the large stroke trials are shown here, with $y$
representing the observed treatment effect of thrombectomy (the odds
ratio on the log scale) and $\text{se}$ representing the standard error
for $y$.

    # A tibble: 5 × 9
          J name        K   n_c   r_c   n_t   r_t     y    se
      <dbl> <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    1     1 ANGEL       1   225    26   230    69 1.19  0.253
    2     2 RESCUE      1   102     8   100    14 0.649 0.468
    3     3 SELECT2     1   171    12   177    36 1.22  0.353
    4     4 TENSION     1   122     3   124    21 2.09  0.632
    5     5 TESLA       1   146    13   151    22 0.557 0.371

Results from the early stroke trials are shown here.

    # A tibble: 9 × 9
          J name          K   n_c   r_c   n_t   r_t     y    se
      <dbl> <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    1     6 ESCAPE        2   146    43   164    89 1.04  0.240
    2     7 EXTEND        2    34    14    35    25 1.27  0.511
    3     8 MRCLEAN       2   265    52   233    77 0.704 0.208
    4     9 PISTE         2    30    12    33    17 0.466 0.510
    5    10 RESILIENT     2   111    23   111    39 0.729 0.307
    6    11 REVASCAT      2   103    29   103    45 0.683 0.296
    7    12 SWIFT         2    94    33    97    59 1.05  0.300
    8    13 THERAPY       2    46    14    50    19 0.337 0.433
    9    14 THRACE        2   202    85   200   106 0.440 0.201

Results of the late stroke trials are shown here.

    # A tibble: 4 × 9
          J name            K   n_c   r_c   n_t   r_t     y    se
      <dbl> <chr>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    1    15 DAWN            3    99    13   107    51 1.80  0.355
    2    16 DEFUSE3         3    91    14    91    40 1.46  0.359
    3    17 MRCLEANLATE     3   247    84   252    99 0.228 0.186
    4    18 POSITIVE        3    21     9    12     9 1.39  0.799

Basilar stroke trial results are shown here.

    # A tibble: 4 × 9
          J name          K   n_c   r_c   n_t   r_t     y    se
      <dbl> <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    1    19 ATTENTION     4   114    12   226    75 1.44  0.336
    2    20 BAOCHE        4   107    15   110    43 1.37  0.340
    3    21 BASICS        4   146    44   154    54 0.225 0.247
    4    22 BEST          4    65    18    66    22 0.267 0.381

The pooled data by category are shown in the following table.

    # A tibble: 4 × 5
      category trials `sample size`     y     se
      <chr>     <int>         <dbl> <dbl>  <dbl>
    1 large         5          1548 1.09  0.159 
    2 early         9          2057 0.723 0.0926
    3 late          4           920 0.757 0.142 
    4 basilar       4           988 0.725 0.149 

The overall pooled data is shown in the following table.

    # A tibble: 1 × 4
      trials `sample size`     y     se
       <int>         <dbl> <dbl>  <dbl>
    1     22          5513 0.744 0.0611

## Estimated average treatment effect of thrombectomy across trials

### Early

The model estimate for the average treatment effect of thrombectomy
across early stroke trials is summarized in the following table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1  0.723 0.114 0.482 0.959        1

These values correspond to an estimated 106% average improvement in the
odds of functional independence at 90 days with thrombectomy (95% CI
61.9% to 161%, P(+) = 100%).

### Large

The model estimate for the average treatment effect of thrombectomy
across large stroke trials is summarized in the following table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1   1.00 0.229 0.437  1.50    0.998

These values correspond to an estimated 173% average improvement in the
odds of functional independence at 90 days with thrombectomy (95% CI
54.8% to 347%, P(+) = 99.8%).

### Late

The model estimate for the average treatment effect of thrombectomy
across late stroke trials is summarized in the following table.

    # A tibble: 1 × 5
      median   mad    low  high prob_pos
       <dbl> <dbl>  <dbl> <dbl>    <dbl>
    1  0.958 0.410 0.0760  1.74    0.980

These values correspond to an estimated 161% average improvement in the
odds of functional independence at 90 days with thrombectomy (95% CI
7.9% to 467%, P(+) = 98%).

### Basilar

The model estimate for the average relative treatment effect of
thrombectomy across basilar stroke trials is summarized in the following
table.

    # A tibble: 1 × 5
      median   mad    low  high prob_pos
       <dbl> <dbl>  <dbl> <dbl>    <dbl>
    1  0.704 0.353 -0.163  1.43    0.951

These values correspond to an estimated 102% average improvement in the
odds of functional independence at 90 days with thrombectomy (95% CI
-15.1% to 319%, P(+) = 95.1%).

## Anticipated relative treatment effect of thrombectomy in a new trial

The model estimate for the variation in the trial-specific treatment
effect of thrombectomy for each stroke type is summarized in the
following table.

    # A tibble: 4 × 5
      data    median   mad     low  high
      <chr>    <dbl> <dbl>   <dbl> <dbl>
    1 large    0.316 0.274 0.0150  1.20 
    2 early    0.146 0.125 0.00769 0.516
    3 late     0.765 0.312 0.315   1.68 
    4 basilar  0.661 0.321 0.194   1.64 

When taken together with the estimates for the average relative
treatment effects, these estimates of trial-specific treatment effect
heterogeneity can be used to forecast the expected treatment effect of
thrombectomy in a new trial, which we call the anticipated treatment
effect.

    # A tibble: 4 × 6
      data    median   mad    low  high prob_pos
      <chr>    <dbl> <dbl>  <dbl> <dbl>    <dbl>
    1 large    1.02  0.360 -0.284  2.10    0.959
    2 early    0.723 0.181  0.185  1.24    0.990
    3 late     0.969 0.837 -1.19   3.01    0.854
    4 basilar  0.721 0.740 -1.34   2.51    0.820

### Early

The anticipated treatment effect of thrombectomy in a new early stroke
trial has an odds ratio of 2.06 (95% CI 1.2 to 3.47, P(+) = 99%).

### Large

The anticipated treatment effect of thrombectomy in a new large stroke
trial has an odds ratio of 2.76 (95% CI 0.752 to 8.16, P(+) = 95.9%).

### Late

The anticipated treatment effect of thrombectomy in a new late stroke
trial has an odds ratio of 2.63 (95% CI 0.304 to 20.3, P(+) = 85.4%).

### Basilar

The anticipated treatment effect of thrombectomy in a new basilar stroke
trial has an odds ratio of 2.06 (95% CI 0.261 to 12.2, P(+) = 82%).
