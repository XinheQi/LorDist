# LorDist

## Description
Calculate the distance of longitudinal microbial data using the method of functional data

## Usage
```
LorDist(
  data.mat,
  sample_information,
  SampleID,
  SubjectID,
  Timepoint,
  method = "Bspline",
  norder = 2,
  varlim = 0.8,
  q = 1
)
```

## Arguments

$data.mat$: Abundance matrix with data type "matrix", row is feature, column is sample.

$sample_information$: Metadata included Sample ID, Subject ID, Time point.

$SampleID$: Column name of Sample ID in Metadata.

SubjectID: Column name of Subject ID in Metadata.

Timepoint: Column name of Time point in Metadata.

method: Curve fitting method. The default is "Bspline", can also choose "Fourier".

norder: an integer specifying the degree of b-splines. The default of 2.

varlim: The lowest cumulative variance contribution rate when calculating the weighted principal component distance.The default of 0.8.

q: Parameter when calculating the weighted principal component distance. The default of 1.

## Value
a distance matrix

## Examples
```
data(simdata)
dist<-LorDist(SimData.mat, SimSample_information, SampleID = 'SampleID',
              SubjectID = "SubjectID", Timepoint = 'Timepoint')

data(IBD2538)
dist<-LorDist(IBDdata.mat, IBDsample_information, SampleID = 'SampleID',
              SubjectID = "SubjectID", Timepoint = 'Timepoint')
```

