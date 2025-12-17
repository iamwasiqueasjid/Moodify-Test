package com.moodify.tests;

import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class HomePageTests extends BaseTest {

    @Test
    public void testHomePageTitle() {
        driver.get(baseUrl);
        WebElement titleElement = driver.findElement(By.tagName("h1"));
        assertTrue(titleElement.getText().contains("Moodify"), "Title should contain 'Moodify'");
    }

    @Test
    public void testHomePageCTAButtons() {
        driver.get(baseUrl);
        WebElement signUpButton = driver.findElement(By.xpath("//a[contains(@href, '/dashboard')]//button[contains(., 'Sign Up')]"));
        assertTrue(signUpButton.isDisplayed(), "Sign Up button should be displayed");
        
        WebElement loginButton = driver.findElement(By.xpath("//a[contains(@href, '/dashboard')]//button[contains(., 'Login')]"));
        assertTrue(loginButton.isDisplayed(), "Login button should be displayed");
    }

    @Test
    public void testCalendarDemoVisibility() {
        driver.get(baseUrl);
        WebElement calendar = driver.findElement(By.className("gap-1"));
        assertTrue(calendar.isDisplayed(), "Calendar demo should be visible on home page");
    }

    @Test
    public void testHeroTextContent() {
        driver.get(baseUrl);
        WebElement heroText = driver.findElement(By.xpath("//p[contains(text(), 'Create your Mood record')]"));
        assertTrue(heroText.isDisplayed(), "Hero description text should be visible");
    }
}
