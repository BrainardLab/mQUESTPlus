function predictedProportions = qpPFCircular(stimParams,psiParams)
% qpPFCircular  Psychometric function for categorization of a circular variable
%
% Usage:
%     predictedProportions = qpPFCircular(stimParams,psiParams)
%
% Description:
%     Compute the proportions of each outcome for categorization on a circle.
%
%     This code parameterizes the boundaries as boundaries, rather
%     than first boundary and widths as in Mathematica code.
%
%     This could deal more robustly with wrapping issues and argument
%     checking. It is good enough to allow the demo to run, but maybe
%     not for real work.
%
% Inputs:
%     stimParams     Matrix, with each row being a vector of stimulus parameters.
%                    Here that "row vector" is just a single number giving
%                    the stimulus angle in radians
%
%     psiParams      Row vector of parameters.  Each row has.
%                      concentration       Mean of normal
%                      boundaries          N-1 angles giving category boundaries in radians.
%                                          Reponse 1 corresponds to boundary1 <= stim < boundary2.
%                                          Response N corresponds to boundaryN-1 <= stim < boundary1,
%                                          Boundaries must be in increasing order.  Otherwise this
%                                          routine returns a vector of NaN.
%
% Output:
%     predictedProportions  Matrix, where each row is a vector of predicted proportions
%                           for each outcome.
%                             First entry of each row is for first category (outcome == 1)
%                             Second entry of each row is second category (outcome == 2)
%                             Nth entry is for nth category (outcome -- n)
%
% Optional key/value pairs
%     None

% 07/07/17  dhb  Wrote it.

%% Parse input
%
% This routine gets called many many times and should be as fast as
% possible.  The input parser is slow.  So we forego arg checking and
% optional key/value pairs.  The code below shows how they would look.
%
% p = inputParser;
% p.addRequired('stimParams',@isnumeric);
% p.addRequired('psiParams',@isnumeric);
% p.parse(stimParams,psiParams,varargin{:});

%% Here is the Matlab version
if (size(psiParams,2) < 2)
    error('Parameters vector has wrong length for qpPFCircular');
