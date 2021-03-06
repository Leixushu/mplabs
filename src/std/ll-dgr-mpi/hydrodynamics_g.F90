!-------------------------------------------------------------------------------
! Subroutine : HydrodynamicsG
! Revision   : 1.0 (2008-06-15)
! Author     : Carlos Rosales Fernandez [carlos.rosales.fernandez(at)gmail.com]
!-------------------------------------------------------------------------------
!> @file
!! Calculate velocity and pressure using gbar
!> @details
!! Calculate the velocity and the pressure in the pressure grid based on the
!! values of pressure (gbar) distribution function after the streaming step for
!! the parallel dual grid D2Q9 Lee-Lin multiphase LBM.

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

 SUBROUTINE HydrodynamicsG

! Common Variables
 USE NTypes,    ONLY : DBL
 USE Domain
 USE FluidParams
 USE LBMParams
 IMPLICIT NONE

! Local Variables
 INTEGER :: i, j
 REAL(KIND = DBL) :: invRho

! Velocity calculation
 DO j = yl, yu
   DO i = xl, xu

   invRho = 1.D0/rho(i,j)

     u(i,j,1) = invRho*( gbar(i,j,1) - gbar(i,j,3) + gbar(i,j,5) - gbar(i,j,6) &
              - gbar(i,j,7) + gbar(i,j,8) + 0.5D0*GX(i,j) )

     u(i,j,2) = invRho*( gbar(i,j,2) - gbar(i,j,4) + gbar(i,j,5) + gbar(i,j,6) &
              - gbar(i,j,7) - gbar(i,j,8) + 0.5D0*GY(i,j) )

   END DO
 END DO

! Pressure calculation
 DO j = yl, yu
   DO i = xl, xu

     p(i,j) = Cs_sq*( gbar(i,j,0) + gbar(i,j,1) + gbar(i,j,2) + gbar(i,j,3)       &
            + gbar(i,j,4) + gbar(i,j,5) + gbar(i,j,6) + gbar(i,j,7) + gbar(i,j,8) &
            + 0.5D0*( u(i,j,1)*gradRhoX(i,j) + u(i,j,2)*gradRhoY(i,j) ) )

   END DO
 END DO

 RETURN
 END SUBROUTINE HydrodynamicsG
