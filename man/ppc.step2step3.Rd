\name{ppc.step2step3}
\alias{ppc.step2step3}
\title{Prior predictive check step 2 and 3}
\description{
Calculates a likelihood ratio (D) for new data (y.r) and predicted data (y.s) according to the proposed constraints, and generates a prior predictive p-value.}
\usage{
ppc.step2step3(y.s, y.r, model = model, R, r = NULL, E = 0,
        effectsize = FALSE, s.i,
        ordered = NULL, sample.cov = NULL, sample.mean = NULL, sample.nobs = NULL,
        group = NULL, cluster = NULL, constraints = "", WLS.V = NULL, NACOV = NULL,
        bayes = FALSE, dp = NULL, nchains = 2, obs = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{y.s}{A list containing all y.s.}
  \item{y.r}{A data.frame with the new data.}
  \item{model}{The (b)lavaan model that is to be fitted to the data.}
  \item{R}{A p by q matrix, where p is the number of free parameters in the model, and q is the number of constraints to be imposed on the model. Each row represents one constraint.}
  \item{r}{A vector of length p holding the minimimum sum for each row in R.}
  \item{E}{Numeric; the first E constraints are treated as equality constraints, all further as inequality constraints. Default value = 0.}
  \item{effectsize}{Logic; if TRUE, the constraints concern effectsizes.}
  \item{s.i}{A vector of length p holding with indices for the (pooled) standard deviation parameters with which the effect sizes should be computed}
  \item{ordered}{Character vector. Only used if the data is in a data.frame. Treat these variables as ordered (ordinal) variables, if they are endogenous in the model. Importantly, all other variables will be treated as numeric (unless they are declared as ordered in the original data.frame}
  \item{sample.cov}{Numeric matrix. A sample variance-covariance matrix. The rownames and/or colnames must contain the observed variable names. For a multiple group analysis, a list with a variance-covariance matrix for each group. Note that if maximum likelihood estimation is used and likelihood="normal", the user provided covariance matrix is internally rescaled by multiplying it with a factor (N-1)/N, to ensure that the covariance matrix has been divided by N. This can be turned off by setting the sample.cov.rescale argument to FALSE.
}
  \item{sample.mean}{A sample mean vector. For a multiple group analysis, a list with a mean vector for each group.}
  \item{sample.nobs}{
Number of observations if the full data frame is missing and only sample moments are given. For a multiple group analysis, a list or a vector with the number of observations for each group.}
  \item{group}{
A variable name in the data frame defining the groups in a multiple group analysis.}
  \item{cluster}{The cluster variable for multilevel data (beta!).}
  \item{constraints}{
Additional (in)equality constraints not yet included in the model syntax. See model.syntax for more information. Note that the replication hypothesis should not be specified here!}
  \item{WLS.V}{
A user provided weight matrix to be used by estimator "WLS"; if the estimator is "DWLS", only the diagonal of this matrix will be used. For a multiple group analysis, a list with a weight matrix for each group. The elements of the weight matrix should be in the following order (if all data is continuous): first the means (if a meanstructure is involved), then the lower triangular elements of the covariance matrix including the diagonal, ordered column by column. In the categorical case: first the thresholds (including the means for continuous variables), then the slopes (if any), the variances of continuous variables (if any), and finally the lower triangular elements of the correlation/covariance matrix excluding the diagonal, ordered column by column.}
  \item{NACOV}{
A user provided matrix containing the elements of (N times) the asymptotic variance-covariance matrix of the sample statistics. For a multiple group analysis, a list with an asymptotic variance-covariance matrix for each group. See the WLS.V argument for information about the order of the elements.}
  \item{bayes}{Logic; if TRUE, a Bayesian estimator is used. }
  \item{dp}{blavaan default prior distributions on different types of parameters, typically the result of a call to dpriors(). See the dpriors() help file for more information.}
  \item{nchains}{A scalar indicating the number of chains to be used in the Bayesian analysis. Default value = 2.}
  \item{obs}{logic; if FALSE, there is no y.r. obs = FALSE when computing power.}
  }
\value{
Generates a histogram of llratio.s in which llratio.r is indicated with a vertical line. The proportion of llratio.s at the right of this line constitutes the prior predictive p-value.
\item{llratio.r}{The likelihood ratio for the new dataset.}
\item{p-value}{The prior predictive p-value.}
\item{llratio.s}{The likelihood ratio's for each of the datasets y.s.}
}
\author{M. A. J. Zondervan-Zwijnenburg}
\examples{
\dontrun{
#the following example can be used, but may take >10 seconds

#create data
rnorm2 <- function(n,mean,sd) { mean+sd*scale(rnorm(n)) }

# simple regression -------------------------------------------------------

#step 1 input
#create/load data
n.o=30 #sample size original data
y.o <- data.frame(y=rnorm2(n.o,0,1),x=rnorm2(n.o,3,1))
#y.o <- correlate(as.matrix(y.o), corm=.70); y.o <- data.frame(y=y.o[,1],x=y.o[,2])
n.r=50 #sample size new data
y.r <- data.frame(y=rnorm2(n.r,0.5,1),x=rnorm2(n.r,3,1))

#blavaan model
model <- '
y ~ x     #regression
y ~1      #intercept not default in lavaan (but is in blavaan)
'

#Warning: This is a minimal example;
step1.reg <- ppc.step1(y.o=y.o,model=model,nchains=2,n.r=50)

pT <- step1.reg$pT
reg.coef.ind <- which(pT$lhs=="y"&pT$op=="~"&pT$rhs=="x") #identify regression coefficient
free.i <- which(pT$free!=0)

R <- t(rep(0,times=length(free.i)))
R[pT$free[which(pT$id==reg.coef.ind)]] <- 1
r=c(pT$est[reg.coef.ind])        #regression coefficient => estimate

step23.reg <- ppc.step2step3(y.s=step1.reg$y.s,y.r=y.r,model=model,R=R,r=r)
}
}
\keyword{htest }% use one of  RShowDoc("KEYWORDS")
\keyword{models }% __ONLY ONE__ keyword per line
