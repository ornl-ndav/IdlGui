FUNCTION MY_NEWCURVEFIT, x, y, weights, a, sigma, parinfo=parinfo, cm=cm, $
                      Function_Name = Function_Name, $
                      itmax=itmax, iter1=iter1, tol=tol, chisq=chisq, $
                      noderivative=noderivative, $
                         func_extra = func_extra, $
                         iterproc = iterproc, itercount=itercount
; NAME:
;       MY_CURVEFIT
;
; PURPOSE:
;       Non-linear least squares fit to a function of an arbitrary
;       number of parameters.  The function may be any non-linear
;       function.  If available, partial derivatives can be calculated by
;       the user function, else this routine will estimate partial derivatives
;       with a forward difference approximation.
;
; CATEGORY:
;       E2 - Curve and Surface Fitting.
;
; CALLING SEQUENCE:
;       Result = MY_CURVEFIT(X, Y, Weights, A, SIGMA, indx=indx,$
;		PARINFO=parinfo, FUNCTION_NAME = name, ITMAX=ITMAX, $
;		ITER=ITER1, TOL=TOL, CHISQ=CHISQ, CM=cm, $ 
;		/NODERIVATIVE, ITERPROC=iterproc, ITERCOUNT=itercount)
;
; INPUTS:
;       X:  A row vector of independent variables.  This routine does
;               not manipulate or use values in X, it simply passes X
;               to the user-written function.
;
;       Y:  A row vector containing the dependent variable.
;
;  Weights:  A row vector of weights, the same length as Y.
;            For no weighting,
;                 Weights(i) = 1.0.
;            For instrumental (Gaussian) weighting,
;                 Weights(i)=1.0/sigma(i)^2
;            For statistical (Poisson)  weighting,
;                 Weights(i) = 1.0/y(i), etc.
;
;       A:  A vector, with as many elements as the number of terms, that
;           contains the initial estimate for each parameter.  
;           Calculations are performed in double precision.
;           Fitted parameters are returned in A.
;
;
; KEYWORDS:
;
;	CM: The Covariance-Matrix sigma_ij.
;	    The errors are Sqrt of the diagonal-elements of the
;	     correlation matrix.
;
;       FUNCTION_NAME:  The name of the function (actually, a procedure) to
;            fit.  If omitted, "FUNCT" is used. The procedure must be written as
;            described under RESTRICTIONS, below.
;
;       ITMAX:  Maximum number of iterations. Default = 20.
;       ITER1:   The actual number of iterations which were performed
;       TOL:    The convergence tolerance. The routine returns when the
;               relative decrease in chi-squared is less than TOL in an
;               interation. Default = 1.e-3.
;       CHISQ:   The value of chi-squared on exit 
;
;       NODERIVATIVE:   If this keyword is set then the user procedure will not
;               be requested to provide partial derivatives. The partial
;               derivatives will be estimated in CURVEFIT using forward
;               differences. If analytical derivatives are available they
;               should always be used.
;
;       FUNC_EXTRA: Extra parameters, which are directly passed to the 
;               fit-function.
;
;       ITERPROC: The name of a procedure, which is to be called
;                 during the fitting process, e.g. to display intermediate
;                 results during fits, which take long computation times
;                 The Procedure should be defined the following:
;
;               PRO during_fit, x, y, sigma, yfit, para=para, iter=iter1,
;                    chisqr=chisqr,func_extra=func_extra
;    
;        ITERCOUNT: If ITERPROC is defined, this procedure will be
;        called  every ITERCOUNT step
;
;
;      PARINFO - Provides a mechanism for more sophisticated constraints
;             to be placed on parameter values.  When PARINFO is not
;             passed, then it is assumed that all parameters are free
;             and unconstrained.  No values in PARINFO are modified
;             during the call to MY_NEWCURVEFIT
;
;             PARINFO should be an array of structures, one for each
;             parameter.  Each parameter is associated with one
;             element of the array, in numerical order.  The structure
;             should have at least the following entries:
;
;               - VALUE - the starting parameter value 
;
;               - FIXED - a boolean value, whether the parameter is to 
;                         be held fixed or not.  Fixed parameters are
;                         not varied by MYNEWCURVEFIT, but are passed on to 
;                         FUNCTION_NAME for evaluation.
;
;               - LIMITED - a two-element boolean array.  If the
;                 first/second element is set, then the parameter is
;                 bounded on the lower/upper side.  A parameter can be
;                 bounded on both sides.
;
;               - LIMITS - a two-element float or double array.  Gives
;                 the parameter limits on the lower and upper sides,
;                 respectively.  Zero, one or two of these values can
;                 be set, depending on the value of LIMITED.
;
;               - STEP - the step size to be used in calculating the
;                 numerical derivatives.  If set to zero, then the
;                 step size is computed automatically.
; 
;             Other tag values can also be given in the structure, but
;             they are ignored.
;
;             Example:
;             parinfo = replicate({value:0.D, fixed:0, $
;                           limited:[0,0], limits:[0.D,0], step:0.D}, 5)
;             parinfo(0).fixed = 1
;             parinfo(4).limited(0) = 1
;             parinfo(4).limits(0)  = 50.D
;             parinfo(*).value = [5.7D, 2.2, 500., 1.5, 2000.]
;
;             A total of 5 parameters, with starting values of 5.7,
;             2.2, 500, 1.5, and 2000 are given.  The first parameter
;             is fixed at a value of 5.7, and the last parameter is
;             constrained to be above 50.
;
;             Default value:  all parameters are free and unconstrained.
;
; OUTPUTS:
;       Returns a vector of calculated values.
;       A:  A vector of parameters containing fit.
;       Sigma:  A vector of standard deviations for the parameters.
;	CM: The Correlation matrix
;
;
; RESTRICTIONS:
;       The function to be fit must be defined and called FUNCT,
;       unless the FUNCTION_NAME keyword is supplied.  This function,
;       (actually written as a procedure) must accept values of
;       X (the independent variable), and A (the fitted function's
;       parameter values), and return F (the function's value at
;       X), and PDER (a 2D array of partial derivatives).
;       For an example, see FUNCT in the IDL User's Libaray.
;       A call to FUNCT is entered as:
;       FUNCT, X, A, F, PDER
; where:
;       X = Variable passed into CURVEFIT.  It is the job of the user-written
;               function to interpret this variable.
;       A = Vector of NTERMS function parameters, input.
;       F = Vector of NPOINT values of function, y(i) = funct(x), output.
;       PDER = Array, (NPOINT, NTERMS), of partial derivatives of funct.
;               PDER(I,J) = DErivative of function at ith point with
;               respect to jth parameter.  Optional output parameter.
;               PDER should not be calculated if the parameter is not
;               supplied in call. If the /NODERIVATIVE keyword is set in the
;               call to CURVEFIT then the user routine will never need to
;               calculate PDER.
;
; PROCEDURE:
;       Copied from "CURFIT", least squares fit to a non-linear
;       function, pages 237-239, Bevington, Data Reduction and Error
;       Analysis for the Physical Sciences.  This is adapted from:
;       Marquardt, "An Algorithm for Least-Squares Estimation of Nonlinear
;       Parameters", J. Soc. Ind. Appl. Math., Vol 11, no. 2, pp. 431-441,
;       June, 1963.
;
;       Changed by Heiko Hünnefeld and Steffen Keitel, Jan. 1998
;       Address: HASYLAB, Notkestr. 85, 22603 Hamburg, Germany
;       email: hhuenne@desy.de, keitel@desy.de
;       Added Index-field to do constrained fits
;
;       Modified by Colin Rosenthal, July 1998, to make plug-in
;       compatible with CURVEFIT and to allow fitting to 
;       a single parameter at a time. crosenthal@solar.stanford.edu
;
;       Modified to allow for lower and upper bounds by Heiko
;       Hünnefeld, 26.10.98, on the basis of MPFIT, a fitting routine
;       by Craig Markwardt (craigmnet@astrog.physics.wisc.edu)
;
;       "This method is the Gradient-expansion algorithm which
;       combines the best features of the gradient search with
;       the method of linearizing the fitting function."
;
;       Iterations are performed until the chi square changes by
;       only TOL or until ITMAX iterations have been performed.
;
;       The initial guess of the parameter values should be
;       as close to the actual values as possible or the solution
;       may not converge.
;
;        ON_ERROR,2              ;Return to caller if error
;
;*********Name of function to fit*******************************************
	IF N_ELEMENTS(function_name) EQ 0 THEN function_name = "FUNCT"