end
if (size(stimParams,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end
if (any(stimParams < 0 | stimParams > 2*pi))
    error('Stimuli must be greater than or equal to zero and less than 2*pi');
end

%% Grab params
concentration = psiParams(:,1);
nStim = size(stimParams,1);

%% Filter out redundant parameters from grid
%
% This is signaled by returning NaN when the boundaries are
% not in increasing order.
[boundaries,sortIndex] = sort(psiParams(:,2:end),'ascend');
nOutcomes = length(boundaries);
if (any(sortIndex ~= 1:nOutcomes))
    predictedProportions = NaN*ones(nStim,nOutcomes);
    return;
end

%% Check that boundaries are within the circle, within tolerance.
if (any(boundaries < 0-1e-7 | boundaries > 2*pi+1e-7))
    error('Passed boundaries must be greater than or equal to zero and less than 2*pi');
end

% Convert to -pi origin for boundaries and stimuli for our internal calculations
stimParams = stimParams - pi;
boundaries = boundaries - pi;

%% Compute
%
% This is not terribly efficient, yet.
predictedProportions = zeros(nStim,nOutcomes);
for ii = 1:nStim
    prevProportion0 = von_mises_cdf(boundaries(1),stimParams(ii),concentration);
    prevProportion = prevProportion0;
    predictedProportions(ii,1) = von_mises_cdf(boundaries(2),stimParams(ii),concentration) - prevProportion;
    prevProportion = prevProportion + predictedProportions(ii,1);
    for jj = 2:nOutcomes-1
        predictedProportions(ii,jj) = von_mises_cdf(boundaries(jj+1),stimParams(ii),concentration) - prevProportion;
        prevProportion = prevProportion + predictedProportions(ii,jj);
    end
    predictedProportions(ii,nOutcomes) = von_mises_cdf(2*pi,stimParams(ii),concentration) - prevProportion + prevProportion0;
    predictedProportions(ii,:) = predictedProportions(ii,:)/sum(predictedProportions(ii,:));
end

end

% %% The CircStat2012a toolbox doesn't have a von Mises cdf
% %
% % But this was posted in the comments section.
% %
% % It integrates the pdf from an angle of 0 to an angle alpha.
% function p = circ_vmcdf(alpha, mean, kappa)
% F = @(x)circ_vmpdf(x, mean, kappa);
% p = quad(F,0,alpha);
% end



function cdf = von_mises_cdf ( x, a, b )
%% VON_MISES_CDF evaluates the von Mises CDF.
%
%  Discussion:
%
%    Thanks to Cameron Huddleston-Holmes for pointing out a discrepancy
%    in the MATLAB version of this routine, caused by overlooking an
%    implicit conversion to integer arithmetic in the original FORTRAN,
%    JVB, 21 September 2005.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    17 November 2006
%
%  Author:
%
%    Geoffrey Hill
%
%    MATLAB translation by John Burkardt.
%
%  Reference:
%
%    Geoffrey Hill,
%    ACM TOMS Algorithm 518,
%    Incomplete Bessel Function I0: The von Mises Distribution,
%    ACM Transactions on Mathematical Software,
%    Volume 3, Number 3, September 1977, pages 279-284.
%
%    Kanti Mardia, Peter Jupp,
%    Directional Statistics,
%    Wiley, 2000, QA276.M335
%
%  Parameters:
%
%    Input, real X, the argument of the CDF.
%    A - PI <= X <= A + PI.
%
%    Input, real A, B, the parameters of the PDF.
%    -PI <= A <= PI,
%    0.0 < B.
%
%    Output, real CDF, the value of the CDF.
%
  a1 = 12.0;
  a2 = 0.8;
  a3 = 8.0;
  a4 = 1.0;
  c1 = 56.0;
  ck = 10.5;
%
%  We expect -PI <= X - A <= PI.
%
  if ( x - a <= -pi )
    cdf = 0.0;
    return
  end

  if ( pi <= x - a )
    cdf = 1.0;
    return
  end
%
%  Convert the angle (X - A) modulo 2 PI to the range ( 0, 2 * PI ).
%
  z = b;

  u = mod ( x - a + pi, 2.0 * pi );

  if ( u < 0.0 )
    u = u + 2.0 * pi;
  end

  y = u - pi;
%
%  For small B, sum IP terms by backwards recursion.
%
  if ( z <= ck )

    v = 0.0;

    if ( 0.0 < z )

      ip = floor ( z * a2 - a3 / ( z + a4 ) + a1 );
      p = ip;
      s = sin ( y );
      c = cos ( y );
      y = p * y;
      sn = sin ( y );
      cn = cos ( y );
      r = 0.0;
      z = 2.0 / z;

      for n = 2 : ip
        p = p - 1.0;
        y = sn;
        sn = sn * c - cn * s;
        cn = cn * c + y * s;
        r = 1.0 / ( p * z + r );
        v = ( sn / p + v ) * r;
      end

    end

    cdf = ( u * 0.5 + v ) / pi;
%
%  For large B, compute the normal approximation and left tail.
%
  else

    c = 24.0 * z;
    v = c - c1;
    r = sqrt ( ( 54.0 / ( 347.0 / v + 26.0 - c ) - 6.0 + c ) / 12.0 );
    z = sin ( 0.5 * y ) * r;
    s = 2.0 * z * z;
    v = v - s + 3.0;
    y = ( c - s - s - 16.0 ) / 3.0;
    y = ( ( s + 1.75 ) * s + 83.5 ) / v - y;
    arg = z * ( 1.0 - s / y^2 );
    erfx = r8_error_f ( arg );
    cdf = 0.5 * erfx + 0.5;

  end

  cdf = max ( cdf, 0.0 );
  cdf = min ( cdf, 1.0 );

  return
end

