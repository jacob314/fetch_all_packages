//
//  ServerInfo.hpp
//  ChatboardCore
//
//  Created by mac zhang on 21/03/2018.
//  Copyright © 2018 mac zhang. All rights reserved.
//

#ifndef ServerInfo_hpp
#define ServerInfo_hpp

#include <stdio.h>
#include <string>
using namespace std;
namespace CBIO
{
    enum class ServerProtocol
    {
        HTTP,
        HTTPS,
        WS,
        WSS
    };
    class ServerInfo
    {
    protected:
        string m_address;
        string m_port;
        ServerProtocol m_protocolType;
        string m_protocol;
    public:
        bool init(const char * _address,const char * _port,const char * _protocol);
        string & address()
        {
            return m_address;
        }
        string & protocol()
        {
            return m_protocol;
        }
        ServerProtocol protocolType()
        {
            return m_protocolType;
        }
        string & port()
        {
            return m_port;
        }
    };
}
#endif /* ServerInfo_hpp */