;*Convergence tolerance*****************************************************
	IF N_ELEMENTS(tol) EQ 0		THEN tol = 1.e-3
;*Maximum # iterations******************************************************
	IF N_ELEMENTS(itmax) EQ 0 	THEN itmax = 30
	IF N_ELEMENTS(iterproc) EQ 0	THEN plot_during = 0 ELSE plot_during = 1
	IF N_ELEMENTS(itercount) EQ 0	THEN itercount=1

;
        IF N_ELEMENTS(parinfo) EQ 0 THEN BEGIN
            indx  = LONARR(N_ELEMENTS(a))+1 
            qulim = LONARR(N_ELEMENTS(a))
            qllim = qulim
            ulim  = qulim
            llim  = qulim
            step  = LONARR(N_ELEMENTS(a))
        ENDIF ELSE BEGIN
            indx  = 1-parinfo.fixed
            qulim = parinfo[WHERE(indx)].limited[1]
            ulim  = parinfo[WHERE(indx)].limits[1]
            qllim = parinfo[WHERE(indx)].limited[0]
            llim  = parinfo[WHERE(indx)].limits[0]
            step  = parinfo[WHERE(indx)].step
        ENDELSE
        IF TOTAL(indx) EQ 0 THEN BEGIN
            MESSAGE, 'Curvefit - Dont fix all parameters !', /INFORMATIONAL
            RETURN, -1
        ENDIF
