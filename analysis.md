Comparative effect of thrombectomy
================

## Observed Data

There were a total of 5,513 patients enrolled in J = 22 trials. 2,687
were randomized to best medical management. 2,826 were randomized to
best medical management plus mechanical thrombectomy. Each trial was
categorized into one of K = 22 categories according to the type of
stroke patients enrolled. Category K = 1 is large anterior circulation
strokes. Category 2 is small to medium sized anterior circulation
strokes treated in an early time window. Category 3 is small to medium
sized anterior circulation strokes treated in a late time window.
Category 4 is strokes involving the vertebro-basilar circulation. The
primary endpoint was functional independence at 90 days (modified Rankin
score of 0 to 2). Other 90 day outcomes examined were independent
ambulation (modified Rankin score 0 to 3), complete dependence (modified
Rankin score 5), and death (modified Rankin score 6).

The pooled observed odds ratios and their standard errors by category
are shown in the following table.

    # A tibble: 4 × 8
          K     J   r_c   n_c   r_t   n_t     y     se
      <dbl> <int> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>
    1     1     5    62   766   162   782 1.09  0.159 
    2     2     9   305  1031   476  1026 0.723 0.0926
    3     3     4   120   458   199   462 0.757 0.142 
    4     4     4    89   432   194   556 0.725 0.149 

## Model estimates

Model estimates for trials of thrombectomy in early strokes are shown in
the following table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1  0.727 0.113 0.493 0.964     1.00

These values imply that thrombectomy for early strokes was estimated to
improve the odds of functional independence at 90 days by 107%.

Model estimates for trials of thrombectomy in late strokes are shown in
the following table.

    # A tibble: 1 × 5
      median   mad     low  high prob_pos
       <dbl> <dbl>   <dbl> <dbl>    <dbl>
    1  0.971 0.394 0.00580  1.82    0.976

These values imply that thrombectomy for basilar strokes was estimated
to improve the odds of functional independence at 90 days by 164%.

Model estimates for trials of thrombectomy in basilar strokes are shown
in the following table.

    # A tibble: 1 × 5
      median   mad    low  high prob_pos
       <dbl> <dbl>  <dbl> <dbl>    <dbl>
    1  0.698 0.344 -0.213  1.50    0.948

These values imply that thrombectomy for basilar strokes was estimated
to improve the odds of functional independence at 90 days by 101%.

Model estimates for trials of thrombectomy in large strokes are shown in
the following table.

    # A tibble: 1 × 5
      median   mad   low  high prob_pos
       <dbl> <dbl> <dbl> <dbl>    <dbl>
    1   1.01 0.227 0.399  1.46    0.995

These values imply that thrombectomy for large strokes was estimated to
improve the odds of functional independence at 90 days by 176%.
