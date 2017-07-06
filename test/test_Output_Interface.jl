#**************************************************************************************
# test_Output_Interface.jl
# ======================== part of the GeoEfficiency.jl package.
# 
# 
# 
#**************************************************************************************



@testset "Output Interface" begin
  
	@testset "\tfunction `calc` on CylDetector" begin 
	cryLength = 10
		@test calc(Detector(5,cryLength),(Point(1),1, 1))    == nothing
		@test calc(Detector(5,cryLength),(Point(1),1, 1//2)) == nothing
		@test calc(Detector(5,cryLength),(Point(1),1, pi))   == nothing
		@test calc(Detector(5,cryLength),(Point(1),1, 1.0))  == nothing

		@test calc(Detector(5,cryLength),(Point(1),1//2, 1))    == nothing
		@test calc(Detector(5,cryLength),(Point(1),1//2, 1//2)) == nothing
		@test calc(Detector(5,cryLength),(Point(1),1//2, pi))   == nothing
		@test calc(Detector(5,cryLength),(Point(1),1//2, 1.0))  == nothing

		@test calc(Detector(5,cryLength),(Point(1),e, 1))    == nothing
		@test calc(Detector(5,cryLength),(Point(1),e, 1//2)) == nothing
		@test calc(Detector(5,cryLength),(Point(1),e, pi))   == nothing #
		@test calc(Detector(5,cryLength),(Point(1),e, 1.0))  == nothing

		@test calc(Detector(5,cryLength),(Point(1),1.0, 1))    == nothing
		@test calc(Detector(5,cryLength),(Point(1),1.0, 1//2)) == nothing
		@test calc(Detector(5,cryLength),(Point(1),1.0, pi))   == nothing
		@test calc(Detector(5,cryLength),(Point(1),1.0, 1.0))  == nothing
     end #testset
	 
	@testset "\tfunction `calc` on WellDetector" begin 
	holeRadius = 3 
	holeDepth  = 2
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1, 1))    == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1, 1//2)) == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1, pi))   == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1, 1.0))  == nothing

		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1//2, 1))    == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1//2, 1//2)) == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1//2, pi))   == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1//2, 1.0))  == nothing

		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),e, 1))    == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),e, 1//2)) == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),e, pi))   == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),e, 1.0))  == nothing

		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1.0, 1))    == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1.0, 1//2)) == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1.0, pi))   == nothing
		@test calc(Detector(5, 4, holeRadius, holeDepth),(Point(1),1.0, 1.0))  == nothing
		end #testset_for

info("test `_batch` & `batch`...")    
	@testset "test `batch`" begin
		@test G._batch(Val{true},  CylDetector(eps()), [0.0], [0.0], [0.0], [0.0])[2][end] ≈ 0.5
		@test G._batch(Val{false}, CylDetector(eps()), [0.0], [0.0], [0.0], [0.0])[2][end] ≈ 0.5
		@test isnan(G._batch(Val{true}, CylDetector(eps()), [0.0], [1.0], [0.0],[0.0])[2][end])
		@test isnan(G._batch(Val{false}, CylDetector(eps()), [0.0], [1.0], [0.0],[0.0])[2][end])
		
		acylDetector = CylDetector(eps()); path = batch(acylDetector, [0.0])
		@test contains(path, G.id(acylDetector))
		@test readcsv(path)[2,end] ≈ 0.5		

		acylDetector = CylDetector(eps()); path = batch(acylDetector, [0.0], [0.0], [0.0],[0.0],false)
		@test contains(path, G.id(acylDetector))
		@test readcsv(path)[2,end] ≈ 0.5	
		
		acylDetector = CylDetector(eps()); path = batch([acylDetector], [0.0])
		@test contains(contains ,path, G.id(acylDetector))

		acylDetector = CylDetector(eps()); path = batch([acylDetector], [0.0], [0.0], [0.0],[0.0],false)
		@test contains(contains ,path, G.id(acylDetector))

		aBDetector = BoreDetector(5,4,3); path = batch([aBDetector], [0.0])
		@test contains(contains ,path, G.id(aBDetector))

		aWDetector = WellDetector(5,4,3, 2); path = batch([aWDetector], [0.0])
		@test contains(contains, path, G.id(aWDetector))
		
		path = batch([aWDetector], [0.0], [0.0], [0.0],[0.0],false)
		@test contains(contains ,path, G.id(aWDetector))

		path = batch([acylDetector, aWDetector], [0.0])
		@test contains(contains ,path, G.id(aWDetector))
		
		path = batch([acylDetector, aWDetector], [0.0], [0.0], [0.0],[0.0],false)
		@test contains(contains ,path, G.id(acylDetector))
		@test contains(contains ,path, G.id(aWDetector))

		path = batch([acylDetector, BoreDetector(5,4,3)], [0.0])
		@test contains(contains ,path, G.id(acylDetector))
		
		path = batch([acylDetector, aBDetector], [0.0], [0.0], [0.0],[0.0],false)
		@test contains(contains ,path, G.id(acylDetector))
		@test contains(contains ,path, G.id(aBDetector))

		path = batch([aBDetector, aWDetector], [0.0])
		@test contains(contains ,path, G.id(aBDetector))
		@test contains(contains ,path, G.id(aWDetector))
		
		path = batch([aBDetector, aWDetector], [0.0], [0.0], [0.0],[0.0],false)
		@test contains(contains ,path, G.id(aBDetector))
		@test contains(contains ,path, G.id(aWDetector))

		path = batch([acylDetector, aBDetector, aWDetector], [0.0]) 
		@test contains(contains ,path, G.id(acylDetector))
		@test contains(contains ,path, G.id(aBDetector))
		@test contains(contains ,path, G.id(aWDetector))
	chmod(path[1], 0o100444); chmod(path[2], 0o100444); chmod(path[3], 0o100444);
		path = batch([acylDetector, aBDetector, aWDetector], [0.0])
		@test contains(contains ,path, "_" * G.id(acylDetector))
		@test contains(contains ,path, "_" * G.id(aBDetector))
		@test contains(contains ,path, "_" * G.id(aWDetector))
	chmod(path[1],0o100666); chmod(path[2], 0o100666); chmod(path[3], 0o100666);
		
		path = batch([acylDetector, aBDetector, aWDetector], [0.0], [0.0], [0.0],[0.0],false)
		@test contains(contains ,path, G.id(acylDetector))
		@test contains(contains ,path, G.id(aBDetector))
		@test contains(contains ,path, G.id(aWDetector))
	chmod(path[1], 0o100444); chmod(path[2], 0o100444); chmod(path[3], 0o100444);
		path = batch([acylDetector, aBDetector, aWDetector], [0.0], [0.0], [0.0],[0.0],false)
		@test contains(contains ,path, "_" * G.id(acylDetector))
		@test contains(contains ,path, "_" * G.id(aBDetector))
		@test contains(contains ,path, "_" * G.id(aWDetector))
	chmod(path[1],0o100666); chmod(path[2], 0o100666); chmod(path[3], 0o100666);
		
		@test eltype(batch([eps() 0], [0.0])) === String
		@test eltype(batch([eps() 0], [0.0], [0.0], [0.0], [0.0],false)) === String
		@test eltype(batch([1.0 0], [0.0])) === String
		@test eltype(batch([1.0 0], [0.0], [0.0], [0.0], [0.0],false)) === String
		@test eltype(batch([1//2 0.0], [0.0])) === String
		@test eltype(batch([1//2 0.0], [0.0], [0.0], [0.0], [0.0],false)) === String
		@test eltype(batch([1//2 0.0], [0.0])) === String
		@test eltype(batch([1//2 0.0], [0.0], [0.0], [0.0], [0.0],false)) === String
		@test eltype(batch([e pi], [0.0])) === String
		@test eltype(batch([e pi], [0.0], [0.0], [0.0], [0.0],false)) === String

		@test eltype(batch([5.0 4 3], [0.0])) === String
		@test eltype(batch([5.0 4 3], [0.0], [0.0],[0.0],[0.0],false)) === String
		@test eltype(batch([5.0 4 3//1], [0.0])) === String
		@test eltype(batch([5.0 4 3//1], [0.0], [0.0],[0.0],[0.0],false)) === String
		@test eltype(batch([5.0 4 pi], [0.0])) === String
		@test eltype(batch([5.0 4 pi], [0.0], [0.0],[0.0], [0.0], false))		=== String

		@test eltype(batch([5.0 4 3 2], [0.0])) === String
		@test eltype(batch([5.0 4 3 2], [0.0], [0.0], [0.0],[0.0],false)) === String

		@test eltype(batch([acylDetector, aWDetector], [0.0])) === String
		@test eltype(batch([acylDetector, aWDetector], [0.0], [0.0], [0.0],[0.0],false)) === String

		@test eltype(batch([acylDetector, aBDetector], [0.0])) === String
		@test eltype(batch([acylDetector, aBDetector], [0.0], [0.0], [0.0],[0.0],false)) === String

		@test eltype(batch([aBDetector, aWDetector], [0.0])) === String
		@test eltype(batch([aBDetector, aWDetector], [0.0], [0.0], [0.0],[0.0],false)) === String

		@test eltype(batch([acylDetector, aBDetector, aWDetector], [0.0])) === String
		@test eltype(batch([acylDetector, aBDetector, aWDetector], [0.0], [0.0], [0.0],[0.0],false)) === String
		end  #begin_testset
println()
end  #begin_testset
