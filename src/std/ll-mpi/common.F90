!-------------------------------------------------------------------------------
! File     : Common
! Revision : 1.0 (2008-06-15)
! Author   : Carlos Rosales Fernandez [carlos.rosales.fernandez(at)gmail.com]
!-------------------------------------------------------------------------------
!> @file
!! Modules that contain common variables

!-------------------------------------------------------------------------------
! Copyright 2008 Carlos Rosales Fernandez, David S. Whyte and IHPC (A*STAR).
!
! This file is part of MP-LABS.
!
! MP-LABS is free software: you can redistribute it and/or modify it under the
! terms of the GNU GPL version 3 or (at your option) any later version.
!
! MP-LABS is distributed in the hope that it will be useful, but WITHOUT ANY
! WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
! A PARTICULAR PURPOSE. See the GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License along with
! MP-LABS, in the file COPYING.txt. If not, see <http://www.gnu.org/licenses/>.
!-------------------------------------------------------------------------------

!> @brief Definition of single and double data types
 MODULE NTypes
 IMPLICIT NONE
 SAVE

 INTEGER, PARAMETER :: SGL = KIND(1.0)
 INTEGER, PARAMETER :: DBL = KIND(1.D0)

 END MODULE NTypes

!> @brief Parameters related to the geometry and the time intervals
 MODULE Domain
 USE NTypes, ONLY : DBL
 IMPLICIT NONE
 SAVE

! Maximum time of steps and data dump times
 INTEGER :: MaxStep, RelaxStep, iStep, tCall, tDump, tStat

! Domain size
 INTEGER :: xmin, xmax, ymin, ymax
 INTEGER :: xl, xu, yl, yu
 INTEGER :: xlg, xug, ylg, yug
 INTEGER :: xlg2, xug2, ylg2, yug2
 INTEGER :: xlg3, xug3, ylg3, yug3
 INTEGER :: xsize, xsize2, xsize3, ysize, ysize2, ysize3
 INTEGER :: NX, NY

! ndim = spatial dimension
 INTEGER, PARAMETER :: ndim = 2

! Array for the near neighbor
 INTEGER, ALLOCATABLE, DIMENSION(:,:,:) :: ni

! Initial volume of the secondary phase
 REAL(KIND = DBL) :: invInitVol

! Define constants used in the code (inv6 = 1/6, inv12 = 1/12, invPi = 1/pi)
 REAL(KIND = DBL), PARAMETER :: inv6  = 0.16666666666666666667D0
 REAL(KIND = DBL), PARAMETER :: inv12 = 0.08333333333333333333D0
 REAL(KIND = DBL), PARAMETER :: invPi = 0.31830988618379067154D0

 END MODULE Domain

!> @brief Parameters related to hydrodynamics quantities
 MODULE FluidParams
 USE NTypes, ONLY : DBL
 IMPLICIT NONE
 SAVE

 INTEGER :: nBubbles
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:,:) :: bubbles
 REAL(KIND = DBL), DIMENSION(1:11) :: Convergence
 REAL(KIND = DBL) :: sigma, IntWidth
 REAL(KIND = DBL) :: beta, beta4, kappa, kappa_6, kappa_12
 REAL(KIND = DBL) :: rhoL, rhoH, rhoStar, tauL, tauH, tauRhoStar
 REAL(KIND = DBL) :: eps, pConv, muL, muH

! Arrays for the pressure and the velocity
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:,:)   :: p
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:,:,:) :: u

! Arrays for chemical potential psi, density rho and its differential terms
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:,:) :: psi, rho
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:,:) :: gradRhoX, gradRhoY, gradRhoSq
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:,:) :: gradRhoXX, gradRhoXY, gradRhoYY

 END MODULE FluidParams

!> @brief Parameters related to the LBM discretization
 MODULE LBMParams
 USE NTypes, ONLY : DBL
 IMPLICIT NONE
 SAVE

! fdim = order parameter distribution dimension - 1 (D2Q9)
! gdim = pressure distribution dimension - 1        (D2Q9)
 INTEGER, PARAMETER :: fdim = 8
 INTEGER, PARAMETER :: gdim = 8

