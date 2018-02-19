#pragma once

#include <string>

#include <boost/optional.hpp>
#include <rapidjson/document.h>

namespace jsonutils
{
    /**
     * Location agnostic json loader.
     *
     * @param location location of the json file. Can be either a URL or a file path.
     */
    boost::optional<rapidjson::Document> loadJson(const std::string& url);
}

