"""
Base test setup for Selenium tests
Provides WebDriver initialization and common utilities
"""

import unittest
import os
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from datetime import datetime
import config


class BaseTest(unittest.TestCase):
    """Base test class with common setup and teardown"""

    @classmethod
    def setUpClass(cls):
        """Set up Chrome driver with headless mode"""
        chrome_options = Options()
        
        if config.HEADLESS:
            chrome_options.add_argument('--headless=new')
            chrome_options.add_argument('--disable-gpu')
        
        chrome_options.add_argument(f'--window-size={config.WINDOW_SIZE}')
        chrome_options.add_argument('--no-sandbox')
        chrome_options.add_argument('--disable-dev-shm-usage')
        chrome_options.add_argument('--disable-blink-features=AutomationControlled')
        chrome_options.add_argument('--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36')
        chrome_options.add_argument('--remote-debugging-port=9222')
        
        # Initialize the driver - let webdriver-manager handle ChromeDriver
        try:
            service = Service(ChromeDriverManager().install())
            cls.driver = webdriver.Chrome(
                service=service,
                options=chrome_options
            )
        except Exception as e:
            print(f"Error initializing Chrome: {e}")
            # Try without explicit service
            cls.driver = webdriver.Chrome(options=chrome_options)
        
        cls.driver.implicitly_wait(config.IMPLICIT_WAIT)
        cls.driver.set_page_load_timeout(config.PAGE_LOAD_TIMEOUT)
        cls.wait = WebDriverWait(cls.driver, config.EXPLICIT_WAIT)

    @classmethod
    def tearDownClass(cls):
        """Close the browser after all tests"""
        if cls.driver:
            cls.driver.quit()

    def setUp(self):
        """Navigate to base URL before each test"""
        self.driver.get(config.BASE_URL)

    def take_screenshot(self, name):
        """Take a screenshot and save it - DISABLED"""
        pass  # Screenshots disabled

    def wait_for_element(self, by, value, timeout=None):
        """Wait for an element to be present"""
        wait_time = timeout if timeout else config.EXPLICIT_WAIT
        wait = WebDriverWait(self.driver, wait_time)
        return wait.until(EC.presence_of_element_located((by, value)))

    def wait_for_element_clickable(self, by, value, timeout=None):
        """Wait for an element to be clickable"""
        wait_time = timeout if timeout else config.EXPLICIT_WAIT
        wait = WebDriverWait(self.driver, wait_time)
        return wait.until(EC.element_to_be_clickable((by, value)))

    def wait_for_url_change(self, old_url, timeout=None):
        """Wait for URL to change from old_url"""
        wait_time = timeout if timeout else config.EXPLICIT_WAIT
        wait = WebDriverWait(self.driver, wait_time)
        wait.until(lambda driver: driver.current_url != old_url)

    def wait_for_url_contains(self, url_part, timeout=None):
        """Wait for URL to contain specific string"""
        wait_time = timeout if timeout else config.EXPLICIT_WAIT
        wait = WebDriverWait(self.driver, wait_time)
        wait.until(EC.url_contains(url_part))
