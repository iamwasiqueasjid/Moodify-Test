# Moodify - Selenium Test Suite

This directory contains automated Selenium test cases for the Moodify web application using Python and Chrome WebDriver in headless mode.

## Overview

The test suite includes **10 comprehensive test cases** covering:
- Authentication (Login, Signup, Form Validation)
- Dashboard functionality
- Mood tracking and data persistence
- Database integration (Firebase Firestore)
- Logout and session management

## Test Structure

```
selenium-tests/
├── config.py                    # Test configuration and settings
├── base_test.py                 # Base test class with WebDriver setup
├── test_authentication.py       # Test Cases 1-6: Authentication tests
├── test_dashboard.py            # Test Cases 7-9: Dashboard and mood tests
├── test_navigation_ui.py        # Test Case 10: Logout test
├── requirements.txt             # Python dependencies
├── .env                         # Environment variables (create this)
└── screenshots/                 # Test screenshots (auto-generated)
```

## Prerequisites

1. **Python 3.8+** installed
2. **Google Chrome** browser installed
3. **Moodify application running** (default: http://localhost:3000)
4. **Firebase setup** with test user credentials

## Installation

1. Install Python dependencies:
```bash
pip install -r requirements.txt
```

2. Create a `.env` file in the `selenium-tests` directory:
```env
# Application URL
TEST_BASE_URL=http://localhost:3000

# Test User Credentials (must exist in Firebase)
TEST_EMAIL=testuser@example.com
TEST_PASSWORD=testpass123

# New User for Registration Tests
NEW_USER_EMAIL=newuser@example.com
NEW_USER_PASSWORD=newpass123
```

3. **Important**: Create a test user in Firebase Authentication with the credentials specified in `.env`

## Running Tests

### Run All Tests
```bash
# From the selenium-tests directory
python -m unittest discover -s . -p "test_*.py" -v
```

### Run Specific Test Suite
```bash
# Authentication tests (Test Cases 1-8)
python test_authentication.py

# Dashboard tests (Test Cases 9-12)
python test_dashboard.py

# Navigation and UI tests (Test Cases 13-18)
python test_navigation_ui.py
```

### Run Individual Test Case
```bash
# Run a specific test
python -m unittest test_authentication.AuthenticationTests.test_01_homepage_loads_successfully
```

## Test Cases (10 Total)

### Authentication Tests (test_authentication.py) - 6 Tests

1. **test_01_homepage_loads_successfully**: Verifies homepage loads with main heading
2. **test_02_login_page_navigation**: Verifies navigation to login page
3. **test_03_login_with_empty_fields**: Tests validation for empty login fields
4. **test_04_login_with_invalid_email**: Tests validation for invalid email format
5. **test_05_login_with_short_password**: Tests password length validation (minimum 6 characters)
6. **test_06_login_with_valid_credentials**: Tests login with valid credentials and dashboard access

### Dashboard Tests (test_dashboard.py) - 3 Tests

7. **test_07_dashboard_statistics_display**: Verifies dashboard displays statistics correctly
8. **test_08_mood_selection_and_data_persistence**: Tests mood selection and Firebase data persistence (read/write)
9. **test_09_calendar_component_display**: Verifies calendar component displays mood history

### Logout Test (test_navigation_ui.py) - 1 Test

10. **test_10_logout_functionality**: Tests logout functionality and session management

## Configuration

### Headless Mode
By default, tests run in headless mode (no browser window). To see the browser:

Edit `config.py`:
```python
HEADLESS = False  # Set to True for headless mode
```

### Timeouts
Adjust timeouts in `config.py`:
```python
IMPLICIT_WAIT = 10      # Implicit wait for elements
EXPLICIT_WAIT = 15      # Explicit wait for conditions
PAGE_LOAD_TIMEOUT = 30  # Maximum page load time
```

## Screenshots

Screenshots are automatically captured for each test and saved in the `screenshots/` directory with timestamps.

## Running on AWS EC2 (Jenkins Pipeline)

For Jenkins integration on AWS EC2:

1. Ensure Chrome and ChromeDriver are installed on EC2
2. Set `HEADLESS = True` in `config.py`
3. Add these options for EC2 compatibility (already included in base_test.py):
```python
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
```

### Jenkins Pipeline Example
```groovy
stage('Run Selenium Tests') {
    steps {
        sh '''
            cd selenium-tests
            pip install -r requirements.txt
            python -m unittest discover -s . -p "test_*.py" -v
        '''
    }
}
```

## Troubleshooting

### Common Issues

1. **ChromeDriver not found**
   - The `webdriver-manager` package automatically downloads ChromeDriver
   - Ensure you have internet connection on first run

2. **Element not found errors**
   - Increase timeouts in `config.py`
   - Ensure application is running before tests
   - Check that page has fully loaded

3. **Authentication failures**
   - Verify test user exists in Firebase Authentication
   - Check credentials in `.env` file
   - Ensure Firebase configuration is correct

4. **Tests fail in headless mode**
   - Some UI elements may behave differently
   - Try running with `HEADLESS = False` to debug
   - Check screenshot files for visual debugging

## Notes

- Tests use **headless Chrome** by default for CI/CD compatibility
- Each test is independent and can run in isolation
- Tests automatically handle waits for dynamic content
- Firebase Firestore is used for data persistence testing
- All tests include screenshot capture for debugging

## Test Coverage

✅ User Authentication (Login with validation)
✅ Form Validation (Email, Password, Empty Fields)
✅ Dashboard Access Control
✅ Mood Selection and Tracking
✅ Data Persistence (Firebase Firestore Read/Write)
✅ Calendar Display with Mood History
✅ Statistics Display
✅ Logout and Session Management

## Support

For issues or questions:
1. Check the screenshots directory for visual debugging
2. Review test output for detailed error messages
3. Ensure all prerequisites are met
4. Verify Firebase configuration and test user exists
