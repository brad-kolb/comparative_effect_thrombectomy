# Comparative effect of thrombectomy


## Observed data

There were a total of N = 5513 patients enrolled in J = 22 trials. 2687
were randomized to best medical management. 2826 were randomized to best
medical management plus mechanical thrombectomy. Each trial was
categorized into one of K = 4 categories according to the type of stroke
patients enrolled. Category 1 was large anterior circulation strokes.
Category 2 was small to medium sized anterior circulation strokes
treated in an early time window. Category 3 was small to medium sized
anterior circulation strokes treated in a late time window. Category 4
was strokes involving the basilar artery. The primary endpoint was
functional independence at 90 days (modified Rankin score of 0 to 2).

Observed frequency of outcomes for control and treatment groups are
shown below, with color corresponding to stroke type and the size of the
bubble to the sample size of the trial. Bubbles above the grey dashed
line denote trials in which the frequency of good outcome at 90 days was
greater for thrombectomy patients than for those treated with best
medical management only.

![](images/scatter_plot-03.png)

### Observed effect size

The observed relative and absolute effect sizes from each of the stroke
trials are shown here, with $y$ representing the observed treatment
effect of thrombectomy (the odds ratio on the log scale), $\text{se}$
representing the standard error for $y$. The quantities $\text{rr}$ and
$\text{arr}$ represent the observed relative and absolute risk
reduction, respectively.

    # A tibble: 22 × 7
           J     K name            y    se    rr     rd
       <dbl> <dbl> <chr>       <dbl> <dbl> <dbl>  <dbl>
     1     1     1 ANGEL       1.19  0.253  2.60 0.184 
     2     2     1 RESCUE      0.649 0.468  1.78 0.0616
     3     3     1 SELECT2     1.22  0.353  2.90 0.133 
     4     4     1 TENSION     2.09  0.632  6.89 0.145 
     5     5     1 TESLA       0.557 0.371  1.64 0.0567
     6     6     2 ESCAPE      1.04  0.240  1.84 0.248 
     7     7     2 EXTEND      1.27  0.511  1.73 0.303 
     8     8     2 MRCLEAN     0.704 0.208  1.68 0.134 
     9     9     2 PISTE       0.466 0.510  1.29 0.115 
    10    10     2 RESILIENT   0.729 0.307  1.70 0.144 
    11    11     2 REVASCAT    0.683 0.296  1.55 0.155 
    12    12     2 SWIFT       1.05  0.300  1.73 0.257 
    13    13     2 THERAPY     0.337 0.433  1.25 0.0757
    14    14     2 THRACE      0.440 0.201  1.26 0.109 
    15    15     3 DAWN        1.80  0.355  3.63 0.345 
    16    16     3 DEFUSE3     1.46  0.359  2.86 0.286 
    17    17     3 MRCLEANLATE 0.228 0.186  1.16 0.0528
    18    18     3 POSITIVE    1.39  0.799  1.75 0.321 
    19    19     4 ATTENTION   1.44  0.336  3.15 0.227 
    20    20     4 BAOCHE      1.37  0.340  2.79 0.251 
    21    21     4 BASICS      0.225 0.247  1.16 0.0493
    22    22     4 BEST        0.267 0.381  1.20 0.0564

The pooled data by category are shown in the following table.

    # A tibble: 4 × 7
      category trials `sample size`     y     se    rr    rd
      <chr>     <int>         <dbl> <dbl>  <dbl> <dbl> <dbl>
    1 large         5          1548 1.09  0.159   2.56 0.126
    2 early         9          2057 0.723 0.0926  1.57 0.168
    3 late          4           920 0.757 0.142   1.64 0.169
    4 basilar       4           988 0.725 0.149   1.69 0.143

The overall pooled data is shown in the following table.

    # A tibble: 1 × 6
      trials `sample size`     y     se    rr    rd
       <int>         <dbl> <dbl>  <dbl> <dbl> <dbl>
    1     22          5513 0.744 0.0611  1.70 0.150

## Results

The average chance of functional independence for a patient enrolled in
the medical arm of a large core stroke trial was 8.32% (5.59% - 12.5%)
compared to 30.0% (23.8% - 36.8%) for small core stroke trials, 25.7%
(17.6% - 36.2%) for extended window stroke trials, and 19.8% (13.1 -
28.5%) for basilar stroke trials.

The average chance of functional independence for a patient enrolled in
the treatment arm of a large core stroke trial was 17.6% (12.1% - 25.5%)
compared to 50.3% (42.0% - 58.9%) for small core stroke trials, 45.0%
(33.4% - 57.7%) for extended window stroke trials, and 36.9% (26.5 -
48.6%) for basilar stroke trials.

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

After accounting for uncertainty in all model parameters, the projected
probability of a positive impact on patient-level outcomes in a new
randomized trial of thrombectomy for large core stroke was XXX% (XXX%
NNT 100 - 10, XXX% NNT 10 or lower).
