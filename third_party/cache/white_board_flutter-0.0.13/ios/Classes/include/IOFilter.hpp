//
//  IOInterface.hpp
//  ChatboardCore
//
//  Created by mac zhang on 07/12/2017.
//  Copyright © 2017 mac zhang. All rights reserved.
//

#ifndef IOInterface_hpp
#define IOInterface_hpp

#include <string>
#include <vector>
#include "./InputEvent.hpp"

namespace CBIO
{
    using namespace std;
   
    enum class MenuCommand;

    class IOFilter
    {
    public:
        //bool processLocalInput(InputSource _source,TouchEvent _event,int _id,float _x,float _y,float _position,long _ts);
        //bool processRemoteAction(const char * _data);
        bool writeOutputData(const char * _data,int _len);
        bool requestResource(string _resourceId,string _fileName,string _md5sum);
        void requestConvertedResource(string _resourceId,string _fileName,string _md5,string _type);
        void requestResourceWithUrl(string _resourceId,string _url,string _md5sum);
        void raiseFloatingMenu(string &_identify,vector<MenuCommand> & _commandList,float _x,float _y);
        void enterSingleViewMode(string _title,bool _isOffice,int _currentPageNum,int _maxPageNumber);
        void requestHeadpicWithUrl(const std::string & _accountId,const std::string _url);
    };
}
#endif /* IOInterface_hpp */
