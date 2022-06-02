# LorDist
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
\arguments{
\item{data.mat}{Abundance matrix with data type "matrix", row is feature, column is sample.}

\item{sample_information}{Metadata included Sample ID, Subject ID, Time point.}

\item{SampleID}{Column name of Sample ID in Metadata.}

\item{SubjectID}{Column name of Subject ID in Metadata.}

\item{Timepoint}{Column name of Time point in Metadata.}

\item{method}{Curve fitting method. The default is "Bspline", can also choose "Fourier".}

\item{norder}{an integer specifying the degree of b-splines. The default of 2.}

\item{varlim}{The lowest cumulative variance contribution rate when calculating the weighted principal component distance.The default of 0.8.}

\item{q}{Parameter when calculating the weighted principal component distance. The default of 1.}
}
\value{
a distance matrix
}
\description{
Calculate the distance of longitudinal microbial data using the method of functional data
}
\examples{
data(simdata)
dist<-LorDist(SimData.mat, SimSample_information, SampleID = 'SampleID',
              SubjectID = "SubjectID", Timepoint = 'Timepoint')

data(IBD2538)
dist<-LorDist(IBDdata.mat, IBDsample_information, SampleID = 'SampleID',
              SubjectID = "SubjectID", Timepoint = 'Timepoint')


}
