#include "jsonutils/json_utils.h"

#include <boost/regex.hpp>
#include <iostream>

#include <file_utils.h>

namespace jsonutils
{
    //Extremely poor regex pattern for matching urls
    constexpr auto URL_PATTERN = "(http|https)://(\\w+\\.)+(\\w)/?(\\w+/{0,1})*";

    boost::optional<rapidjson::Document> loadFromUrl(const std::string& url)
    {
        //Download resource and extract message body
        //Return boost::none if something went wrong, e.g. status code >= 300
        rapidjson::Document doc;
        doc.Parse("{\"source\": \"url\"}");

        return doc;
    }

    boost::optional<rapidjson::Document> loadFromFile(const std::string& file)
    {
        //Load file from local filesystem
        if(!doesFileExist(file))
        {
            return {};
        }

        rapidjson::Document doc;
        doc.Parse("{\"source\": \"file\"}");

        return doc;
    }

    boost::optional<rapidjson::Document> loadJson(const std::string& location)
    {
        const boost::regex pattern{URL_PATTERN};

        if(boost::regex_match(location, pattern))
        {                     
            //Provided location is a URL
            std::cout << "Loading from url" << std::endl;
            return loadFromUrl(location);
        }                     
        else
        {
            //Provided location is a filepath
            std::cout << "Loading from file" << std::endl;
            return loadFromFile(location);
        }
    }
}
