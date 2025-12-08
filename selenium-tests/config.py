"""
Configuration file for Selenium tests
Contains base URLs, timeouts, and test credentials
"""

import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Base Configuration
BASE_URL = os.getenv('TEST_BASE_URL', 'http://localhost:3000')
DASHBOARD_URL = f'{BASE_URL}/dashboard'

# Timeouts (in seconds)
IMPLICIT_WAIT = 10
EXPLICIT_WAIT = 15
PAGE_LOAD_TIMEOUT = 30

# Test User Credentials
TEST_EMAIL = os.getenv('TEST_EMAIL', 'testuser@example.com')
TEST_PASSWORD = os.getenv('TEST_PASSWORD', 'testpass123')

# New User for Registration Tests
NEW_USER_EMAIL = os.getenv('NEW_USER_EMAIL', 'newuser@example.com')
NEW_USER_PASSWORD = os.getenv('NEW_USER_PASSWORD', 'newpass123')

# Chrome Options
HEADLESS = True  # Set to True for headless mode
WINDOW_SIZE = "1920,1080"

# Screenshot Directory
SCREENSHOT_DIR = 'screenshots'
