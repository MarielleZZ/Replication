\name{ppc.plot}
\alias{ppc.plot}
\title{Plot ppc.step2step3 output}
\description{
Creates a plot using the output of ppc.step2step3. }
\usage{
ppc.plot(llratio.s, llratio.r)
}
\arguments{
  \item{llratio.s}{
A vector with llratio values for the predicted data.}
  \item{llratio.r}{
The llratio value for the new data}
}

\value{
Returns a plot histogram of llratio values for the predicted data, and indicates the value of llratio for the new data with a red line. If llratio is equal to 0 for at least 10\% of the llratio for the predicted data, the function will create a seperate thick black line for this group of values.
}

\author{Zondervan-Zwijnenburg, M.A.J.}

\examples{
\dontrun{
#the following example can be used, but may take >10 seconds

#create data
rnorm2 <- function(n,mean,sd) { mean+sd*scale(rnorm(n)) }

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

step1.reg <- ppc.step1(y.o=y.o,model=model,nchains=2,n.r=50)

pT <- step1.reg$pT
reg.coef.ind <- which(pT$lhs=="y"&pT$op=="~"&pT$rhs=="x") #identify regression coefficient
free.i <- which(pT$free!=0)

R <- t(rep(0,times=length(free.i)))
R[pT$free[which(pT$id==reg.coef.ind)]] <- 1
r=c(pT$est[reg.coef.ind])        #regression coefficient => estimate

step23.reg <- ppc.step2step3(y.s=step1.reg$y.s,y.r=y.r,model=model,R=R,r=r)

ppc.plot(step23.reg$llratio.s,step23.reg$llratio.r)

}
}
