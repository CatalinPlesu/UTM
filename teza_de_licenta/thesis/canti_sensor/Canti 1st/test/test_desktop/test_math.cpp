#include <unity.h>
#include "unity_config.h"
#include "math.hpp"

void test_add_true(void) {
  int value = add(1, 1);
  TEST_ASSERT_TRUE(value == 2);
}

void test_add_false(void) {
  int value = add(1, 1);
  TEST_ASSERT_FALSE(value == 3);
}

int main(void) {
  UNITY_BEGIN();
  RUN_TEST(test_add_true);
  RUN_TEST(test_add_false);
  return UNITY_END();
} 