;
;*Make params double********************************************************
	a	=	DOUBLE(a)
	a_free	=	a(WHERE(indx))
;
;*If we will be estimating partial derivatives then compute machine precision*
	IF KEYWORD_SET(NODERIVATIVE) THEN eps = SQRT((NR_MACHAR(/DOUBLE)).EPS)
;*# of parameters***********************************************************
	nterms	=	N_ELEMENTS(a_free)
;*Degrees of freedom********************************************************
	nfree	=	N_ELEMENTS(y) - nterms
 	IF nfree LE 0 THEN BEGIN
            MESSAGE, 'Curvefit - not enough data points.', /INFORMATIONAL
            RETURN, -1
        ENDIF
;
;*Initial lambda************************************************************
	flambda	=	0.001
;*Subscripts of diagonal elements*******************************************
	diag	=	LINDGEN(nterms)*(nterms+1)
;
;*Define the partial derivative array***************************************
	pder		=	DBLARR(N_ELEMENTS(y), nterms) 
	pder_old	=	DBLARR(N_ELEMENTS(y), N_ELEMENTS(a))
;
;***************************************************************************
;*Iteration loop************************************************************
;***************************************************************************
;
	FOR iter1 = 1, itmax DO BEGIN
;
	 a_free=a(WHERE(indx))
;
;*Evaluate function and estimate partial derivatives************************
         
	 IF KEYWORD_SET(NODERIVATIVE) THEN BEGIN
	  CALL_PROCEDURE, Function_name, x, a, yfit, FUNC_EXTRA=func_extra
	  FOR term=0, nterms-1 DO BEGIN
		p = a_free       ; Copy current parameters
;*Increment size for forward difference derivative**************************
		inc			=	eps * abs(p[term])
               IF (step[term] NE 0.0) THEN inc = step[term]
		IF (inc LE eps/100) THEN inc =	eps
		p[term]			=	p[term] + inc
		p_all			=	a
		p_all(WHERE(indx))	=	p
		CALL_PROCEDURE, function_name, x, p_all, yfit1, FUNC_EXTRA=func_extra
		pder(*,term)		=	(yfit1-yfit) / inc		
	  ENDFOR
	 ENDIF ELSE BEGIN
;*The user's procedure will return partial derivatives*********************
	  CALL_PROCEDURE, function_name, x, a, yfit, pder_old, FUNC_EXTRA=func_extra 
	  pder = pder_old(*,WHERE(indx))
	 ENDELSE

;; Determine if any of the parameters are pegged at the limits
         whlpeg = WHERE(qllim AND (a(WHERE(indx)) EQ llim), nlpeg)
         whupeg = WHERE(qulim AND (a(WHERE(indx)) EQ ulim), nupeg)
  
;; See if any "pegged" values should keep their derivatives
         pder_free=pder(*,WHERE(indx))
         IF (nlpeg GT 0) THEN BEGIN
;; Total derivative of sum wrt lower pegged parameters
             FOR i = 0, nlpeg-1 DO BEGIN
                 sum = TOTAL(yfit * pder_free[*,whlpeg[i]])
                 IF sum GT 0 THEN pder_free[*,whlpeg[i]] = 0
             ENDFOR
         ENDIF
         IF (nupeg GT 0) THEN BEGIN
;; Total derivative of sum wrt upper pegged parameters
             FOR i = 0, nupeg-1 DO BEGIN
                 sum = TOTAL(yfit * pder_free[*,whupeg[i]])
                 IF sum GT 0 THEN pder_free[*,whupeg[i]] = 0
             ENDFOR
         ENDIF
;
;*Evaluate alpha and beta matricies*****************************************
;*Gradient-Matrix  beta = -0.5*PartialDerivative(chisqr, a)*****************
         IF nterms GT 1 THEN BEGIN

	   beta	=	(y-yfit) * weights # pder
	 ENDIF ELSE beta= TOTAL((y-yfit)*weights*pder)
;	 stop
;*Curvature matrix alpha****************************************************
	 alpha	=	TRANSPOSE(pder) # (weights # (DBLARR(nterms)+1)*pder)
