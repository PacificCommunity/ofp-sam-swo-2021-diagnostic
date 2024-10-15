#!/bin/sh

# -----------------------------------
#  PHASE 0 - create initial par file
# -----------------------------------

mfclo64 swo.frq swo.ini 00.par -makepar

# -----------------------
#  PHASE 1 - initial par
# -----------------------

mfclo64 swo.frq 00.par 01.par -file - <<PHASE1
# Set control phase: keep growth parameters fixed use
  1 32 6
  1 16 1      # estimate scalar of length dependent SD
  1 387 1     # use ADMB parameter scaling consistent with v2070
# Population scaling
  2 32 1      # estimate the totpop parameter
  2 177 1     # use old totpop scaling method
# Initial population
  2 94 2      # initial pop strategy based upon Z
  2 95 2      # initial age structure based on Z for first 2 calendar years
# Recruitment
  2 30 1      # estimate total recruitment devs (temporal)
  1 149 100   # recruitment deviations penalty
  2 57 1      # set number of recruitments per year to 1
  2 178 1     # set constraint on sum_reg (reg_rec_diff * pop_delta) = 1 for all t
  # exclude estimation of temporal recruitment for terminal time period
  1 400 2     # exclude 2 terminal time period to estimate rec devs
  1 398 1     # geometric mean for parest_flags(400)
# Steepness
  2 162 0     # no estimation of steepness
# Spawning potential
  2 188 2     # turn on length at maturity
# Movement
  2 69 1      # set generic movement option (now default)
# Fishing mortality max
  2 116 70    # default value for rmax in the catch equations
# Size data likelihood assumptions
  1 141 3     # set likelihood function for LF data to normal
  1 139 3     # set likelihood function for WF data to normal
# Relative weight of size data
  -999 49 20  # divide LL LF sample sizes by 20
    -3 49 10  # except for fishery 3
    -9 49 10  # except for fishery 9
  -999 50 20  # divide LL WF sample sizes by 20
# Selectivity section
  -999 26 2   # set age-dependent selectivity option
  # use cubic spline selectivity for all fleets
  -999 57 3
  # default number of nodes used in the cubic spline
  -999 61 3
   -3 61 5    # except for fishery 3 which has 5 nodes
   -9 61 5    # except for fishery 9 which has 5 nodes
  -14 61 5
  -15 61 5
  -16 61 5
  # first age class for common terminal selectivity
  -999 3 16
  # define non decreasing selectivity
   -9 16 1
  -14 16 1
  -15 16 1
  -16 16 1
  # define ages for zero selectivity after age defined by ff3
  -8 16 2
  # define number of breaks in time block selectivity
  -4 71 1
  # number of age classes starting from zero where selectivity is 0
  -2 75 1
  -9 75 6
  # grouping of fisheries with common selectivity
   -1 24 1
   -2 24 2
   -3 24 3
   -4 24 4
   -5 24 5
   -6 24 6
   -7 24 7
   -8 24 8
   -9 24 9
  -10 24 10
  -11 24 5
  -12 24 11
  -13 24 12
  -14 24 13
  -15 24 14
  -16 24 15
# Effort deviates section
  # set penalties for effort deviations
  # negative penalties force effort devs to be zero when catch is unknown
  # higher for longline fisheries where effort is standardized
  -999 13 1
    -2 13 1
    -4 13 1
    -7 13 1
    -8 13 1
   -11 13 1
  # use time varying effort weight for LL fisheries with standardized effort
  -999 66 1
    -2 66 1
    -4 66 1
    -7 66 1
    -8 66 1
   -11 66 1
# Catchability section
  -999 15 50  # set penalties for catchability deviations
  # set grouping of fisheries with common catchability at start of time series
   -1 60 1
   -2 60 2
   -3 60 3
   -4 60 4
   -5 60 5
   -6 60 6
   -7 60 7
   -8 60 8
   -9 60 9
  -10 60 10
  -11 60 11
  -12 60 12
  -13 60 13
  -14 60 14
  -15 60 15
  -16 60 16
  # grouping of fisheries with common catchability
   -1 29 1
   -2 29 2
   -3 29 3
   -4 29 4
   -5 29 5
   -6 29 6
   -7 29 7
   -8 29 8
   -9 29 9
  -10 29 10
  -11 29 11
  -12 29 12
  -13 29 13
  -14 29 14
  -15 29 15
  -16 29 16
PHASE1

# ---------
#  PHASE 2
# ---------

mfclo64 swo.frq 01.par 02.par -file - <<PHASE2
  1 1 1000    # set max number of function evaluations per phase to 1000
  1 50 -2     # set convergence criterion to 1E-02
  2 113 0     # scaling init pop - turned off
  1 149 100   # set penalty on recruitment devs
  -999 4 4    # estimate effort deviates
  1 190 1     # write plot.rep files
  -999 14 10  # penalties to stop F blowing out
  2 35 10     # set effdev bounds to +- 10 (need to do AFTER phase 1)
  -999 45 100000  # increase weight on catch likelihood
   -14 45 10000
   -15 45 10000
   -16 45 10000
