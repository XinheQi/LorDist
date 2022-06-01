#' Convert data into functional data format
#'
#' @param otu_data Abundance matrix with data type "data.frame", row is feature, column is sample.
#' @param collect_time a vector of sample collection time points
#' @param starttime Time to start sample collection
#' @param endtime Time to end sample collection
#' @param method Curve fitting method. The default is "Bspline", can also choose "Fourier".
#' @param norder an integer specifying the order of b-splines. The default of 2.
#'
#' @return an fdobj
#' @export
#'
#' @examples
#'
#'
#'

Sample2fd <- function(otu_data, collect_time, starttime, endtime, method, norder = 2){
  totu_data <- t(otu_data)
  motu_data <- as.matrix(otu_data,dim(otu_data)[2], dim(otu_data)[1])
  motu_data <- as.numeric(motu_data)
  motu_data <- matrix(motu_data, dim(otu_data)[2], dim(otu_data)[1], byrow = T)
  rangv <- c(starttime, endtime)
  nbasis <- endtime - starttime
  if(method == "Bspline"){
    basis <- fda::create.bspline.basis(rangv, nbasis, norder = norder+1)
  }
  if(method == "Fourier"){
    basis <- fda::create.fourier.basis(rangv, nbasis)
  }
  day <- collect_time

  otu_data.fd <- fda::Data2fd(argvals = day, y = motu_data,basis)
  otu_data.fd$fdnames$reps <- row.names(otu_data)
  return(otu_data.fd)
}
