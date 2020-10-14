package fr.univtln.bruno;

import static org.junit.Assert.assertEquals;
import org.junit.Test;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import java.util.List;
import java.util.ArrayList;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class CalculatorTest {
  private static List<String> list;  
    
  //Executed before all tests  
  @BeforeClass
  public static void init() {
      System.out.println("Using @BeforeClass, executed before all test cases.");
  }  
    
  //Executed before each test  
  @Before
  public void preTest() {
      System.out.println("Using @Before, executed before each test case.");
      list = new ArrayList<>();
      list.add("A");
      list.add("B");
  }    
    
  @Test
  public void evaluatesExpression() {
    Calculator calculator = new Calculator();
    int sum = calculator.evaluate("1+2+3");
    assertEquals(6, sum);
  }
    
  @Test
  public void test1() {
      int size=list.size();
      list.add("Z");
      assertFalse(list.isEmpty());
      assertEquals(size+1, list.size());
      System.out.println("Test 2");    
  }
    
/*  @Test(timeout = 1)
    public void m7() {
        System.out.println("Using @Test(timeout),it can be used to enforce timeout in JUnit4 test case");
        while (true);
  }*/

  @Test(expected = ClassCastException.class)
    public void m8() {
        System.out.println("Using @Test(expected) ,it will check for specified exception during its execution");
        Object o="Test";
        List l = (List)o;
  }  
    
  @Test
  public void test2() {
      System.out.println("Test 3");    
  }
    
  //Executed after each test  
  @After
  public void postTest() {
      System.out.println("Using @After, executed after each test case.");
  }
    
  //Executed after all tests  
  @AfterClass
  public static void end() {
      System.out.println("Using @AfterClass, executed after all test cases.");
      list.clear();
  }  
    
  @Ignore
  @Test
  public void test3() {
    System.out.println("Using @Ignore , this execution is ignored");
  }


    
}