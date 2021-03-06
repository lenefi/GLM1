# Select Build, Build and reload to build and lode into the R-session.

mylm <- function(formula, data = list(), contrasts = NULL, ...){
  # Extract model matrix & responses
  mf <- model.frame(formula = formula, data = data)
  X  <- model.matrix(attr(mf, "terms"), data = mf, contrasts.arg = contrasts)
  y  <- model.response(mf)
  terms <- attr(mf, "terms")

  # Add code here to calculate coefficients, residuals, fitted values, etc...
  # and store the results in the list est

  # Calculating Beta coefficents
  Xt <- t(X)
  betahat <- solve(Xt %*% X) %*% Xt %*% y
  est <- list(terms = terms, model = mf)
  est$coeff = betahat

  # Calculating residuals, res, and product inverse(XtX)
  XtX_inv <- solve(Xt %*% X)
  H <- X %*% XtX_inv %*% Xt
  Yhat <- H %*% y
  res <- y - Yhat
  est$residuals <- res
  est$XtX_inv <- XtX_inv


  # Store call and formula used
  est$call <- match.call()
  est$formula <- formula

  # Store design matrix, response and fitted values
  # est$mat <- X
  est$response <- y
  est$fitted <- Yhat

  # Calculate and store residual standard error and standard error
  mu_est <- X %*% betahat
  SSE <- t(y - mu_est) %*% (y - mu_est)
  n <- dim(data)[1]
  p <- dim(est$coeff)[1]
  est$res_std_err <- sqrt( SSE / (n-p) )

  # cov is the covariance matrix for betahat
  est$cov <- (est$res_std_err^2)[1] * ( XtX_inv)

  # degrees of freedom for our model (observations - estimated parameters)
  est$freedom <- n-p

  # Set class name. This is very important!
  class(est) <- 'mylm'

  # Return the object with all results
  return(est)
}

print.mylm <- function(object){
  # Code here is used when print(object) is used on objects of class "mylm"
  # Useful functions include cat, print.default and format

  cat('Call:\n')
  print.default(object$call)
  cat('\n')

  cat('Coefficients:\n')
  out <- t(object$coeff)
  print.default(format(out, digits = 4))
}

summary.mylm <- function(object){
  zstat <- vector()
  for (n in object$coeff){
    z =object$coeff/((est$res_std_err)*sqrt(object$XtX_inv[n][n]))
    print(object$coeff[n], " standard error: ", sqrt(object$cov[n][n]), " z statistic:  ", z ," p-value: ", 2*pnorm(-abs(z)))



  }
  # Code here is used when summary(object) is used on objects of class "mylm"
  # Useful functions include cat, print.default and format
  #cat('Summary of object\n')
}

plot.mylm <- function(object){
  # Put dataframe on object
  fitres = data.frame(fitted = object$fitted, res = object$res)
  # ggplot on dataframe
  ggplot(fitres) + geom_point(aes(x=fitted, y=res)) +
    labs(x="Fitted values", y="Residuals", title = "Residuals vs Fitted values")
}

anova.mylm <- function(object, ...){
  # Code here is used when anova(object) is used on objects of class "mylm"

  # Components to test
  comp <- attr(object$terms, "term.labels")

  # Name of response
  response <- deparse(object$terms[[2]])

  # Fit the sequence of models
  txtFormula <- paste(response, "~", sep = "")
  model <- list()
  for(numComp in 1:length(comp)){
    if(numComp == 1){
      txtFormula <- paste(txtFormula, comp[numComp])
    }
    else{
      txtFormula <- paste(txtFormula, comp[numComp], sep = "+")
    }
    formula <- formula(txtFormula)
    model[[numComp]] <- lm(formula = formula, data = object$model)
  }

  # Print Analysis of Variance Table
  cat('Analysis of Variance Table\n')
  cat(c('Response: ', response, '\n'), sep = '')
  cat('          Df  Sum sq X2 value Pr(>X2)\n')
  for(numComp in 1:length(comp)){
    # Add code to print the line for each model tested
  }

  return(model)

}
