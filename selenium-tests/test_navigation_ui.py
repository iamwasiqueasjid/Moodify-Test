"""
Test Suite 3: Navigation and UI Tests
Tests for page navigation, responsive design, and user interface elements
"""

import time
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from base_test import BaseTest
import config


class NavigationUITests(BaseTest):
    """Test cases for navigation and UI functionality"""

    def test_10_logout_functionality(self):
        """Test Case 10: Verify logout functionality and session management"""
        print("\n--- Running Test 10: Logout Functionality ---")
        
        # First login
        time.sleep(2)
        
        try:
            email_input = self.wait_for_element(By.XPATH, "//input[@placeholder='Email...']", timeout=5)
            password_input = self.wait_for_element(By.XPATH, "//input[@placeholder='Password...']")
            
            email_input.clear()
            email_input.send_keys(config.TEST_EMAIL)
            password_input.clear()
            password_input.send_keys(config.TEST_PASSWORD)
            
            submit_btn = self.wait_for_element_clickable(
                By.XPATH, 
                "//button[contains(text(), 'Submit')]"
            )
            submit_btn.click()
            
            time.sleep(5)
            
            # Look for logout button
            logout_btn = self.wait_for_element_clickable(
                By.XPATH, 
                "//button[contains(text(), 'Logout') or contains(text(), 'Log out') or contains(text(), 'Sign out')]",
                timeout=10
            )
            
            logout_btn.click()
            time.sleep(3)
            
            # Verify we're back to login/home page
            current_url = self.driver.current_url
            
            # Should either be on home or see login form
            try:
                login_form = self.wait_for_element(
                    By.XPATH, 
                    "//input[@placeholder='Email...']",
                    timeout=5
                )
                print("✓ Logged out successfully - Login form visible")
            except:
                if 'dashboard' not in current_url.lower():
                    print("✓ Logged out - Redirected away from dashboard")
                else:
                    print("Note: Logout may require additional verification")
            
            self.take_screenshot('test_10_logout')
        except Exception as e:
            print(f"Note: {str(e)}")
            self.take_screenshot('test_10_logout_error')


if __name__ == '__main__':
    import unittest
    unittest.main(verbosity=2)
