#' Draw PCA plot after running LorDist
#'
#' @param dist.mat output of LorDist
#' @param sample_information Metadata included Subject ID, Label.
#' @param SubjectID Column name of Subject ID in Metadata.
#' @param Label Column name of Label in Metadata.
#'
#' @return a figure as ggplot2 object
#' @export
#'
#' @examples
#' data(simdata)
#' dist<-LorDist(SimData.mat, SimSample_information, SampleID = 'SampleID',
#'               SubjectID = "SubjectID", Timepoint = 'Timepoint')
#' drawPCAplot(dist, SimSample_information, SubjectID = "SubjectID", Label = "Label")
#'
#'
#'


drawPCAplot <- function(dist.mat, sample_information, SubjectID, Label){

  PCOA = ape::pcoa(dist.mat, correction = "none")

  sample.Label <- as.data.frame(cbind(subjectid = sample_information[, SubjectID],
                                      label = sample_information[, Label]))

  sample.Label <- sample.Label[!duplicated(sample.Label), ]

  subject_id <- colnames(as.matrix(dist.mat))
  label <- sample.Label
  for(i in 1:length(subject_id)){
    for (j in 1:length(subject_id)){
      if(subject_id[i] == sample.Label[j, 1]){
        label[i, ] = sample.Label[j, ]
      }
    }
  }

  result <-PCOA$values[, "Relative_eig"]
  pro1 = as.numeric(sprintf("%.3f", result[1])) * 100
  pro2 = as.numeric(sprintf("%.3f", result[2])) * 100
  x = PCOA$vectors
  sample_names = rownames(x)
  pc = as.data.frame(PCOA$vectors)
  pc$names = sample_names
  legend_title = ""
  group = label[, 2]
  pc$group = group
  xlab = paste("PCA1(", pro1, "%)", sep = "")
  ylab = paste("PCA2(", pro2, "%)", sep = "")
  title = "PCA Plot"

  p_value <- vegan::adonis(dist.mat ~ group)[["aov.tab"]][["Pr(>F)"]][1]
  p_value_lab <- paste("P-value =", p_value)

  ggplot2::ggplot(data = pc, ggplot2::aes(x = Axis.1, y = Axis.2,
                                          color = group, shape = group)) +
    ggplot2::geom_point(size = 3) +
    ggplot2::theme_bw() +
    ggplot2::theme(panel.grid = ggplot2::element_blank()) +
    ggplot2::geom_vline(xintercept = 0,lty = "dashed") +
    ggplot2::geom_hline(yintercept = 0,lty = "dashed") +
    ggplot2::labs(x = xlab, y = ylab, title = title) +
    ggplot2::stat_ellipse(data = pc,
                          geom = "polygon",
                          ggplot2::aes(fill = group),
                          alpha = 0.2,
                          color = F)+
    ggplot2::scale_fill_manual(values = c("#fa7f6f","#82b0d2","#ffbe7a","#8ecfc9","#beb8dc")) +
    ggplot2::scale_color_manual(values = c("#fa7f6f","#82b0d2","#ffbe7a","#8ecfc9","#beb8dc")) +
    ggplot2::annotate("text", x = -Inf, y = -Inf, hjust = 0, vjust = 0,
                      label = p_value_lab, size = 5)
}











