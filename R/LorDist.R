#' Calculate the distance of longitudinal microbial data using the method of functional data
#'
#' @param data.mat Abundance matrix with data type "matrix", row is feature, column is sample.
#' @param sample_information Metadata included Sample ID, Subject ID, Time point.
#' @param SampleID Column name of Sample ID in Metadata.
#' @param SubjectID Column name of Subject ID in Metadata.
#' @param Timepoint Column name of Time point in Metadata.
#' @param method Curve fitting method. The default is "Bspline", can also choose "Fourier".
#' @param norder an integer specifying the degree of b-splines. The default of 2.
#' @param varlim The lowest cumulative variance contribution rate when calculating the weighted principal component distance.The default of 0.8.
#' @param q Parameter when calculating the weighted principal component distance. The default of 1.
#'
#' @return a distance matrix
#' @export
#'
#' @examples
#' data(simdata)
#' dist<-LorDist(SimData.mat, SimSample_information, SampleID = 'SampleID',
#'               SubjectID = "SubjectID", Timepoint = 'Timepoint')
#'
#' data(IBD2538)
#' dist<-LorDist(IBDdata.mat, IBDsample_information, SampleID = 'SampleID',
#'               SubjectID = "SubjectID", Timepoint = 'Timepoint')
#'
#'





LorDist <- function(data.mat, sample_information, SampleID, SubjectID, Timepoint,
                    method = "Bspline", norder = 2, varlim = 0.8, q = 1){
  subject_id <- names(table(sample_information[, SubjectID]))
  otu_data.fd_all <- list()
  for(i in 1:length(subject_id)){
    subject <- sample_information[which(sample_information[, SubjectID] == subject_id[i]),]
    subject <- subject[order(subject[, Timepoint]),]
    otu_data <- data.mat[, match(subject[, SampleID], colnames(data.mat))]
    collect_time <- subject[,Timepoint]
    if(sum(is.na(colnames(otu_data))) > 0){
      ind <- which(is.na(colnames(otu_data)) == T)
      otu_data <- otu_data[, -ind]
      collect_time <- collect_time[-ind]
    }

    otu_data.fd <- LorDist::Sample2fd(otu_data, collect_time,
                                      min(sample_information[, Timepoint]),
                                      max(sample_information[, Timepoint]), method, 2)
    otu_data.fd_all[[i]] <- otu_data.fd
  }

  OTU.fd_all <- list()

  for(k in 1:nrow(data.mat)){
    i <- 1
    OTU.fd <- otu_data.fd_all[[i]][k]
    for(i in 2:length(subject_id)){
      OTU.fd$coefs <- cbind(OTU.fd$coefs, (otu_data.fd_all[[i]][k])$coefs)
    }
    OTU.fd_all[[k]] <- OTU.fd
  }

  calculateWPCAdistance <- function(fdaobj){
    varlim = varlim
    q = q
    rownum <- nrow(fdaobj$coefs)
    colnum <- ncol(fdaobj$coefs)
    for(i in 1:rownum){
      fdaobj.pca <- fda::pca.fd(fdaobj, nharm = i)
      if(sum(fdaobj.pca$varprop) >= varlim)break
    }
    dist <- matrix(rep(NA,colnum^2),nrow = colnum)
    for(i in 1:colnum){
      for(j in 1:i){
        dist[i,j] <- sum((fdaobj.pca$varprop*abs(fdaobj.pca$scores[i,] - fdaobj.pca$scores[j,]))^q)^(1/q)
      }
    }
    return(dist)
  }

  dist.list <- lapply(OTU.fd_all, calculateWPCAdistance)
  pow2 <- function(x){
    return(x^2)
  }
  dist.list.sq <- lapply(dist.list, pow2)

  dist.final <- sqrt(Reduce("+", dist.list.sq))

  row.names(dist.final)<-subject_id
  colnames(dist.final)<-subject_id

  dist.final.d <- as.dist(dist.final)
  return(dist.final.d)

}