! Distribution functions
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:,:,:) :: f, fbar
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:,:,:) :: g, gbar

! D2Q9 Lattice speed of sound (Cs = 1/DSQRT(3), Cs_sq = 1/3, invCs_sq = 3)
 REAL(KIND = DBL), PARAMETER :: Cs       = 0.57735026918962576451D0
 REAL(KIND = DBL), PARAMETER :: Cs_sq    = 0.33333333333333333333D0
 REAL(KIND = DBL), PARAMETER :: invCs_sq = 3.00000000000000000000D0

! Distributions weights (D2Q9: W0 = 4/9, W1 = 1/9, W2 = 1/36)
 REAL(KIND = DBL), PARAMETER :: W0 = 0.44444444444444444444D0
 REAL(KIND = DBL), PARAMETER :: W1 = 0.11111111111111111111D0
 REAL(KIND = DBL), PARAMETER :: W2 = 0.02777777777777777778D0

! Modified distribution weight (to avoid operations: WiC = Wi*invCs_sq)
 REAL(KIND = DBL), PARAMETER :: W0C = 1.33333333333333333333D0
 REAL(KIND = DBL), PARAMETER :: W1C = 0.33333333333333333333D0
 REAL(KIND = DBL), PARAMETER :: W2C = 0.08333333333333333333D0

 END MODULE LBMParams

!> @brief MPI related parameters and information exchange buffer arrays
!> @details
!! @param nprocs  : total number of processors
!! @param proc    : processor ID
!! @param vproc   : processor ID in virtual grid
!! @param mpi_dim : virtual grid partition scheme (1->stripes, 2->boxes, 3->cubes)
 MODULE MPIParams
 USE NTypes, ONLY : DBL
 IMPLICIT NONE
 SAVE

! Communication parameters
 INTEGER :: nprocs, proc, vproc
 INTEGER :: mpi_xdim, mpi_ydim
 INTEGER :: east, west, north, south, ne, nw, se, sw, MPI_COMM_VGRID
 INTEGER, PARAMETER :: TAG1 = 1, TAG2 = 2, TAG3 = 3, TAG4 = 4
 INTEGER, PARAMETER :: master  = 0
 INTEGER, PARAMETER :: mpi_dim = 2

! Information exchange buffers (x direction)
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: f_west_snd, f_east_snd
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: f_west_rcv, f_east_rcv
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: g_west_snd, g_east_snd
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: g_west_rcv, g_east_rcv
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: rho_west_snd, rho_east_snd
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: rho_west_rcv, rho_east_rcv

! Information exchange buffers (y direction)
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: f_south_snd, f_north_snd
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: f_south_rcv, f_north_rcv
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: g_south_snd, g_north_snd
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: g_south_rcv, g_north_rcv
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: rho_north_snd, rho_south_snd
 REAL(KIND = DBL), ALLOCATABLE, DIMENSION(:) :: rho_north_rcv, rho_south_rcv

! Information exchange buffers (diagonals)
 REAL(KIND = DBL), DIMENSION(1:9) :: rho_ne_snd, rho_ne_rcv
 REAL(KIND = DBL), DIMENSION(1:9) :: rho_se_snd, rho_se_rcv
 REAL(KIND = DBL), DIMENSION(1:9) :: rho_nw_snd, rho_nw_rcv
 REAL(KIND = DBL), DIMENSION(1:9) :: rho_sw_snd, rho_sw_rcv
 REAL(KIND = DBL) :: g_ne_snd, g_ne_rcv, g_se_snd, g_se_rcv
 REAL(KIND = DBL) :: g_nw_snd, g_nw_rcv, g_sw_snd, g_sw_rcv
 REAL(KIND = DBL) :: f_ne_snd, f_ne_rcv, f_se_snd, f_se_rcv
 REAL(KIND = DBL) :: f_nw_snd, f_nw_rcv, f_sw_snd, f_sw_rcv

 END MODULE MPIParams
