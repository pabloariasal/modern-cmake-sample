#include <gtest/gtest.h>
#include <jsonutils/json_utils.h>

TEST(JsonUtilsTest, loadFromFile)
{
    auto doc = jsonutils::loadJson("/home/pablo/Documents/test.json");

    ASSERT_TRUE(doc);
    ASSERT_TRUE(doc->HasMember("source"));
    auto source = (*doc)["source"].GetString();
    ASSERT_STREQ("file", source);
}

TEST(JsonUtilsTest, loadFromUrl)
{
    auto doc = jsonutils::loadJson("https://books.com/novels");

    ASSERT_TRUE(doc);
    ASSERT_TRUE(doc->HasMember("source"));
    auto source = (*doc)["source"].GetString();
    ASSERT_STREQ("url", source);
}

int main(int argc, char **argv)
{
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
