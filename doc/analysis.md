Comparative effect of thrombectomy
================

## Observed Data

There were a total of 5,513 patients enrolled in J = 22 trials. 2,687
were randomized to best medical management. 2,826 were randomized to
best medical management plus mechanical thrombectomy. Each trial was
categorized into one of K = 4 categories according to the type of stroke
patients enrolled. Category K = 1 is large anterior circulation strokes.
Category 2 is small to medium sized anterior circulation strokes treated
in an early time window. Category 3 is small to medium sized anterior
circulation strokes treated in a late time window. Category 4 is strokes
involving the vertebro-basilar circulation. The primary endpoint was
functional independence at 90 days (modified Rankin score of 0 to 2).

Results from the large stroke trials are shown here.

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

## Estimated average relative treatment effect of thrombectomy across stroke types

### Early

The model estimate for the average relative treatment effect of
thrombectomy for early stroke is summarized in the following table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1  0.728 0.115 0.487 0.967        1

When translated from the log odds scale, these values correspond to an
estimated 107% average improvement in the odds of functional
independence at 90 days with thrombectomy (95% CI 62.8% to 163%). The
probability of a positive average relative treatment effect of
thrombectomy for this patient population is estimated by the model to be
100%.

### Large

The model estimate for the average relative treatment effect of
thrombectomy for large stroke is summarized in the following table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1   1.01 0.234 0.397  1.52    0.992

When translated from the log odds scale, these values correspond to an
estimated 174% average improvement in the odds of functional
independence at 90 days with thrombectomy (95% CI 48.7% to 360%). The
probability of a positive average relative treatment effect of
thrombectomy for this patient population is estimated by the model to be
99.2%.

### Late

The model estimate for the average relative treatment effect of
thrombectomy for late stroke is summarized in the following table.

    # A tibble: 1 × 5
      median   mad    low  high prob_pos
       <dbl> <dbl>  <dbl> <dbl>    <dbl>
    1  0.950 0.378 0.0158  1.75    0.977

When translated from the log odds scale, these values correspond to an
estimated 159% average improvement in the odds of functional
independence at 90 days with thrombectomy (95% CI 1.59% to 476%). The
probability of a positive average relative treatment effect of
thrombectomy for this patient population is estimated by the model to be
97.7%.

### Basilar

The model estimate for the average relative treatment effect of
thrombectomy for basilar stroke is summarized in the following table.

    # A tibble: 1 × 5
      median   mad    low  high prob_pos
       <dbl> <dbl>  <dbl> <dbl>    <dbl>
    1  0.700 0.339 -0.172  1.43    0.956

When translated from the log odds scale, these values correspond to an
estimated 101% average improvement in the odds of functional
independence at 90 days with thrombectomy (95% CI -15.8% to 317%). The
probability of a positive average relative treatment effect of
thrombectomy for this patient population is estimated by the model to be
95.5%.

## Anticipated relative treatment effect of thrombectomy in a new trial across stroke type

The model estimate for the variation in the trial-specific relative
treatment effect of thrombectomy for each stroke type is summarized in
the following table.

    # A tibble: 4 × 5
      data    median   mad     low  high
      <chr>    <dbl> <dbl>   <dbl> <dbl>
    1 large    0.332 0.284 0.0164  1.26 
    2 early    0.139 0.121 0.00716 0.507
    3 late     0.751 0.327 0.321   1.83 
    4 basilar  0.664 0.326 0.216   1.63 

When taken together with the estimates for the average relative
treatment effects, these estimates of trial-specific treatment effect
heterogeneity can be used to calculate the anticipated relative
treatment effect of thrombectomy in a new trial.

    # A tibble: 4 × 6
      data    median   mad    low  high prob_pos
      <chr>    <dbl> <dbl>  <dbl> <dbl>    <dbl>
    1 large    1.02  0.367 -0.300  2.25    0.956
    2 early    0.726 0.180  0.191  1.22    0.99 
    3 late     0.951 0.808 -1.17   2.90    0.857
    4 basilar  0.726 0.708 -1.31   2.36    0.829
