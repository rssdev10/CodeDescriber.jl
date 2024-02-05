using CodeDescriber
using Test

tests = [
    "test_crawler_fs.jl"
]

Test.@testset verbose = true showtiming = true "All tests" begin
    for test in tests
        @info "Test: $test"
        Test.@testset verbose = true "\U1F4C2 $test" begin
            include(test)
        end
    end
end
