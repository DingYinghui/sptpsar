% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit_terms.R
\name{fit_terms}
\alias{fit_terms}
\title{Compute terms for non-parametric spatial (2d) or 
  spatio-temporal (3d) trends and for smooth functions of continous 
  non-parametric covariates in PS-SAR regression models.}
\usage{
fit_terms(sptsarfit, variables)
}
\arguments{
\item{sptsarfit}{\emph{psar} object fitted using \code{\link{psar}} function.}

\item{variables}{vector including names of non-parametric covariates. 
To fit the terms of non-parametric spatial (2d) or spatio-temporal (3d) trend
this argument must be set equal to \emph{spttrend}.}
}
\value{
A list including:
  \tabular{ll}{
    \emph{fitted_terms} \tab Matrix including terms in columns. \cr
    \emph{se_fitted_terms} \tab Matrix including standard errors of terms in columns. \cr
    \emph{fitted_terms_fixed} \tab Matrix including fixed part of terms in columns. \cr
    \emph{se_fitted_terms_fixed} \tab Matrix including standard errors of fixed part of terms in columns. \cr
    \emph{fitted_terms_random} \tab Matrix including random part of terms in columns. \cr
    \emph{se_fitted_terms_random} \tab Matrix including standard errors of random part of terms in columns.\cr
 }
 This object can be used as an argument of \code{\link{plot_terms}} function
 to make plots of both non-parametric trends and smooth functions of covariates.
 See \emph{examples} below.
}
\description{
The \code{fit_terms} function compute both:
\itemize{
  \item Non-parametric spatial (2d) or spatio-temporal (3d) trends 
    including the decomposition in main and interaction trends 
    when the model is ANOVA.
    \item Smooth functions \eqn{f(x_i)} for non-parametric covariates 
      in semiparametric models. It also includes standard errors and the decomposition of each non-parametric
      term in fixed and random parts.
}
}
\examples{
################################################
 ###################### Examples using a panel data of rate of
 ###################### unemployment for 103 Italian provinces in period 1996-2014.
library(sptpsar)
data(unemp_it); Wsp <- Wsp_it
######################  No Spatial Trend: PSAR including a spatial 
######################  lag of the dependent variable
form1 <- unrate ~ partrate + agri + cons +
                 pspl(serv,nknots=15) +
                 pspl(empgrowth,nknots=20) 
 gamsar <- psar(form1,data=unemp_it,sar=TRUE,Wsp=Wsp_it)
 summary(gamsar)
 ######################  Fit non-parametric terms (spatial trend must be name "spttrend")
 list_varnopar <- c("serv","empgrowth")
 terms_nopar <- fit_terms(gamsar,list_varnopar)
 ######################  Plot non-parametric terms
 plot_terms(terms_nopar,unemp_it)
 
 ###############################################
 Examples of terms corresponding to spatial (2d) or 
            spatio-temporal (3d) trends
 ###############################################
 
 # Spatial (2d) semiparametric ANOVA model without spatial lag
 # Interaction term f12 with nested basis
form3 <- unrate ~ partrate + agri + cons +
                  pspl(serv,nknots=15) + pspl(empgrowth,nknots=20) +
                  pspt(long,lat,nknots=c(20,20),psanova=TRUE,
                  nest_sp1=c(1,2),nest_sp2=c(1,2))
# Spatial trend fixed for period 1996-2014
geospanova <- psar(form3,data=unemp_it)
summary(geospanova)
### Plot spatial trend (ANOVA)
spttrend <- fit_terms(geospanova,"spttrend")
lon <- scale(unemp_it$long); lat <- scale(unemp_it$lat)
### Plot main effects
plot_main_spt(spttrend,sp1=lon,sp2=lat,nT=19)

#'  ###############################################
 # Spatio-temporal (3d) semiparametric ANOVA model without spatial lag
 # Interaction terms f12,f1t,f2t and f12t with nested basis
 # Remark: It is necessary to include ntime as argument
 # Remark: nest_sp1, nest_sp2 and nest_time must be divisors of nknots
 form4 <- unrate ~ partrate + agri + cons +
                   pspl(serv,nknots=15) + pspl(empgrowth,nknots=20) +
                   pspt(long,lat,year,nknots=c(18,18,8),psanova=TRUE,
                   nest_sp1=c(1,2,3),nest_sp2=c(1,2,3),
                   nest_time=c(1,2,2),ntime=19)
 sptanova <- psar(form4,data=unemp_it,
                  control=list(thr=1e-2,maxit=200,trace=FALSE))
 summary(sptanova)
 ### Plot spatial trend (ANOVA)
 spttrend <- fit_terms(sptanova,"spttrend")
 lon <- scale(unemp_it$long); lat <- scale(unemp_it$lat)
 time <- unemp_it$year
 ### Plot main effects
 plot_main_spt(spttrend,sp1=lon,sp2=lat,time=time,nT=19)
 
 @export
 
}
\references{
\itemize{ 
 \item Lee, D. and Durbán, M. (2011). P-Spline ANOVA Type Interaction 
        Models for Spatio-Temporal Smoothing. \emph{Statistical Modelling}, (11), 49-69.
        
  \item Wood, S.N. (2017). \emph{Generalized Additive Models. 
  An Introduction with \code{R}} (second edition). CRC Press, Boca Raton.
 }
}
\seealso{
\itemize{
  \item \code{\link{psar}} estimate spatial or spatio-temporal semiparametric PS-SAR
          regression models.
  \item \code{\link{plot_terms}} plot smooth functions of non-parametric
    covariates.
  \item \code{\link{plot_main_spt}} plot main non-parametric functions in
    ANOVA trends.
}
}
\author{
Roman Minguez \email{roman.minguez@uclm.es} #'
}
