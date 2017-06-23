#**************************************************************************************
# test_Calculations.jl
# =============== part of the GeoEfficiency.jl package.
# 
# this file contains all the required function to test calculate the Geometrical efficiency.
#
#**************************************************************************************



@testset "Calculations" begin

	print("\t"); info("polnomial test of function `integrate`")
	function poly(z::Float64, coff::Vector{Float64})
	res::Float64 = 0.0
	for i= 1:length(coff)
		res += coff[i]*z^(i-1)
	end #for
	return res
	end #function_poly
	
	@test  poly(4., [10., 20., 30.]) ≈ @evalpoly(4.0 , 10., 20., 30.)
	poly0(z::Float64) = poly(z, [1.0])
	poly1(z::Float64) = poly(z, [1.0, 2.0])
	poly2(z::Float64) = poly(z, [1.0, 2.0, 3.0])	
	
	@testset "integrate" for str = [-0.2 , -0.1, 0.0, 1.0, 2.0, 3.0 ], nd = [-0.2 , -0.1, 0.0, 1.0, 2.0, 3.0 ]

		@test G.integrate(poly0, str, nd)[1] ≈ @evalpoly(nd, 0.0, 1.0) - @evalpoly(str, 0.0, 1.0)
		@test G.integrate(poly1, str, nd)[1] ≈ @evalpoly(nd, 0.0, 1.0, 1.0) - @evalpoly(str, 0.0, 1.0, 1.0)
		@test G.integrate(poly2, str, nd)[1] ≈ @evalpoly(nd, 0.0, 1.0, 1.0, 1.0) - @evalpoly(str, 0.0, 1.0, 1.0, 1.0)
		
	end #testset_begin
	
	print("\t"); info("special cases for cylinderical detector; very restrict test")
	@testset "point at the surface of cylinderical detector of radius $radius cm" for 
		radius in [1,2,3,4,5,6,7,8,9,10.1,10.5,10.6]
		acylDetector = CylDetector(radius)
			
		@test geoEff(acylDetector, Point(0)) ≈ 0.5
		@test geoEff(acylDetector, Point(0, radius-eps(radius))) ≈ 0.5
		@test geoEff(acylDetector, Point(0, -radius+eps(radius))) ≈ 0.5
		@test geoEff(acylDetector, Point(0, radius/2-eps(radius))) ≈ 0.5
		@test geoEff(acylDetector, Point(0, -radius/2+eps(radius))) ≈ 0.5
	
		@test geoEff(acylDetector, Point(eps())) ≈ 0.5
		@test geoEff(acylDetector, Point(eps(), radius-eps(radius))) ≈ 0.5
		@test geoEff(acylDetector, Point(eps(), -radius+eps(radius))) ≈ 0.5	
		@test geoEff(acylDetector, Point(eps(), radius/2-eps(radius))) ≈ 0.5
		@test geoEff(acylDetector, Point(eps(), -radius/2+eps(radius))) ≈ 0.5

	end #for_testset
	
	print("\t"); info("special cases for cylinderical detector also; very restrict test")
	@testset "point at the surface of cylinderical detector of radius $radius cm" for 
		radius in [1,2,3,4,5,6,7,8,9,10.1,10.5,10.6]
		acylDetector = CylDetector(radius)
			
		@test geoEff(acylDetector, Point(0), 0) ≈ 0.5
		@test geoEff(acylDetector, Point(0, radius-eps(radius)), 0) ≈ 0.5
		@test geoEff(acylDetector, Point(0, -radius+eps(radius)), 0) ≈ 0.5
		@test geoEff(acylDetector, Point(0, radius/2-eps(radius)), 0) ≈ 0.5
		@test geoEff(acylDetector, Point(0, -radius/2+eps(radius)), 0) ≈ 0.5
	
		@test geoEff(acylDetector, Point(eps())) ≈ 0.5
		@test geoEff(acylDetector, Point(eps(), radius-eps(radius)), 0) ≈ 0.5
		@test geoEff(acylDetector, Point(eps(), -radius+eps(radius)), 0) ≈ 0.5	
		@test geoEff(acylDetector, Point(eps(), radius/2-eps(radius)), 0) ≈ 0.5
		@test geoEff(acylDetector, Point(eps(), -radius/2+eps(radius)), 0) ≈ 0.5

	end #for_testset

end #testset


