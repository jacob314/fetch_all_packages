//
//  PageControlInfo.hpp
//  ChatboardCore
//
//  Created by mac zhang on 15/03/2018.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef PageControlInfo_hpp
#define PageControlInfo_hpp

#include <string>
namespace CBIO
{
    class page_controller_info
    {
    public:
        unsigned int _current_page_no = 0;
        unsigned int _page_count_no = 0;
        bool  _flip_allowed = false;
        std::string _name;
    };
}
#endif /* PageControlInfo_hpp */
