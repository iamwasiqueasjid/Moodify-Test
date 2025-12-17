package com.moodify.tests;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class LoginTests extends BaseTest {

    @Test
    public void testNavigateToLoginPage() {
        driver.get(baseUrl);
        // Use dot (.) to check text of button AND its children (p tag)
        WebElement loginButton = driver.findElement(By.xpath("//a[contains(@href, '/dashboard')]//button[contains(., 'Login')]"));
        loginButton.click();
        
        WebElement loginHeader = driver.findElement(By.tagName("h3"));
        assertEquals("Log In", loginHeader.getText());
    }

    @Test
    public void testLoginFormElements() {
        driver.get(baseUrl + "/dashboard");
        
        // Input has no type='email', used placeholder instead
        WebElement emailInput = driver.findElement(By.cssSelector("input[placeholder='Email...']"));
        assertTrue(emailInput.isDisplayed(), "Email input should be displayed");
        
        WebElement passwordInput = driver.findElement(By.cssSelector("input[type='password']"));
        assertTrue(passwordInput.isDisplayed(), "Password input should be displayed");
        
        // Button text is in child p tag
        WebElement submitButton = driver.findElement(By.xpath("//button[contains(., 'Submit')]"));
        assertTrue(submitButton.isDisplayed(), "Submit button should be displayed");
    }

    @Test
    public void testToggleToRegisterAndBack() {
        driver.get(baseUrl + "/dashboard");
        
        // Toggle to Register - this is a direct text child so text() might work but . is safer
        WebElement toggleButton = driver.findElement(By.xpath("//button[contains(., 'Sign Up')]"));
        toggleButton.click();
        
        WebElement header = driver.findElement(By.tagName("h3"));
        assertEquals("Register", header.getText());
        
        // Toggle back to Login
        WebElement switchBackBtn = driver.findElement(By.xpath("//button[contains(., 'Sign In')]"));
        switchBackBtn.click();
        
        WebElement headerLogin = driver.findElement(By.tagName("h3"));
        assertEquals("Log In", headerLogin.getText());
    }

    @Test
    public void testEmptyFormValidation() {
        driver.get(baseUrl + "/dashboard");
        
        WebElement submitButton = driver.findElement(By.xpath("//button[contains(., 'Submit')]"));
        submitButton.click();
        
        WebElement errorMessage = driver.findElement(By.className("text-red-500"));
        assertTrue(errorMessage.getText().contains("Please enter a valid email"), "Error message should be displayed for empty fields");
    }

    @Test
    public void testShortPasswordValidation() {
        driver.get(baseUrl + "/dashboard");
        
        WebElement emailInput = driver.findElement(By.cssSelector("input[placeholder='Email...']"));
        emailInput.sendKeys("test@example.com");
        
        WebElement passwordInput = driver.findElement(By.cssSelector("input[placeholder='Password...']"));
        passwordInput.sendKeys("123");
        
        WebElement submitButton = driver.findElement(By.xpath("//button[contains(., 'Submit')]"));
        submitButton.click();
        
        WebElement errorMessage = driver.findElement(By.className("text-red-500"));
        assertTrue(errorMessage.getText().contains("minimum 6 characters"), "Error message should warn about short password");
    }

    @Test
    public void testInvalidLoginAttempt() {
        driver.get(baseUrl + "/dashboard");
        
        WebElement emailInput = driver.findElement(By.cssSelector("input[placeholder='Email...']"));
        emailInput.sendKeys("nonexistentuser@example.com");
        
        WebElement passwordInput = driver.findElement(By.cssSelector("input[placeholder='Password...']"));
        passwordInput.sendKeys("wrongpassword123");
        
        WebElement submitButton = driver.findElement(By.xpath("//button[contains(., 'Submit')]"));
        submitButton.click();
        
        try {
            Thread.sleep(2000); 
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        WebElement errorMessage = driver.findElement(By.className("text-red-500"));
        
        boolean isUserNotFound = errorMessage.getText().contains("No user found");
        boolean isInvalid = errorMessage.getText().contains("Invalid email or password");
        boolean isAuthFailed = errorMessage.getText().contains("Authentication failed");
        
        assertTrue(isUserNotFound || isInvalid || isAuthFailed, "Should show an authentication error message");
    }
    
    @Test
    public void testRegisterModeLabels() {
        driver.get(baseUrl + "/dashboard");
        
        WebElement toggleButton = driver.findElement(By.xpath("//button[contains(., 'Sign Up')]"));
        toggleButton.click();
        
        WebElement registerText = driver.findElement(By.xpath("//p[contains(text(), 'Already have an account?')]"));
        assertTrue(registerText.isDisplayed(), "Should show 'Already have an account?' text in register mode");
    }
}
