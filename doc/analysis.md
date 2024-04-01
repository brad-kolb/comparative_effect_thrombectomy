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

## Estimated relative effect of thrombectomy across stroke types

### Early

Model estimates for trials of thrombectomy in early stroke are shown in
the following table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1  0.727 0.113 0.493 0.964     1.00

These values correspond to an estimated 107% average improvement in the
odds of functional independence at 90 days with thrombectomy (95% CI
63.8% to 162%). The expected effect of thrombectomy on 90 day functional
independence in the next early stroke trial is shown in the following
table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1  0.730 0.175 0.198  1.25    0.990

The probability of thrombectomy improving the odds of functional
independence at 90 days in a new trial was estimated to be 99%.

Bayesian I^2 is shown in the following table.

    # A tibble: 1 × 4
      median   mad      low  high
       <dbl> <dbl>    <dbl> <dbl>
    1  0.140 0.180 0.000182 0.666

### Large

Model estimates for trials of thrombectomy in large stroke are shown in
the following table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1   1.01 0.227 0.399  1.46    0.995

These values correspond to an estimated 176% average improvement in the
odds of functional independence at 90 days with thrombectomy (95% CI
49.1% to 333%). The expected effect of thrombectomy on 90 day functional
independence in the next large stroke trial is shown in the following
table.

    # A tibble: 1 × 5
      median   mad    low  high prob_pos
       <dbl> <dbl>  <dbl> <dbl>    <dbl>
    1   1.01 0.366 -0.157  2.05    0.961

The probability of thrombectomy improving the odds of functional
independence at 90 days in a new trial was estimated to be 96.1%.

Bayesian I^2 is shown in the following table.

    # A tibble: 1 × 4
      median   mad     low  high
       <dbl> <dbl>   <dbl> <dbl>
    1  0.327 0.357 0.00159 0.878

### Late

Model estimates for trials of thrombectomy in late stroke are shown in
the following table.

    # A tibble: 1 × 5
      median   mad     low  high prob_pos
       <dbl> <dbl>   <dbl> <dbl>    <dbl>
    1  0.971 0.394 0.00580  1.82    0.976

These values correspond to an estimated 164% average improvement in the
odds of functional independence at 90 days with thrombectomy (95% CI
0.581% to 515%). The expected effect of thrombectomy on 90 day
functional independence in the next late stroke trial is shown in the
following table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1  0.958 0.809 -1.22  2.96    0.856

The probability of thrombectomy improving the odds of functional
independence at 90 days in a new trial was estimated to be 85.6%.

Bayesian I^2 is shown in the following table.

    # A tibble: 1 × 4
      median   mad   low  high
       <dbl> <dbl> <dbl> <dbl>
    1  0.715 0.171 0.306 0.931

### Basilar

Model estimates for trials of thrombectomy in basilar stroke are shown
in the following table.

    # A tibble: 1 × 5
      median   mad    low  high prob_pos
       <dbl> <dbl>  <dbl> <dbl>    <dbl>
    1  0.698 0.344 -0.213  1.50    0.948

These values correspond to an estimated 101% average improvement in the
odds of functional independence at 90 days with thrombectomy (95% CI
-19.2% to 348%). The expected effect of thrombectomy on 90 day
functional independence in the next basilar stroke trial is shown in the
following table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1  0.721 0.691 -1.25  2.61    0.825

The probability of thrombectomy improving the odds of functional
independence at 90 days in a new trial was estimated to be 82.5%.

Bayesian I^2 is shown in the following table.

    # A tibble: 1 × 4
      median   mad   low  high
       <dbl> <dbl> <dbl> <dbl>
    1  0.802 0.154 0.214 0.962
