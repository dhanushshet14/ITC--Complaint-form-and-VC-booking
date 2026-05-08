//using BenchmarkDotNet.Attributes;
//using ComplaintSystem.Auth;
//using System;
//using Microsoft.VSDiagnostics;

//namespace ComplaintSystem.Benchmarks
//{
//    [CPUUsageDiagnoser]
//    public class AuthenticationServiceBenchmark
//    {
//        private AuthenticationService _authService;
//        [GlobalSetup]
//        public void Setup()
//        {
//            _authService = new AuthenticationService();
//        }

//        [Benchmark]
//        public void ValidateLogin_ValidCredentials()
//        {
//            var result = _authService.ValidateLogin("TestUser", "TestPassword");
//        }

//        [Benchmark]
//        public void ValidateLogin_InvalidCredentials()
//        {
//            var result = _authService.ValidateLogin("InvalidUser", "WrongPassword");
//        }

//        [Benchmark]
//        public void ValidateLogin_EmptyInputs()
//        {
//            var result = _authService.ValidateLogin("", "");
//        }
//    }
//}