;*Present chi squared.******************************************************
	 chisq1	=	TOTAL(weights*(y-yfit)^2) / nfree 
;*If it's a good fit, no need to iterate************************************
	 all_done =	chisq1 LT TOTAL(ABS(y))/1e7/nfree
;*use Marquardt-method to find new parameters*******************************
	 kill_loop=	1
	 REPEAT BEGIN
		alpha[diag] = alpha[diag]*(1.+flambda)          
		IF N_ELEMENTS(alpha) EQ 1 THEN $
			covar = (1.0 / alpha) ELSE covar = INVERT(alpha)
;*New parameters***********************************************************
                IF nterms GT 1 THEN para_step = covar#TRANSPOSE(beta) $
                ELSE para_step = covar[0]*beta

;*Do not allow any steps out of bounds*************************************
                IF nlpeg GT 0 THEN para_step[whlpeg] = para_step[whlpeg] > 0
                IF nupeg GT 0 THEN para_step[whupeg] = para_step[whupeg] < 0
                
;; Respect the limits.  If a step were to go out of bounds, then
;; we should take a step in the same direction but shorter distance.
;; The step should take us right to the limit in that case.
                factor = DBLARR(nterms) + 1.
                whl = WHERE((ABS(para_step) GT EPS) AND qllim AND (a_free + para_step LT llim), lct)
                IF lct GT 0 THEN $
                factor(whl) = MIN([factor(whl), (llim(whl)-a_free(whl))/para_step(whl)])
                whu = WHERE((ABS(para_step) GT EPS) AND qulim AND (a_free + para_step GT ulim), uct)
                IF uct GT 0 THEN $
                factor(whu) = MIN([factor(whu), (ulim(whu)-a_free(whu))/para_step(whu)])
;; Adjust the step according to any boundaries
                para_step = para_step * factor

;*Calculate new parameters*********************************************************
                b               = a_free + para_step
;; If the step put us exactly on a boundary, make sure it is exact
; Is this really needed ? I will comment it out first to see what happens.
;                IF lct GT 0 THEN b(whl) = llim(whl)
;                IF uct GT 0 THEN b(whu) = ulim(whu)
;**************************************************************************
		b_all		=	a
		b_all(WHERE(indx)) =	b 
;*Evaluate function********************************************************
		CALL_PROCEDURE, function_name, x, b_all, yfit, FUNC_EXTRA=func_extra
;*New chisqr***************************************************************
		chisqr	=	TOTAL(weights*(y-yfit)^2)/nfree
; stop fit, when necessary, with keyboard...
                IF (STRLOWCASE(GET_KBRD(0)) EQ 'q') THEN BEGIN
                    MESSAGE, 'Fit stopped', /INFORMATIONAL
                    all_done = 1
                ENDIF 
; ************************************************************************
		IF all_done THEN GOTO, done
		IF ((plot_during EQ 1) AND (((iter1+kill_loop) MOD itercount) EQ 0)) THEN $
                  CALL_PROCEDURE, iterproc, x, y, $
                  1/SQRT(weights), yfit, PARA=b_all, ITER1=[iter1,kill_loop], $
                  CHISQR=chisqr,func_extra=func_extra
                flambda		=	flambda*10. 
		kill_loop	=	kill_loop+1
		IF (kill_loop GE 200) THEN BEGIN
		 MESSAGE, 'Failed to converge, > 200 loops', /INFORMATIONAL
		 GOTO,done
		ENDIF
	 ENDREP UNTIL ((chisqr-chisq1)/chisq1 LE 0.001)
;*Decrease flambda by factor of 10***************************************
	 flambda	=	flambda/100.
;*Save new parameter estimate.*******************************************
	 a		=	b_all
;*Finished?**************************************************************
	 IF ((chisq1-chisqr)/chisq1) LE tol THEN GOTO,done
;*End of iteration loop**************************************************
	ENDFOR
	MESSAGE, 'Failed to converge, max. iterations reached', /INFORMATIONAL
done:  

        CM	                =	DBLARR(nterms,nterms)
	sigma			=	DBLARR(N_ELEMENTS(a))
;*Return sigma's (66.6% confidence interval)*************************************
	sigma(WHERE(indx))	=	SQRT(covar(diag))*SQRT(chisqr)
;*Return Correlation matrix*********************************************
        CM                      =       covar/(sigma # sigma) * chisqr

; If you like to return the standard deviations instead of the
; confidence interval, ,replace the last two lines with the following:
;	sigma(WHERE(indx))	=	SQRT(covar(diag))
;       CM                      =       covar/(sigma # sigma)

;*Return chi-squared****************************************************
	chisq = chisqr
;*Return result*********************************************************
	RETURN,yfit
END
