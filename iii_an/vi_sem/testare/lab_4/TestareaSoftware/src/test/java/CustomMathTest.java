/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;
/**
 *
 * @author Andrian
 */
public class CustomMathTest {

  public CustomMathTest() {}

  @BeforeClass
  public static void setUpClass() {}

  @AfterClass
  public static void tearDownClass() {}
  /**
   * Test of sum method, of class CustomMath.
   */
  @Test
  public void testSum() {
    System.out.println("sum");
    int x = 0;
    int y = 0;
    int expResult = 0;
    int result = CustomMath.sum(x, y);
    assertEquals(expResult, result);
    // fail("The test case is a prototype.");
  }
  /**
   * Test of division method, of class CustomMath.
   */
  @Test
  public void testDivisionByZero() {
    int x = 0;
    int y = 0;
    int expResult = 0;
    try {
      int result = CustomMath.division(x, y);
      assertEquals(expResult, result);
      if (y == 0) fail("we shouldnt have reached this point");
    } catch (IllegalArgumentException e) {
    }
  }
}
