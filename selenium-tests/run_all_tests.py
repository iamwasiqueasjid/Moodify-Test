"""
Master Test Runner
Runs exactly 10 test cases for the Moodify application
"""

import unittest
import sys

# Import all test classes
from test_authentication import AuthenticationTests
from test_dashboard import DashboardTests
from test_navigation_ui import NavigationUITests


def run_all_tests():
    """Run all 10 test cases and generate report"""
    
    # Create test suite
    loader = unittest.TestLoader()
    suite = unittest.TestSuite()
    
    # Add specific test cases (10 total)
    # Test Cases 1-6: Authentication
    suite.addTests(loader.loadTestsFromTestCase(AuthenticationTests))
    
    # Test Cases 7-9: Dashboard
    suite.addTests(loader.loadTestsFromTestCase(DashboardTests))
    
    # Test Case 10: Logout
    suite.addTests(loader.loadTestsFromTestCase(NavigationUITests))
    
    # Run tests with verbose output
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)
    
    # Print summary
    print("\n" + "="*70)
    print("TEST SUMMARY - 10 TEST CASES")
    print("="*70)
    print(f"Total Tests Run: {result.testsRun}")
    print(f"Successes: {result.testsRun - len(result.failures) - len(result.errors)}")
    print(f"Failures: {len(result.failures)}")
    print(f"Errors: {len(result.errors)}")
    print("="*70)
    
    # Return exit code
    return 0 if result.wasSuccessful() else 1


if __name__ == '__main__':
    sys.exit(run_all_tests())