@testset "special cases for well detector" begin

	print("\t"); info("special cases for well detector")
	@testset "point at the surface of Well detector of radius $radius cm and height $height" for 
		radius=[1,2,3,4,5,6,7,8,9,10.1,10.5,10.6], 
		height=[1,2,3,4,5,6,7,8,9,10.1,10.5,10.6], 
		k=[1.1,2,3,4,5,6,7,8,9,10.1,10.5,10.6]
		
		welldepth::Float64 = height/k		# k > 1
		holeradius::Float64 = radius/k		# k > 1
		awellDetector = WellDetector(radius,height,holeradius, welldepth)
	
		@test geoEff(awellDetector, Point(welldepth)) ≈ 0.5
		@test geoEff(awellDetector, Point(welldepth, holeradius-eps(holeradius))) ≈ 0.5
		@test geoEff(awellDetector, Point(welldepth, -holeradius+eps(holeradius))) ≈ 0.5
		@test geoEff(awellDetector, Point(welldepth, holeradius/2-eps(holeradius))) ≈ 0.5
		@test geoEff(awellDetector, Point(welldepth, -holeradius/2+eps(holeradius))) ≈ 0.5
	
		@test geoEff(awellDetector, Point(welldepth+eps(welldepth))) ≈ 0.5
		@test geoEff(awellDetector, Point(welldepth+eps(welldepth), holeradius-eps(holeradius))) ≈ 0.5
		@test geoEff(awellDetector, Point(welldepth+eps(welldepth), -holeradius+eps(holeradius))) ≈ 0.5
		@test geoEff(awellDetector, Point(welldepth+eps(welldepth), holeradius/2-eps(holeradius))) ≈ 0.5
		@test geoEff(awellDetector, Point(welldepth+eps(welldepth), -holeradius/2+eps(holeradius))) ≈ 0.5

	end #for_testset	

end #testset


@testset "scaling test" begin

	print("\t"); info("statrting scaling test cylinderical detector with point source...")
	@testset "[$(k*(j-1))] test, Scalling $k at cryRadius $cryRadius cm" for 
		cryRadius=[1,2,3,4,5,6,7,8,9,10.1,10.5,10.6],
		j=2:100, 
		k=2:100
		acylDetector = CylDetector(cryRadius); acylDetectork = CylDetector(cryRadius*k)

		@test geoEff(acylDetector, Point(cryRadius/j)) ≈ geoEff(acylDetectork, Point(k*cryRadius/j))

		@test geoEff(acylDetector, Point(cryRadius*j, cryRadius/j)) ≈ geoEff(acylDetectork, Point(k*cryRadius*j, k*cryRadius/j))

	end #for_testset
	
	print("\t"); info("statrting scaling test Borehole detector with point source...")
	@testset "[$(k*(j-1))] test, Scalling $k at cryRadius $cryRadius cm" for 
		cryRadius=[1,2,3,4,5,6,7,8,9,10.1,10.5,10.6],
		holeRadius=[1,2,3,4,5,6,7,8,9,10.1,10.5,10.6]/2,
		j=2:100, 
		k=2:100
		
		holeRadius < cryRadius || continue
		
		aboreDetector = BoreDetector(cryRadius, j, holeRadius); aboreDetectork = BoreDetector(cryRadius*k,j*k, holeRadius*k)

		@test geoEff(aboreDetector, Point(cryRadius/j)) ≈ geoEff(aboreDetectork, Point(k*cryRadius/j))

		@test geoEff(aboreDetector, Point(cryRadius*j, holeRadius/j)) ≈ geoEff(aboreDetectork, Point(k*cryRadius*j, k*holeRadius/j))

	end #for_testset

	print("\t"); info("statrting scaling test Well-type detector with point source...")
	@testset "[$(k*(j-1))] test, Scalling $k at cryRadius $cryRadius cm" for 
		cryRadius=[1,2,3,4,5,6,7,8,9,10.1,10.5,10.6],
		holeRadius=[1,2,3,4,5,6,7,8,9,10.1,10.5,10.6]/2,
		j=2:100, 
		k=2:100
		
		holeRadius < cryRadius || continue
		
		awellDetector =WellDetector(cryRadius, j, holeRadius, j/2.0); awellDetectork = WellDetector(cryRadius*k,j*k, holeRadius*k, j*k/2.0)

		@test geoEff(awellDetector, Point(cryRadius/j)) ≈ geoEff(awellDetectork, Point(k*cryRadius/j))

		@test geoEff(awellDetector, Point(cryRadius*j, holeRadius/j)) ≈ geoEff(awellDetectork, Point(k*cryRadius*j, k*holeRadius/j))

	end #for_testset	
end #testset