PHASE2

# ---------
#  PHASE 3
# ---------

mfclo64 swo.frq 02.par 03.par -file - <<PHASE3
  2 70 1    # activate parameters for time series variability in regional recruitment distribution
  2 71 1    # estimation of temporal changes in recruitment distribution
  2 110 50  # set penalty for recruitment deviates
  -14 45 50000
  -15 45 50000
  -16 45 50000
PHASE3

# ---------
#  PHASE 4
# ---------

mfclo64 swo.frq 03.par 04.par -file - <<PHASE4
  2 68 0  # do not estimate movement
  -14 45 100000
  -15 45 100000
  -16 45 100000
PHASE4

# ---------
#  PHASE 5
# ---------

mfclo64 swo.frq 04.par 05.par -file - <<PHASE5
  -999 27 0  # estimate seasonal catchability for all fisheries
  -14 27 1
  -15 27 1
  -16 27 1
PHASE5

# ---------
#  PHASE 6
# ---------

mfclo64 swo.frq 05.par 06.par -file - <<PHASE6
  -999 10 0  # do not estimate time-varying catchability
PHASE6

# ---------
#  PHASE 7
# ---------

mfclo64 swo.frq 06.par 07.par -file - <<PHASE7
  -100000 1 1  # estimate average proportion of recruitment coming from each region
  -100000 2 1
PHASE7

# ---------
#  PHASE 8
# ---------

mfclo64 swo.frq 07.par 08.par -file - <<PHASE8
  1 1 8000   # set max number of function evaluations per phase to 8000
  1 50 -3    # convergence criteria of 10^-3
  2 145 2    # define penalty weight on fit to SRR
  2 146 1    # estimate SRR parameters
  2 163 0    # use steepness parameterization of B&H SRR
  2 161 1    # set bias correction of BH SRR
  1 149 0    # remove penalty on recruitment devs
  2 147 1    # time period between spawning and recruitment must be set to at least 1 to avoid issue with recruitment in the projection period
  2 148 5    # number of years from last time period to compute average F
  2 155 1    # omit the last year from average F calculation
  2 200 2    # exclude terminal 2 time periods(years) for estimation of BevHolt SRR
  2 199 68   # BevHolt SRR calculation begins in first model period; 1952
  -999 55 1  # no-fishing calcs
  2 171 1    # include SRR-based equilibrium recruitment to compute unfished biomass
  1 186 1    # write fishmort and plotq0.rep
  1 187 1    # write temporary_tag_report
  1 188 1    # write ests.rep
  1 189 1    # write .fit files
PHASE8

# ---------
#  PHASE 9
# ---------

mfclo64 swo.frq 08.par 09.par -file - <<PHASE9
  1 1 10000  # set maximum function evaluations to 10000
  1 50 -6    # set convergence criteria from this phase
PHASE9

# ----------
#  PHASE 10
# ----------

mfclo64 swo.frq 09.par 10.par -file - <<PHASE10
  1 1 10000  # set maximum function evaluations to 10000
  1 50 -6    # set convergence criteria from this phase
PHASE10

# ----------
#  PHASE 11
# ----------

mfclo64 swo.frq 10.par 11.par -file - <<PHASE11
  1 1 10000  # set maximum function evaluations to 10000
  1 50 -6    # set convergence criteria from this phase
PHASE11

# ----------
#  PHASE 12
# ----------

mfclo64 swo.frq 11.par 12.par -file - <<PHASE12
  1 1 10000  # set maximum function evaluations to 10000
  1 50 -6    # set convergence criteria from this phase
PHASE12

# ----------
#  PHASE 13
# ----------

mfclo64 swo.frq 12.par 13.par -file - <<PHASE13
  1 1 10000  # set maximum function evaluations to 10000
  1 50 -6    # set convergence criteria from this phase
PHASE13

# ----------
#  PHASE 14
# ----------

mfclo64 swo.frq 13.par 14.par -file - <<PHASE14
  1 1 10000  # set maximum function evaluations to 10000
  1 50 -6    # set convergence criteria from this phase
PHASE14

# ----------
#  PHASE 15
# ----------

mfclo64 swo.frq 14.par 15.par -file - <<PHASE15
  1 1 10000  # set maximum function evaluations to 10000
  1 50 -6    # set convergence criteria from this phase
PHASE15

# ----------
#  PHASE 16
# ----------

mfclo64 swo.frq 15.par 16.par -file - <<PHASE16
  1 1 10000  # set maximum function evaluations to 10000
  1 50 -6    # set convergence criteria from this phase
PHASE16

# ----------
#  PHASE 17
# ----------

mfclo64 swo.frq 16.par junk -switch 2 1 1 1 1 145 3  # compute Hessian and derivatives for dependent variables
mfclo64 swo.frq 16.par junk -switch 2 1 1 1 1 145 4  # produce stdev report (.var)
mfclo64 swo.frq 16.par junk -switch 2 1 1 1 1 145 5  # produce correlation report (.cor)
rm junk plot-junk.rep
