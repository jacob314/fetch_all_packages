//
//  PreloadSpriteSheetInfo.hpp
//  ChatboardCore
//
//  Created by mac zhang on 11/02/2018.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef PreloadSpriteSheetInfo_hpp
#define PreloadSpriteSheetInfo_hpp

#include <stdio.h>
#include <string>

using namespace std;
namespace CBIO
{
    class PreloadSpriteSheetInfo
    {
    public:
        PreloadSpriteSheetInfo(string & _jsonPath,string & _imagePath,string & _key)
        {
            m_jsonPath = _jsonPath;
            m_imagePath = _imagePath;
            m_sourceKey = _key;
        }
    protected:
        string m_jsonPath;
        string m_imagePath;
        string m_sourceKey;
    public:
        string & getJsonPath()
        {
            return m_jsonPath;
        }
        string & getImagePath()
        {
            return m_imagePath;
        }
        string & getKey()
        {
            return m_sourceKey;
        }
    };
}
#endif /* PreloadSpriteSheetInfo_hpp */
